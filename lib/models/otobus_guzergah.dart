class OtobusCode {
  String code;
  OtobusCode({required this.code});
}

class OtobusGuzergah {
  final int hatId;
  final String hatAdi;
  final String guzergahBaslangic;
  final String guzergahBitis;
  final String guzergahBilgisi;

  OtobusGuzergah ({
    required this.hatId,
    required this.hatAdi,
    required this.guzergahBaslangic,
    required this.guzergahBitis,
    required this.guzergahBilgisi
  });

  factory OtobusGuzergah.fromJson(Map<String, dynamic> json) {
    return OtobusGuzergah(
      hatId: json['id'] as int,
      hatAdi: json['HatAdi'] as String,
      guzergahBaslangic: json["GuzergahBaslangic"],
      guzergahBitis: json["GuzergahBitis"],
      guzergahBilgisi: json['GuzergahBilgisi'] as String,
    );
  }
}