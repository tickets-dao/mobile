import 'package:privatenotes/types/ticket.dart';
import 'package:privatenotes/types/user.dart';

abstract class ITicketer extends IDAOUser {
  @override
  UserType userType = UserType.ticketer;
  Future<bool> burnTicket(Ticket ticket, String secret);
}
