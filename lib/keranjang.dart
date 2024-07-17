import 'package:flutter/material.dart';
import 'package:myapp/alamat.dart';
import 'package:myapp/main.dart';
import 'package:provider/provider.dart';
import 'package:myapp/provider_produk.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final _namaPenerimaCon = TextEditingController();
  final _alamatPengirimanCon = TextEditingController();

  @override
  void dispose() {
    _namaPenerimaCon.dispose();
    _alamatPengirimanCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: Column(
        children: [
          Expanded(child:
              Consumer<ProviderProduk>(builder: (context, produk, child) {
            return ListView.builder(
              itemCount: produk.jumlahProduk,
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (DismissDirection direction) {
                    if (direction == DismissDirection.endToStart) {
                      Provider.of<ProviderProduk>(context, listen: false)
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
                      child: Image.network(produk.listProduk[index].image),
                    ),
                    title: Text(produk.listProduk[index].title),
                    subtitle:
                        Text(formatRupiah(produk.listProduk[index].price)),
                  ),
                );
              },
            );
          })),
          Expanded(child: TampilanAlamat()),
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
                    onPressed: () => showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.85,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                      width: 60,
                                      child: Divider(
                                        color: Colors.black,
                                        thickness: 2,
                                      ),
                                    ),
                                    const Text(
                                      'Form CoD',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    TextFormField(
                                      controller: _namaPenerimaCon,
                                      decoration: const InputDecoration(
                                          label: Text('Nama Penerima')),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: _alamatPengirimanCon,
                                      maxLines: 3,
                                      decoration: const InputDecoration(
                                          labelText: 'Alamat Pengiriman',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          border: OutlineInputBorder()),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                          style: const ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.purple),
                                            foregroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.white),
                                          ),
                                          onPressed: () {
                                            Alamat alamat = Alamat.fromMap({
                                              'namaPenerima':
                                                  _namaPenerimaCon.text,
                                              'alamatPengiriman':
                                                  _alamatPengirimanCon.text
                                            });

                                            insertAlamat(alamat);

                                            Navigator.pop(context);
                                          },
                                          child: Text('kirim')),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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

class TampilanAlamat extends StatelessWidget {
  const TampilanAlamat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: alamat(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Alamat alamat = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Nama Penerima: ${alamat.namaPenerima.toUpperCase()}'),
                      Text(
                          'Alamat Pengiriman: ${alamat.alamatPengiriman.toUpperCase()}'),
                    ],
                  ),
                );
              },
            );
          }
          return Text('belum ada alamat');
        },
      ),
    );
  }
}
