import 'package:dao_ticketer/types/local_store_service.dart';
import 'package:dao_ticketer/types/ticket.dart';
import "package:localstorage/localstorage.dart" show LocalStorage;
import 'package:flutter/services.dart' show rootBundle;
import 'package:dao_ticketer/types/user.dart' show DAOUser;
import 'dart:convert';

class DAOLocalStoreService extends LocalStoreService {
  String? _filename;
  late final LocalStorage localStorage;

  static late DAOLocalStoreService _instance;

  DAOLocalStoreService._privateConstructor() {
    localStorage = LocalStorage('ticketer_data.json');
  }

  DAOLocalStoreService() {
    _instance = DAOLocalStoreService._privateConstructor();
    print("inited localStorageService instance: $_instance");
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
  String? getLocalTicketSecret(Ticket t) {
    return _instance.localStorage
        .getItem("${t.eventID}:${t.category}:${t.row}${t.number}");
  }

  @override
  void setLocalTicketSecret(Ticket t, String secret) {
    _instance.localStorage
        .setItem("${t.eventID}:${t.category}:${t.row}${t.number}", secret);
  }

  @override
  void addUserSecret(String userSecret, String userName) async {
    List<dynamic> usersKeys =
        json.decode(_instance.localStorage.getItem("usersKeys") ?? "[]");
    String userID = "$userName-${usersKeys.length}";
    usersKeys.add(userID);

    Map<String, dynamic> usersMap =
        json.decode(_instance.localStorage.getItem("usersMap") ?? "{}");

    usersMap.addAll({
      userID: {"name": userName, "secret": userSecret}
    });

    await _instance.localStorage.setItem("usersKeys", json.encode(usersKeys));
    await _instance.localStorage.setItem("usersMap", json.encode(usersMap));
  }

  @override
  List<DAOUser> getLocalySavedUsers() {
    Map<String, dynamic> usersMap =
        json.decode(_instance.localStorage.getItem("usersMap") ?? "{}");

    List<DAOUser> users = [];

    for (dynamic userJson in usersMap.values) {
      users.add(DAOUser.fromJson(userJson));
    }
    print('getLocalySavedUsers(): saved json: $usersMap');
    return users;
  }
}
