import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  final List<Product> products = [
    Product(
      id: 1,
      name: "Mouse Wireless",
      description: "Mouse ottico senza fili",
      category: "Elettronica",
      price: 15.99,
      n: 50,
    ),
    Product(
      id: 2,
      name: "Tastiera USB",
      description: "Tastiera layout italiano",
      category: "Elettronica",
      price: 19.90,
      n: 35,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Magazzino"),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {

          final product = products[index];

          return ListTile(
            title: Text(product.name),
            subtitle: Text("Pezzi disponibili: ${product.n}"),
          );
        },
      ),
    );
  }
}