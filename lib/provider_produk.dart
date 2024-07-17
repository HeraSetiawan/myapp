import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderProduk extends ChangeNotifier {
  List<Produk> _listProduk = [];

  List<Produk> get listProduk => _listProduk;

  int get jumlahProduk => _listProduk.length;

  String get totalHarga => totalBayar();

  ProviderProduk(){
    _loadData();
  }

  Future<void> _loadData() async {
    await ambilData();
    notifyListeners();
  }

  totalBayar(){
    num totalBayar = 0;
    for (var produk in _listProduk) {
      totalBayar += produk.price;
    }
    return formatRupiah(totalBayar);
  }

  void masukKeranjang(Produk produk){
    listProduk.add(produk);
    _saveData();
    notifyListeners();
  }

  void hapusKeranjang(Produk produk) {
    listProduk.remove(produk);
    _saveData();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = _listProduk.map((produk) => jsonEncode(produk.toJson())).toList();
    prefs.setStringList('listProduk', jsonList);
  }

  Future<void> ambilData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('listProduk');
    if (jsonList != null) {
    _listProduk.clear();
     _listProduk = jsonList.map((json) => Produk.fromJson(jsonDecode(json))).toList();
     notifyListeners();
    }
  }

}
