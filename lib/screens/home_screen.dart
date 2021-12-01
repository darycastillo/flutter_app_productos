import 'package:flutter/material.dart';
import 'package:flutter_app_productos/widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('productos'),
      ),
      body: ListView.builder(
          itemCount: 10, itemBuilder: (_, int index) => const ProductCard()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
