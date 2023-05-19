import 'package:dao_ticketer/types/user/customer.dart';
import 'package:dao_ticketer/types/user/user.dart';
import 'package:dao_ticketer/types/ticket.dart';

import "./async_utils.dart";

class Customer implements ICustomer {
  @override
  UserType userType = UserType.customer;

  @override
  Future<int> getBalance() => Future.delayed(getRandomDuration(3), () => 321);

  @override
  Future<bool> prepareTicket(Ticket ticket, String secret) {
    var resultSeed = getRandom(10);
    if (resultSeed >= 7) {
      throw "Network error! Try again later.";
    }
    if (resultSeed >= 5) {
      return Future.delayed(getRandomDuration(3), () => false);
    }
    return Future.delayed(getRandomDuration(3), () => true);
  }
}
