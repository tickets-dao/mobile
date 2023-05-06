import 'event.dart';
import 'ticket.dart';

abstract class IDAOService {
  Future<List<Event>> getEvents();

  Future<List<String>> getCategories(String eventID);

  // получение билетов, доступных для покупки(находятся у эмитента, ещё не куплены)
  Future<List<Ticket>> getAvailableTicketsByEventAndCategory(
      String eventID, String category, int sector);

  // price is returned
  Future<int> buyTicket(Ticket ticket);

  Future<void> returnTicket(Ticket ticket);

  Future<List<Ticket>> getTicketsByUser();

  Future<List<Event>> getEventsByID(List<String> eventID);

  Future<void> prepareTicket(Ticket ticket, String secret);

  Future<void> addFunds();
}
