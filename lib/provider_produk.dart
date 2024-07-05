import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderProduk extends ChangeNotifier {
  final List<Produk> _listProduk = [];

  List<Produk> get listProduk => _listProduk;

  // int get jumlahProduk => _listProduk.length;

  String get totalHarga => totalBayar();

  // Getter untuk memuat jumlah produk dari SharedPreferences
  Future<int> get jumlahProduk async => await loadJmlKeranjang();

// Metode untuk memuat jumlah produk dari SharedPreferences
  Future<int> loadJmlKeranjang() async {
    final prefs = await SharedPreferences.getInstance();
    int jml = prefs.getInt('jumlahProduk') ?? 0;
    notifyListeners();
    return jml;
  }

  void simpanKeranjang() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('jumlahProduk', _listProduk.length);
    notifyListeners();
  }

  String totalBayar() {
    num totalBayar = 0;
    for (var produk in _listProduk) {
      totalBayar += produk.price;
    }
    return formatRupiah(totalBayar);
  }

  void masukKeranjang(Produk produk) {
    listProduk.add(produk);
    notifyListeners();
  }

  void hapusKeranjang(Produk produk) {
    listProduk.remove(produk);
    notifyListeners();
  }
}
