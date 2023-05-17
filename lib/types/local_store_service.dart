import 'package:dao_ticketer/types/ticket.dart';

abstract class LocalStoreService {
  Future<List<String>> loadKeyFiles();
  String getLocalTicketSecret(Ticket t);

  void setSecretKeyFilename(String filename);

  void setLocalTicketSecret(Ticket t, String secret);
}
