import 'dart:io';

import 'package:flutter/material.dart';
import 'package:not_defteri_uygulamasi/models/kategori.dart';
import 'package:not_defteri_uygulamasi/utils/database_helper.dart';
import 'package:not_defteri_uygulamasi/utils/not_detay.dart';

import 'kategori_islemleri.dart';
import 'models/notlar.dart';

void main() => runApp(MyApp());

int secilenMenuItem = 0;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Not Defteri Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatefulWidget {
  @override
  _NotListesiState createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavMenu(),
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
              tooltip: "Kategoriler",
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _kategorilerSayfasinaGit(context);
                      },
                      leading: Icon(
                        Icons.library_books,
                        color: Colors.orangeAccent,
                      ),
                      title: Text(
                        "Kategoriler",
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Uygulama Hakkında"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Center(
                                      child: Text("Yapımcı : Cihat İslam Dede",style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    SizedBox(height: 10,),
                                    Center(
                                      child: Text("Uygulama Kullanımı:",style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Center(
                                      child: Text(
                                          "1- Sağ alttaki + butonundan yeni not ekleyebilirsiniz.",style: TextStyle(fontSize: 14),),
                                    ),
                                    Center(
                                      child: Text(
                                          "2- Sağ alttaki düzenle butonundan yeni kategori ekleyebilirsiniz.",style: TextStyle(fontSize: 14),),
                                    ),
                                    Center(
                                      child: Text(
                                          "3- Sağ üstteki kategoriler bölümünden kategorilerinizi düzenleyebilirsiniz.",style: TextStyle(fontSize: 14),),
                                    ),
                                    Center(
                                      child: Text(
                                        "4- Notları görüntülemek,silmek veya güncellemek için üstüne tıklayabilirsiniz.",style: TextStyle(fontSize: 14),),
                                    ),
                                    Center(
                                      child: Text(
                                        "5- Alttaki kısımdan önceliğe veya son eklenme tarihine göre sırayabilirsiniz.",style: TextStyle(fontSize: 14),),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("KAPAT"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      leading: Icon(
                        Icons.info,
                        color: Colors.blue,
                      ),
                      title: Text(
                        "Uygulama Hakkında",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ];
              }),
        ],
        title: Center(
          child: Text("Not Defterim"),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "KategoriEkle",
            onPressed: () {
              kategoriEkleMethod(context);
            },
            child: Icon(
              Icons.mode_edit,
              color: Colors.white,
            ),
            tooltip: "Kategori Ekle",
            backgroundColor: Colors.red,
            mini: true,
          ),
          FloatingActionButton(
            heroTag: "NotEkle",
            backgroundColor: Colors.black,
            tooltip: "Not Ekle",
            onPressed: () => _detaySayfasinaGit(context),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Notlar(),
    );
  }

  BottomNavigationBar bottomNavMenu() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Eklenme Tarihine Göre Sırala'),
            backgroundColor: Colors.yellow.shade800),
        BottomNavigationBarItem(
          icon: Icon(Icons.notification_important),
          title: Text('Önceliğe Göre Sırala'),
          backgroundColor: Colors.red.shade600,
        ),
      ],
      type: BottomNavigationBarType.shifting,
      currentIndex: secilenMenuItem,
      onTap: (index) {
        setState(() {
          secilenMenuItem = index;
        });
      },
      iconSize: 30,
    );
  }

  void kategoriEkleMethod(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String yeniKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Center(
              child: Text(
                "Kategori Ekle",
                style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w700,
                    color: Colors.orangeAccent),
              ),
            ),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (yeniDeger) {
                      yeniKategoriAdi = yeniDeger;
                    },
                    decoration: InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(),
                    ),
                    validator: (girilenKategoriAdi) {
                      if (girilenKategoriAdi.length < 3) {
                        return "En az 3 karakter giriniz";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  OutlineButton(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.orangeAccent,
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  OutlineButton(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        dataBaseHelper
                            .kategoriEkle(Kategori(yeniKategoriAdi))
                            .then(
                          (kategoriID) {
                            if (kategoriID > 0) {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Kategori eklendi"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                        );
                      }
                    },
                    color: Colors.redAccent,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    NotDetay(baslik: "Yeni Not Ekle")))
        .then((value) => setState(() {}));
  }

  void _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Kategoriler()));
  }
}

class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  List<Not> tumNotlar;
  DataBaseHelper dataBaseHelper;

  @override
  void initState() {
    super.initState();
    tumNotlar = List<Not>();
    dataBaseHelper = DataBaseHelper();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dataBaseHelper.notListesiniGetir(),
        builder: (context, AsyncSnapshot<List<Not>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            tumNotlar = snapshot.data;
            if (secilenMenuItem == 1) {
              tumNotlar.sort((not1, not2) {
                return -not1.notOncelik.compareTo(not2.notOncelik);
              });
            }
            sleep(Duration(milliseconds: 50));
            return ListView.builder(
                itemCount: tumNotlar.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    leading: _oncelikIconuAta(tumNotlar[index].notOncelik),
                    title: Text(
                      tumNotlar[index].notBaslik,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 2,
                      ),
                    ),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Kategori",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      tumNotlar[index].kategoriBaslik,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween),
                            Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Oluşturulma Tarihi",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      dataBaseHelper.dateFormat(DateTime.parse(
                                          tumNotlar[index].notTarih)),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  tumNotlar[index].notIcerik,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      _notSil(tumNotlar[index].notID);
                                    },
                                    child: Text(
                                      "SİL",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 16),
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      _detaySayfasinaGit(
                                          context, tumNotlar[index]);
                                    },
                                    child: Text(
                                      "GÜNCELLE",
                                      style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 16),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return Center(
              child: Center(
                child: Text("Yükleniyor..."),
              ),
            );
          }
        });
  }

  _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotDetay(
          baslik: "Notu Düzenle",
          duzenlenecekNot: not,
        ),
      ),
    );
    setState(() {});
  }

  _oncelikIconuAta(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "DÜŞÜK",
              style: TextStyle(
                  color: Colors.deepOrange.shade400,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey.shade400);
        break;
      case 1:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "ORTA",
              style: TextStyle(
                  color: Colors.deepOrange.shade600,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey.shade400);
      case 2:
        return CircleAvatar(
            radius: 26,
            child: Text(
              "ACİL",
              style: TextStyle(
                  color: Colors.deepOrange.shade800,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey.shade400);
        break;
    }
  }

  void _notSil(int notID) {
    dataBaseHelper.notSil(notID).then((silinenID) {
      if (silinenID != 0) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Not Silindi")));
      }
      setState(() {});
    });
  }
}
