import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myapp/detail.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const MyApp(),
      '/detail': (context) => DetailPage()
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toko WakEbok'),
      ),
      body: FutureBuilder(
        future: ambilProduk(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final List products = snapshot.data;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 12, mainAxisSpacing: 12, crossAxisCount: 2),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final Map product = products[index];
                final rupiah = product['price'] * 15000;

                final harga = NumberFormat.currency(
                        locale: 'id_ID', symbol: 'Rp.', decimalDigits: 2)
                    .format(rupiah);
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/detail',
                      arguments: product),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Expanded(child: Image.network(product['image'])),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product['category'].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          product['title'],
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(harga)
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

Future ambilProduk() async {
  final respon = await http.get(Uri.parse('https://fakestoreapi.com/products'));
  if (respon.statusCode == 200) {
    final data = jsonDecode(respon.body);
    return data;
    // return Produk.fromJson(jsonDecode(respon.body) as Map<String, dynamic>);
  } else {
    throw Exception("Gagal ambil data produk");
  }
}

class Produk {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rate;
  final int count;

  const Produk({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.price,
    required this.description,
    required this.rate,
    required this.count,
  });
}
