import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myapp/detail.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
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
          if (snapshot.hasError) {
            return Text("Terjadi Kesalahan: ${snapshot.error}");
          }
          // jika ada data
          if (snapshot.hasData) {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 12, mainAxisSpacing: 12, crossAxisCount: 2),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final dynamic product = products![index];
                final num rupiah = product['price'] * 15000;

                final harga = NumberFormat.currency(
                        locale: 'id_ID', symbol: 'Rp.', decimalDigits: 2)
                    .format(rupiah);

                product['rupiah'] = harga;

                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(product: product),
                      )),
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

          return const Center(
            child: CircularProgressIndicator(),
          );
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
