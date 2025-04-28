class SoldItems {
  final int muttonPiece;
  final int chickenPiece;
  final int firniPiece;
  final int borhaniMl;
  final Map<String, int> softDrinks;
  final Map<String, int> water;
  final Map<String, int> badamSharbat;
  final Map<String, int>  doi;
  final Map<String, int>  jorda;
  final Map<String, int>  extraRice;



  SoldItems({
    required this.muttonPiece,
    required this.chickenPiece,
    required this.firniPiece,
    required this.borhaniMl,
    required this.softDrinks,
    required this.water,
    required this.badamSharbat,
    required this.doi,
    required this.jorda,
    required this.extraRice,
  });

  factory SoldItems.fromJson(Map<String, dynamic> json) {
    return SoldItems(
      muttonPiece: json['muttonPiece'] ?? 0,
      chickenPiece: json['chickenPiece'] ?? 0,
      firniPiece: json['firniPiece'] ?? 0,
      borhaniMl: json['borhaniMl'] ?? 0,
      softDrinks: Map<String, int>.from((json['softDrinks'] ?? {})),
      water: Map<String, int>.from((json['water'] ?? {})),
      badamSharbat: Map<String, int>.from((json['badamSharbat'] ?? {})),
      doi: Map<String, int>.from((json['doi'] ?? {})),
      jorda: Map<String, int>.from((json['jorda'] ?? {})),
      extraRice: Map<String, int>.from((json['extraRice'] ?? {})),
    );
  }
}

class OrderReport {
  final int totalNetPayableAmount;
  final int totalOrders;
  final SoldItems soldItems;

  OrderReport({
    required this.totalNetPayableAmount,
    required this.totalOrders,
    required this.soldItems,
  });

  factory OrderReport.fromJson(Map<String, dynamic> json) {
    return OrderReport(
      totalNetPayableAmount: json['totalNetPayableAmount'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      soldItems: SoldItems.fromJson(json['soldItems'] ?? {}),
    );
  }
}