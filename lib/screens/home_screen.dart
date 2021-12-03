import 'package:flutter/material.dart';
import 'package:flutter_app_productos/models/models.dart';
import 'package:flutter_app_productos/screens/screens.dart';
import 'package:provider/provider.dart';

import 'package:flutter_app_productos/widgets/product_card.dart';
import 'package:flutter_app_productos/services/servies.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    if (productService.isLoading) return const LoadingScreen();

    final List<Product> productList = productService.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('productos'),
      ),
      body: ListView.builder(
          itemCount: productService.products.length,
          itemBuilder: (_, int index) => GestureDetector(
              onTap: () {
                productService.selectedProduct = productList[index].copy();
                Navigator.pushNamed(context, 'product');
              },
              child: ProductCard(
                product: productList[index],
              ))),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productService.selectedProduct =
              Product(available: false, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
