import 'event.dart';
import 'ticket.dart';

abstract class IDAOService {
  Future<List<Event>> getEvents();
  Future<List<TicketCategory>> getCategories();
  Future<List<Ticket>> getTicketsByCategory(
      String eventID, TicketCategory category);

  Future<void> buyTicket(Ticket ticket);
  Future<void> returnTicket(Ticket ticket);
  Future<void> prepareTicket(Ticket ticket, String secret);
  Future<void> sendPostRequest(String url, String jsonBody);
}
