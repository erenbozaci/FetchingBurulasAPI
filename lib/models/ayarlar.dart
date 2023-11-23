class Ayarlar {
   double mainLat;
   double mainLong;

  Ayarlar({required this.mainLat, required this.mainLong});

  factory Ayarlar.fromJSON(Map<String, dynamic> json) {
    return Ayarlar(mainLat: json["mainLat"], mainLong: json["mainLong"]);
  }

   Map<String, dynamic> toJSON() {
     return {
       "mainLat": mainLat,
       "mainLong": mainLong
     };
   }

  void setMainLat(double mainLat) {
    this.mainLat = mainLat;
  }

   void setMainLong(double mainLong) {
     this.mainLong = mainLong;
   }


}
