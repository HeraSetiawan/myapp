import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:provider/provider.dart';
import 'package:myapp/provider_produk.dart';

class KeranjangPage extends StatelessWidget {
  const KeranjangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: Consumer<ProviderProduk>(
        builder: (context, produk, child) {
          return ListView.builder(
            itemCount: produk.jumlahProduk,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  foregroundImage: NetworkImage(produk.listProduk[index].image),
                ),
                title: Text(produk.listProduk[index].title),
                subtitle: Text(formatRupiah(produk.listProduk[index].price)),
                trailing: Text("1"),
              );
            },
          );
        },
      ),
    );
  }
}
