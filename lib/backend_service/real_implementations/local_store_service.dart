import 'package:dao_ticketer/types/local_store_service.dart';
import 'package:dao_ticketer/types/ticket.dart';
import "package:localstorage/localstorage.dart" show LocalStorage;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class DAOLocalStoreService extends LocalStoreService {
  String? _filename;
  final localStorage = LocalStorage('ticketer_data.json');

  static late DAOLocalStoreService _instance;

  DAOLocalStoreService._privateConstructor();

  DAOLocalStoreService() {
    _instance = DAOLocalStoreService._privateConstructor();
  }

  factory DAOLocalStoreService.getSingleton() {
    return _instance;
  }

  @override
  Future<List<String>> loadKeyFiles() async {
    // Load asset manifest
    final String manifestContent =
        await rootBundle.loadString('AssetManifest.json');

    // Decode it to JSON
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Get list of all asset paths
    final List<String> paths = manifestMap.keys
        .where((String key) => key.startsWith('assets/'))
        .toList();

    return paths;
  }

  @override
  void setSecretKeyFilename(String filename) {
    _instance._filename = filename;
  }

  @override
  String getLocalTicketSecret(Ticket t) {
    return localStorage
        .getItem("${t.eventID}:${t.category}:${t.row}${t.number}");
  }

  @override
  void setLocalTicketSecret(Ticket t, String secret) {
    localStorage.setItem(
        "${t.eventID}:${t.category}:${t.row}${t.number}", secret);
  }
}
