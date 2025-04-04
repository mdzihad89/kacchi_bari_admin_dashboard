
 class StaffSalaryPaymentDto {

   final String staffId;
   final int payAmount;
   final String paymentDate;

   StaffSalaryPaymentDto({

     required this.staffId,
     required this.paymentDate,
     required this.payAmount,
   });



    Map<String, dynamic> toJson() {
      return {
        'staffId': staffId,
        'paymentDate': paymentDate,
        'payAmount': payAmount,
      };
    }

 }