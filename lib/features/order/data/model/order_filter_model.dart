class OrderFilter{
  final String pageLimit;
  final String? branchId;
  final String? paymentStatus;
  final String? paymentMode;
  final String? orderDate;

  final String? invoiceNumber;
  final String? customerPhoneNumber;
  final String? pageToken;
  final String? serialNumber;
  final String? orderType;

  OrderFilter({
    required this.pageLimit,
    this.branchId,
    this.paymentMode,
    this.paymentStatus,
    this.orderDate,
    this.invoiceNumber,
    this.customerPhoneNumber,
    this.pageToken,
    this.serialNumber,
    this.orderType,
  });

  Map<String,dynamic> toJson(){
    return {

      'limit': pageLimit,
      if(branchId != null) 'branchId': branchId,
      if(paymentMode != null) 'paymentMode': paymentMode,
      if(paymentStatus != null) 'paymentStatus': paymentStatus,
      if(orderDate != null) 'orderDate': orderDate,

      if(invoiceNumber != null) 'invoiceNumber': invoiceNumber,
      if(customerPhoneNumber != null) 'customerPhoneNumber': customerPhoneNumber,
      if(pageToken != null) 'pageToken': pageToken,
      if(serialNumber != null) 'serialNumber': serialNumber,
      if(orderType != null) 'orderType': orderType,
    };
  }


}