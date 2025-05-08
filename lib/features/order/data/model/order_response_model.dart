class Order {
  String? id ;
  List<Cart> cartItems;
  int subtotalAmount;
  int paidAmount;
  int changeAmount;
  DateTime orderDate;
  int discountAmount;
  String customerPhoneNumber;
  int netPayableAmount;
  String orderType;
  String branchId;
  String branchName;
  String managerId;
  String managerName;
  String branchPhoneNumber;
  String branchAddress;
  String paymentMode;
  String paymentStatus;
  String tableNumber;
  String invoiceNumber;
  String branchBinNumber;
  String serialNumber;
  String deliveryAddress;
  String customerName ;
  String deliveryDateAndTime;
  String note;
  String orderStatus;
  int deliveryFee;
  String deliveryBoyName;
  Order({
    this.id,
    required this.cartItems,
    required this.subtotalAmount,
    required this.paidAmount,
    required this.changeAmount,
    required this.orderDate,
    required this.discountAmount,
    required this.customerPhoneNumber,
    required this.netPayableAmount,
    required this.tableNumber,
    required this.orderType,
    required this.branchId,
    required this.branchName,
    required this.managerId,
    required this.managerName,
    required this.branchPhoneNumber,
    required this.branchAddress,
    required this.paymentMode,
    required this.paymentStatus,
    required this.invoiceNumber,
    required this.branchBinNumber,
    required this.serialNumber,
    required this.deliveryAddress,
    required this.customerName ,
    required this.deliveryDateAndTime ,
    required this.note,
    required this.orderStatus ,
    required this.deliveryFee,
    required this.deliveryBoyName,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      cartItems: (json['cartItems'] as List).map((item) => Cart.fromJson(item)).toList(),
      subtotalAmount: json['subtotalAmount'],
      paidAmount: json['paidAmount'],
      changeAmount: json['changeAmount'],
      orderDate:  DateTime.parse(json['orderDate']).toLocal(),
      discountAmount: json['discountAmount'],
      customerPhoneNumber: json['customerPhoneNumber'],
      netPayableAmount: json['netPayableAmount'],
      tableNumber: json['tableNumber'],
      orderType: json['orderType'],
      branchId: json['branchId'],
      branchName: json['branchName'],
      managerId: json['managerId'],
      managerName: json['managerName'],
      branchPhoneNumber: json['branchPhoneNumber'],
      branchAddress: json['branchAddress'],
      paymentMode: json['paymentMode'],
      paymentStatus: json['paymentStatus'],
      invoiceNumber: json['invoiceNumber'],
      branchBinNumber: json['branchBinNumber'],
      serialNumber: json['serialNumber'],
      deliveryAddress: json['deliveryAddress'],
      customerName: json['customerName'],
      deliveryDateAndTime: json['deliveryDateAndTime'],
      note: json['note'],
      orderStatus: json['orderStatus'],
      deliveryFee: json['deliveryFee'],
      deliveryBoyName: json['deliveryBoyName'],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'cartItems': cartItems.map((e) => e.toMap()).toList(),
      'subtotalAmount': subtotalAmount,
      'paidAmount': paidAmount,
      'changeAmount': changeAmount,
      'orderDate': orderDate,
      'discountAmount': discountAmount,
      'customerPhoneNumber': customerPhoneNumber,
      'netPayableAmount': netPayableAmount,
      'orderType': orderType,
      'branchId': branchId,
      'branchName': branchName,
      'managerId': managerId,
      'managerName': managerName,
      'branchPhoneNumber': branchPhoneNumber,
      'branchAddress': branchAddress,
      'paymentMode': paymentMode,
      'paymentStatus': paymentStatus,
      'tableNumber': tableNumber,
      'invoiceNumber': invoiceNumber,
      'branchBinNumber': branchBinNumber,
      'serialNumber': serialNumber,
      'deliveryAddress': deliveryAddress,
      'customerName': customerName,
      'deliveryDateAndTime': deliveryDateAndTime,
      'note': note,
      'orderStatus': orderStatus,
      'deliveryFee': deliveryFee,
      'deliveryBoyName': deliveryBoyName,
      '_id': id ,
    };
  }

}

class Cart {
  final String productName;
  final int unitPrice;
  final String productID;
  int quantity;
  int price;

  Cart({
    required this.productName,
    required this.unitPrice,
    required this.productID,
    required this.quantity,
  }) : price = unitPrice * quantity;


  Map<String, dynamic> toMap(){
    return {
      'productName': productName,
      'unitPrice': unitPrice,
      'productID': productID,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      productName: json['productName'],
      unitPrice: json['unitPrice'],
      productID: json['productID'],
      quantity: json['quantity'],
    );
  }

  @override
  String toString() {
    return 'Cart{productName: $productName, unitPrice: $unitPrice, productID: $productID, quantity: $quantity, price: $price}';
  }
}


class OrderResponse {
  final List<Order> orders;
  final String? nextPageToken;

  OrderResponse({
    required this.orders,
    this.nextPageToken,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orders: (json['orders'] as List).map((item) => Order.fromJson(item)).toList(),
      nextPageToken: json['nextPageToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((order) => order.toMap()).toList(),
      'nextPageToken': nextPageToken,
    };
  }
}

