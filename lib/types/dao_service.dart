import 'event.dart';
import 'ticket.dart';

abstract class IDAOService {
  Future<List<Event>> getEvents();
  Future<List<TicketCategory>> getCategories();
  Future<List<Ticket>> getTicketsByEvent(
      String eventID, TicketCategory category, int sector);

  Future<void> buyTicket(Ticket ticket);
  Future<void> returnTicket(Ticket ticket);
  Future<void> prepareTicket(Ticket ticket, String secret);
  Future<void> sendPostRequest(String url, String jsonBody);
}
