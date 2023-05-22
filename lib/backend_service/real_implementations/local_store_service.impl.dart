import 'package:dao_ticketer/types/local_store_service.dart';
import 'package:dao_ticketer/types/ticket.dart';
import "package:localstorage/localstorage.dart" show LocalStorage;
import 'package:flutter/services.dart' show rootBundle;
import 'package:dao_ticketer/types/user.dart' show DAOUser;
import 'dart:convert';

class DAOLocalStoreService extends LocalStoreService {
  late final LocalStorage localStorage;

  static late DAOLocalStoreService _instance;

  DAOLocalStoreService._privateConstructor() {
    localStorage = LocalStorage('ticketer_data.json');
  }

  DAOLocalStoreService() {
    _instance = DAOLocalStoreService._privateConstructor();
  }

  factory DAOLocalStoreService.getSingleton() {
    return _instance;
  }

  Future readyFuture() {
    return _instance.localStorage.ready;
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
  Future<bool> addUserSecret(String userSecret, String userName) async {
    Map<String, dynamic> usersMap =
        json.decode(_instance.localStorage.getItem("usersMap") ?? "{}");

    usersMap.addAll({
      userSecret: {"name": userName, "secret": userSecret}
    });

    await _instance.localStorage.setItem("usersMap", json.encode(usersMap));
    return true;
  }

  @override
  List<DAOUser> getLocalySavedUsers() {
    Map<String, dynamic> usersMap =
        json.decode(_instance.localStorage.getItem("usersMap") ?? "{}");

    List<DAOUser> users = [];

    for (dynamic userJson in usersMap.values) {
      users.add(DAOUser.fromJson(userJson));
    }
    return users;
  }

  @override
  Future clearStorage() {
    return _instance.localStorage.clear();
  }
}
