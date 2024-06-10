import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map product;
  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: Column(
        children: [
          Text(product['title'])
        ],
      ),
    );
  }
}
