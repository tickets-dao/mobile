import 'package:privatenotes/types/user.dart';

abstract class IArranger extends IDAOUser {
  @override
  UserType userType = UserType.arranger;
  Future<bool> issueTickets();
}
