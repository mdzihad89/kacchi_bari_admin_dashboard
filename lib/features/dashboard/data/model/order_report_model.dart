import 'package:kacchi_bari_admin_dashboard/features/dashboard/data/model/top_selling_item.dart';

class OrderReport {
  final int totalNetPayableAmount;
  final int totalOrders;
  final SoldItems soldItems;
  final List<TopSellingItemModel> topSellingItems;
  final List<OrderTypeCount> orderTypeCounts;
  final int totalDiscountAmount;
  final int totalSubtotalAmount;


  OrderReport({
    required this.totalNetPayableAmount,
    required this.totalOrders,
    required this.soldItems,
    required this.topSellingItems,
    required this.orderTypeCounts,
    required this.totalDiscountAmount,
    required this.totalSubtotalAmount,

  });

  factory OrderReport.fromJson(Map<String, dynamic> json) {
    return OrderReport(
      totalNetPayableAmount: json['totalNetPayableAmount'] ?? 0,
      totalOrders: json['totalOrders'] ?? 0,
      orderTypeCounts: (json['orderTypeCounts'] as List)
          .map((item) => OrderTypeCount.fromJson(item))
          .toList(),
      soldItems: SoldItems.fromJson(json['soldItems'] ?? {}),
      topSellingItems: (json['topSellingItems'] as List)
          .map((item) => TopSellingItemModel.fromJson(item))
          .toList(),
      totalDiscountAmount: json['totalDiscountAmount'] ?? 0,
      totalSubtotalAmount: json['totalSubtotalAmount'] ?? 0,
    );
  }
}


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


class OrderTypeCount{
  final String orderType;
  final int orderCount;
  OrderTypeCount({
    required this.orderType,
    required this.orderCount,
  });

  factory OrderTypeCount.fromJson(Map<String, dynamic> json) {
    return OrderTypeCount(
      orderType: json['orderType'] ?? '',
      orderCount: json['orderCount'] ?? 0,
    );
  }
}