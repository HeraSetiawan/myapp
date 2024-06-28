import 'package:flutter/material.dart';
import 'package:myapp/main.dart';

class ProviderProduk extends ChangeNotifier {
  final List<Produk> _listProduk = [];

  List<Produk> get listProduk => _listProduk;

  int get jumlahProduk => _listProduk.length;

  void masukKeranjang(Produk produk) {
    listProduk.add(produk);
    notifyListeners();
  }
}
