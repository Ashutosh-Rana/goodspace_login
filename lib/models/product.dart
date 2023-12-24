class Product {
  final String displayName;
  final String productName;

  Product({required this.displayName, required this.productName});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      displayName: json['displayName'],
      productName: json['productName'],
    );
  }
}
