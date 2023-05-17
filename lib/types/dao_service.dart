import 'price_category.dart';
import 'event.dart';
import 'ticket.dart';

abstract class IDAOService {
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

  Future<void> burnTicket(Ticket ticket, String secretPhrase);

  Future<int> getUserBalance();

  Future<void> addFunds();

  Future<List<Event>> getEventsByIssuer();

  // returns eventID
  Future<String> createEvent(Event e, List<PriceCategory> categories);

  Future<List<PriceCategory>> getIssuerEventCategories(String eid);

  Future<bool> setCategoryPrices(
      String eventID, List<PriceCategory> categories);

  Future<void> addTicketer(String ticketerAddress);

  Future<List<String>> getTicketers();
}
