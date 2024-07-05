import 'package:flutter/material.dart';
import 'package:myapp/main.dart';

class ProviderProduk extends ChangeNotifier {
  final List<Produk> _listProduk = [];

  List<Produk> get listProduk => _listProduk;

  int get jumlahProduk => _listProduk.length;

  String get totalHarga => totalBayar();

  totalBayar(){
    num totalBayar = 0;
    for (var produk in _listProduk) {
      totalBayar += produk.price;
    }
    return formatRupiah(totalBayar);
  }

  void masukKeranjang(Produk produk){
    listProduk.add(produk);
    notifyListeners();
  }

  void hapusKeranjang(Produk produk) {
    listProduk.remove(produk);
    notifyListeners();
  }
}