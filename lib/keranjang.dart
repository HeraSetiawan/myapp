import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:provider/provider.dart';
import 'package:myapp/provider_produk.dart';

class KeranjangPage extends StatelessWidget {
  const KeranjangPage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProviderProduk>(
              builder: (context, produk, child) {
                return FutureBuilder<int>(
                    future: produk.jumlahProduk,
                    builder: (context, snapshot) {
                      int jumlahProduk = snapshot.data!;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: jumlahProduk,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            onDismissed: (DismissDirection direction) {
                              if (direction == DismissDirection.endToStart) {
                                Provider.of<ProviderProduk>(context,
                                        listen: false)
                                    .hapusKeranjang(produk.listProduk[index]);
                              }
                            },
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            key: ValueKey(produk.listProduk[index].id),
                            child: ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                child: Image.network(
                                    produk.listProduk[index].image),
                              ),
                              title: Text(produk.listProduk[index].title),
                              subtitle: Text(
                                  formatRupiah(produk.listProduk[index].price)),
                            ),
                          );
                        },
                      );
                    });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 100,
            child: Column(
              children: [
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Qty'),
                    Consumer<ProviderProduk>(
                        builder: (context, value, child) =>
                            Text(value.jumlahProduk.toString())),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Bayar'),
                    Consumer<ProviderProduk>(
                        builder: (context, value, child) =>
                            Text(value.totalHarga)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.purpleAccent),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.pin_drop),
                    label: const Text('Cash on Delivery')),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Qr Code')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
