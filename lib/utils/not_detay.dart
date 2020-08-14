import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:not_defteri_uygulamasi/models/kategori.dart';
import 'package:not_defteri_uygulamasi/models/notlar.dart';
import 'package:not_defteri_uygulamasi/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  String baslik;
  Not duzenlenecekNot;

  NotDetay({this.baslik, this.duzenlenecekNot});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  List<Kategori> tumKategoriler = [];
  DataBaseHelper dataBaseHelper;
  int kategoriID;
  int secilenOncelik;
  String notBaslik, notIcerik;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    super.initState();
    tumKategoriler = List<Kategori>();
    dataBaseHelper = DataBaseHelper();
    dataBaseHelper.kategorileriGetir().then((kategorileriIcerenMapListesi) {
      for (Map okunanMap in kategorileriIcerenMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }

      if(widget.duzenlenecekNot != null){
          kategoriID = widget.duzenlenecekNot.kategoriID;
          secilenOncelik = widget.duzenlenecekNot.notOncelik;
      }else{
        kategoriID = 1;
        secilenOncelik = 0;
      }

      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.baslik),
      ),
      body: tumKategoriler.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Form(
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 48, right: 8),
                        child: Text(
                          "Kategori ==>",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                items: kategoriItemleriOlustur(),
                                value: widget.duzenlenecekNot != null
                                    ? widget.duzenlenecekNot.kategoriID
                                    : kategoriID,
                                onChanged: (secilenKategoriID) {
                                  setState(() {
                                    kategoriID = secilenKategoriID;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Colors.redAccent, width: 1)),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      initialValue: widget.duzenlenecekNot != null
                          ? widget.duzenlenecekNot.notBaslik
                          : "",
                      validator: (text) {
                        if (text.length < 3) {
                          return "En az 3 karakter giriniz";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (text) {
                        notBaslik = text;
                      },
                      decoration: InputDecoration(
                          hintText: "Not basligini giriniz",
                          labelText: "Başlık",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      initialValue: widget.duzenlenecekNot != null
                          ? widget.duzenlenecekNot.notIcerik
                          : "",
                      onSaved: (text) {
                        notIcerik = text;
                      },
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: "Not icerigini giriniz",
                          labelText: "Notunuz",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 48, right: 8),
                        child: Text(
                          "Öncelik ==>",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                items: _oncelik.map((oncelik) {
                                  return DropdownMenuItem<int>(
                                    child: Text(
                                      oncelik,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    value: _oncelik.indexOf(oncelik),
                                  );
                                }).toList(),
                                value: secilenOncelik,
                                onChanged: (secilenOncelikID) {
                                  setState(() {
                                    secilenOncelik = secilenOncelikID;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Colors.redAccent, width: 1)),
                      )
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "VAZGEÇ",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.deepOrange,
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            var suan = DateTime.now();
                            if(widget.duzenlenecekNot == null){
                              dataBaseHelper.dateFormat(suan);
                              dataBaseHelper
                                  .notEkle(Not(kategoriID, notBaslik, notIcerik,
                                  suan.toString(), secilenOncelik))
                                  .then((kaydedilenNotID) {

                                if (kaydedilenNotID != 0) {
                                  Navigator.pop(context);
                                }
                              });
                            }else{
                              dataBaseHelper.notGuncelle(Not.withID(widget.duzenlenecekNot.notID,kategoriID, notBaslik, notIcerik,
                                  suan.toString(), secilenOncelik)).then((guncellenenID) {
                                if (guncellenenID != 0) {
                                  Navigator.pop(context);
                                }
                              });
                            }


                          }
                        },
                        child: Text(
                          "KAYDET",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                      ),
                    ],
                  )
                ]),
                key: formKey,
              ),
            ),
    );
  }

  List<DropdownMenuItem> kategoriItemleriOlustur() {
    return tumKategoriler
        .map((kategori) => DropdownMenuItem<int>(
              value: kategori.kategoriID,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  kategori.kategoriBaslik,
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ))
        .toList();
  }
}
