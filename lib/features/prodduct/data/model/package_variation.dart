
class PackageVariation {
  int personCount;
  int price;

  PackageVariation({required this.personCount, required this.price});
  Map<String, dynamic> toJson() {
    return {
      'personCount': personCount,
      'price': price,
    };
  }
}

