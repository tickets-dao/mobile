import 'package:dao_ticketer/backend_service/real_implementations/dao_service.impl.dart';

import 'package:dao_ticketer/types/ticket.dart';

Future<void> main() async {
  final realService = RealDAOService(true);

  print(await realService.getCategories("eventID"));
  print(await realService.getEvents().toString());
  var tickets =
      await realService.getAvailableTicketsByEventAndCategory('', 'parter');
  print('tickets response: ${tickets.toString()}');

  final myTickets = await realService.getTicketsByUser();
  myTickets.map((e) => print(e));

  await realService.init("../keys/user.private");

  await realService.addFunds();
  var ticket = Ticket("parter", 0, 1, 1, 2, "eventID");
  print(await realService.buyTicket(ticket));

  await realService.prepareTicket(ticket, "secret");
}
