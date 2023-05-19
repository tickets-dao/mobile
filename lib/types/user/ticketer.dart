import 'package:dao_ticketer/types/ticket.dart';
import 'package:dao_ticketer/types/user/user.dart';

abstract class ITicketer extends IDAOUser {
  @override
  UserType userType = UserType.ticketer;
  Future<bool> burnTicket(Ticket ticket, String secret);
}
