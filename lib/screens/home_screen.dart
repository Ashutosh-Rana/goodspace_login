import 'package:flutter/material.dart';
import 'package:goodspace_login/api_handler/network_handler.dart';
import 'package:goodspace_login/models/product.dart';

class HomeScreen extends StatelessWidget {
  final NetworkHandler networkHandler = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: networkHandler
            .getInactiveProducts("/api/d2/manage_products/getInActiveProducts"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No products available.'),
            );
          } else {
            List<Product> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.displayName),
                  subtitle: Text(product.productName),
                );
              },
            );
          }
        },
      ),
    );
  }
}
