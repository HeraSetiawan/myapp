import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/keranjang.dart';
import 'package:myapp/provider_produk.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  final Produk product;
  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KeranjangPage(),
                )),
            icon: Badge(
                label: Consumer<ProviderProduk>(
                  builder: (context, produk, child) =>
                      Text(produk.jumlahProduk.toString()),
                ),
                child: const Icon(Icons.shopping_bag)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 200,
                  child: Expanded(child: Image.network(product.image))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatRupiah(product.price),
                    style:
                        TextStyle(color: Colors.amber.shade900, fontSize: 18),
                  ),
                  Text('${product.count} Terjual')
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 14),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      color: Colors.amber.shade800,
                      child: Text(
                        product.category,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      product.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(left: 14, bottom: 14),
              child: Row(
                children: [
                  const Text("Penilaian: "),
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Text(product.rate.toString()),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [Text(product.description)],
                  )),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                "Produk Lainnya",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 100,
              child: ProdukLainnya(
                kategori: product.category,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<ProviderProduk>(context, listen: false)
                    .masukKeranjang(product);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Berhasil tambah produk ${product.title} ke keranjang")));
              },
              child: Container(
                height: 70,
                color: Colors.teal,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_shopping_cart,
                      size: 24,
                      color: Colors.white,
                    ),
                    Text("Tambah Keranjang",
                        style: TextStyle(color: Colors.white, fontSize: 18))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 70,
              color: Colors.deepOrange,
              child: const Center(
                child: Text(
                  "Bayar Sekarang",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// produk Lainya

class ProdukLainnya extends StatelessWidget {
  const ProdukLainnya({super.key, required this.kategori});
  final String kategori;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ambilProdukKategori(kategori),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
              "Terjadi Kesalahan pengambilan produk serupa ${snapshot.error}");
        }

        if (snapshot.hasData) {
          final List produkSerupa = snapshot.data;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: produkSerupa.length,
            itemBuilder: (context, index) {
              final Produk produkSatuan = produkSerupa[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(product: produkSatuan),
                    )),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 4,
                            color: Colors.grey,
                            offset: Offset(2, 1))
                      ]),
                  width: 110,
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(child: Image.network(produkSatuan.image)),
                      Text(
                        produkSatuan.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(formatRupiah(produkSatuan.price))
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
    );
  }
}

Future ambilProdukKategori(String kategori) async {
  final respon = await http
      .get(Uri.parse("https://fakestoreapi.com/products/category/$kategori"));
  if (respon.statusCode == 200) {
    final data = jsonDecode(respon.body) as List;
    return data
        .map<Produk>(
          (json) => Produk.fromJson(json),
        )
        .toList();
  }
  throw Exception("Gagal ambil data produk dari server");
}
