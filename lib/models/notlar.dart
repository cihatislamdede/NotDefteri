class Not {
  int notID;
  int kategoriID;
  String notBaslik;
  String notIcerik;
  String notTarih;
  String kategoriBaslik;
  int notOncelik;

  Not(this.kategoriID, this.notBaslik, this.notIcerik, this.notTarih,
      this.notOncelik); //verileri eklerken kullan

  Not.withID(
      this.notID,
      this.kategoriID,
      this.notBaslik,
      this.notIcerik,
      // verileri dbden okurken kullanilir
      this.notTarih,
      this.notOncelik);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['notID'] = notID;
    map['kategoriID'] = kategoriID;
    map['notBaslik'] = notBaslik;
    map['notIcerik'] = notIcerik;
    map['notOncelik'] = notOncelik;
    map['notTarih'] = notTarih;

    return map;
  }

  Not.fromMap(Map<String, dynamic> map) {
    this.notID = map['notID'];
    this.kategoriID = map['kategoriID'];
    this.notBaslik = map['notBaslik'];
    this.notIcerik = map['notIcerik'];
    this.notOncelik = map['notOncelik'];
    this.notTarih = map['notTarih'];
    this.kategoriBaslik = map['kategoriBaslik'];
  }

  @override
  String toString() {
    return 'Not{notID: $notID, kategoriID: $kategoriID, notBaslik: $notBaslik, notIcerik: $notIcerik, notTarih: $notTarih, notOncelik: $notOncelik}';
  }
}
