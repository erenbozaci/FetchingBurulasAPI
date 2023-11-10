class OtobusGuzergah {
  final double hatId;
  final String hatAdi;
  final String guzergahBilgisi;

  OtobusGuzergah ({
    required this.hatId,
    required this.hatAdi,
    required this.guzergahBilgisi
  });

  factory OtobusGuzergah.fromJson(Map<String, dynamic> json) {
    return OtobusGuzergah(
      hatId: json['HatId'] as double,
      hatAdi: json['HatAdi'] as String,
      guzergahBilgisi: json['GuzergahBilgisi'] as String,
    );
  }
}