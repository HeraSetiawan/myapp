import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// model alamat
class Alamat {
  final int? id;
  final String namaPenerima;
  final String alamatPengiriman;

  Alamat({
    this.id,
    required this.namaPenerima,
    required this.alamatPengiriman,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'namaPenerima': namaPenerima,
      'alamatPengiriman': alamatPengiriman,
    };
  }

  factory Alamat.fromMap(Map<String, dynamic> map) {
    return Alamat(
      id: map['id'],
      alamatPengiriman: map['alamatPengiriman'],
      namaPenerima: map['namaPenerima'],
    );
  }

  @override
  String toString() {
    return 'Alamat{id: $id, namaPenerima: $namaPenerima, alamatPengiriman: $alamatPengiriman}';
  }
}

class AlamatProvider extends ChangeNotifier {
  List<Alamat> _listAlamat = [];
  List<Alamat> get listAlamat => _listAlamat;

  AlamatProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    await _alamat();
  }

// inisiasi database
  Future<Database> initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'alamat_database.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE alamat(id INTEGER PRIMARY KEY, namaPenerima TEXT, alamatPengiriman TEXT)');
      },
      version: 1,
    );

    return database;
  }

//fungsi insert alamat
  Future<void> insertAlamat(Alamat alamat) async {
    final db = await initDatabase();
    db.insert('alamat', alamat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await _loadData();
  }

//fungsi mengembalikan alamat
  Future<void> _alamat() async {
    final db = await initDatabase();
    final List<Map<String, Object?>> alamatMap = await db.query('alamat');
    List<Alamat> listAlamat = alamatMap
        .map(
          (e) => Alamat.fromMap(e),
        )
        .toList();
    _listAlamat = listAlamat;
    notifyListeners();
  }
}
