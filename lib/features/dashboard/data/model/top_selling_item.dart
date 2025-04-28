class TopSellingItemModel{

  final String productName;
  final int  totalQuantity;
  final  int unitPrice;
  final int totalPrice;
  TopSellingItemModel({
    required this.productName,
    required this.totalQuantity,
    required this.unitPrice,
  }) : totalPrice = unitPrice * totalQuantity;


  factory TopSellingItemModel.fromJson(Map<String, dynamic> json) {
    return TopSellingItemModel(
      productName: json['productName'] ?? '',
      totalQuantity: json['totalQuantity'] ?? 0,
      unitPrice: json['unitPrice'] ?? 0,
    );
  }

}