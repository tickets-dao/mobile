import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';

import '../../types/ticket.dart';

Future<void> main() async {
  final realService = RealDAOService();

  print(await realService.getCategories("eventID"));
  print(await realService.getEvents().toString());
  var tickets =
      await realService.getAvailableTicketsByEventAndCategory('', 'parter');
  print('tickets response: ${tickets.toString()}');

  // await realService.init("../keys/user.private");
  //
  // // await realService.addFunds();
  // var ticket = Ticket("parter", 0, 1, 1, 1, "eventID");
  // // print(await realService.buyTicket(ticket));
  //
  // await realService.prepareTicket(ticket, "secret");
}
