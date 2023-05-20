import 'package:dao_ticketer/types/user.dart';
import 'package:dao_ticketer/types/ticket.dart';

abstract class LocalStoreService {
  Future<List<String>> loadKeyFiles();
  String? getLocalTicketSecret(Ticket t);

  void setSecretKeyFilename(String filename);

  void setLocalTicketSecret(Ticket t, String secret);

  void addUserSecret(String userSecret, String userName);
  List<DAOUser> getLocalySavedUsers();
}