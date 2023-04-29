import 'package:privatenotes/types/ticket.dart';
import 'package:privatenotes/types/user.dart';

abstract class ICustomer extends IDAOUser {
  @override
  UserType userType = UserType.customer;
  Future<bool> prepareTicket(Ticket ticket, String secret);
}
