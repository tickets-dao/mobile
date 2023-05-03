import 'event.dart';
import 'ticket.dart';

abstract class IDAOService {
  Future<List<Event>> getEvents();

  Future<List<String>> getCategories(String eventID);

  Future<List<Ticket>> getTicketsByEventAndCategory(
      String eventID, String category, int sector);

  // price is returned
  Future<int> buyTicket(Ticket ticket);

  Future<void> returnTicket(Ticket ticket);

  Future<void> prepareTicket(Ticket ticket, String secret);
}
