import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> product;
  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 200,
                child: Expanded(child: Image.network(product['image']))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product['rupiah'].toString(),
                  style: TextStyle(color: Colors.amber.shade900, fontSize: 18),
                ),
                Text('${product['rating']['count']} Terjual')
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    color: Colors.amber.shade800,
                    child: Text(
                      product['category'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    product['title'],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [Text(product['description'])],
                )),
          )
        ],
      ),
    );
  }
}
