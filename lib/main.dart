import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myapp/detail.dart';
import 'package:myapp/provider_produk.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ProviderProduk(),
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Produk>> futureProduk;

  @override
  void initState() {
    futureProduk = ambilProduk();
    super.initState();
  }

  void tombolSuka(product) {
    setState(() {
      product.isFavorit = !product.isFavorit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Toko WakEbok'),
      ),
      body: FutureBuilder(
        future: futureProduk,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // jika ada data
          if (snapshot.hasData) {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 12, mainAxisSpacing: 12, crossAxisCount: 2),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final Produk product = products[index];

                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(product: product),
                      )),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Align(child: Image.network(product.image))),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            product.category.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          product.title,
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatRupiah(product.price),
                              style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () => tombolSuka(product),
                                  icon: Icon(
                                    product.isFavorit
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: Colors.pink,
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Text("Terjadi Kesalahan: ${snapshot.error}");
        },
      ),
    );
  }
}

String formatRupiah(num uang) {
  final format =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);
  return format.format(uang * 15000);
}

Future<List<Produk>> ambilProduk() async {
  final respon = await http.get(Uri.parse('https://fakestoreapi.com/products'));
  if (respon.statusCode == 200) {
    final data = jsonDecode(respon.body) as List;
    return data
        .map<Produk>(
          (json) => Produk.fromJson(json),
        )
        .toList();
  } else {
    throw Exception("Gagal ambil data produk");
  }
}

class Produk {
  final int id;
  final String title;
  final num price;
  final String description;
  final String category;
  final String image;
  final num rate;
  final int count;
  bool isFavorit;

  Produk({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.price,
    required this.description,
    required this.rate,
    required this.count,
    this.isFavorit = false,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
        id: json['id'] as int,
        title: json['title'] as String,
        category: json['category'] as String,
        image: json['image'] as String,
        price: json['price'] as num,
        description: json['description'] as String,
        rate: json['rating']['rate'] as num,
        count: json['rating']['count'] as int);
  }
}
