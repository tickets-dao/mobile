import 'price_category.dart';
import 'event.dart';
import 'ticket.dart';
import 'price_category.dart';

abstract class IDAOService {
  Future<String> getUserErrorState(String role, String invokeKey);

  Future<List<Event>> getEvents();

  Future<List<PriceCategory>> getCategories(String eventID);

  // получение билетов, доступных для покупки(находятся у эмитента, ещё не куплены)
  Future<List<Ticket>> getAvailableTicketsByEventAndCategory(
      String eventID, String category);

  // price is returned
  Future<int> buyTicket(Ticket ticket);

  Future<void> returnTicket(Ticket ticket);

  Future<List<Ticket>> getTicketsByUser();

  Future<List<Event>> getEventsByID(List<String> eventID);

  Future<void> sendTicketTo(Ticket t, String destinationUser);

  Future<void> prepareTicket(Ticket ticket, String secret);

  String getLocalTicketSecret(Ticket t);
  void setLocalTicketSecret(Ticket t, String secret);

  Future<void> burnTicket(String ticketID);

  Future<int> getUserBalance();

  Future<void> addFunds();

  Future<List<Event>> getEventsByIssuer();

  // returns eventID
  Future<String> createEvent(Event e, List<PriceCategory> categories);

  Future<List<PriceCategory>> getIssuerEventCategories(String eid);

  Future<bool> setCategoryPrices(List<PriceCategory> categories);
}
