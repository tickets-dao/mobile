import 'package:dao_ticketer/types/ticket.dart';
import 'package:dao_ticketer/types/user/user.dart';

abstract class ICustomer extends IDAOUser {
  @override
  UserType userType = UserType.customer;
  Future<bool> prepareTicket(Ticket ticket, String secret);
}
