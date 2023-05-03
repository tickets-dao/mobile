import 'event.dart';
import 'ticket.dart';

abstract class IDAOService {
  Future<List<Event>> getEvents();

  Future<List<String>> getCategories(String eventID);

  Future<List<Ticket>> getTicketsByEvent(
      String eventID, String category, int sector);

  Future<void> buyTicket(Ticket ticket);

  Future<void> returnTicket(Ticket ticket);

  Future<void> prepareTicket(Ticket ticket, String secret);

  Future<void> sendPostRequest(String url, String jsonBody);
}
