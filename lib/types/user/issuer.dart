import 'package:dao_ticketer/types/user/user.dart';

abstract class IIssuer extends IDAOUser {
  @override
  UserType userType = UserType.issuer;
  Future<bool> issueTickets();
}
