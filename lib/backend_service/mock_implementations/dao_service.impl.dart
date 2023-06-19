import "package:dao_ticketer/types/price_category.dart";
import 'package:http/http.dart' as http;

import "../../types/ticket.dart";
import "../../types/event.dart";
import "../../types/dao_service.dart";
import "./async_utils.dart";

class MockedDAOService implements IDAOService {
  @override
  Future<int> buyTicket(Ticket ticket) =>
      Future.delayed(getRandomDuration(3), () => getRandom(50));

  @override
  Future<void> addFunds() =>
      Future.delayed(getRandomDuration(3), () => getRandom(50));

  @override
  Future<List<PriceCategory>> getCategories(String eventID) => Future.delayed(
      getRandomDuration(3),
      () => [
            PriceCategory(name: "lodge", price: 100, rows: 2, seats: 10),
            PriceCategory(name: "parter", price: 200, rows: 10, seats: 3),
          ]);

  @override
  Future<List<Event>> getEvents() => Future.delayed(
      getRandomDuration(3),
      () => [
            Event(DateTime.now(), "Loobyanka, 1", "Swan lake", ""),
            Event(DateTime.now(), "Teignmouth", "Radiohead", ""),
            Event(DateTime.now(), "Glastonbury", "Muse", ""),
            Event(DateTime.now(), "Lolapalooza", "Arctic Monkeys", ""),
            Event(DateTime.now(), "London", "Deep Purple", ""),
            Event(DateTime.now(), "Tverskaya", "Serebrennikov 'Vishnyovy Sad'",
                ""),
          ]);

  @override
  Future<List<Ticket>> getAvailableTicketsByEventAndCategory(
          String eventID, String category) =>
      Future.delayed(
          getRandomDuration(3),
          () => [
                Ticket(category, getRandom(40), 1, 2, eventID),
                Ticket(category, getRandom(40), 1, 3, eventID),
                Ticket(category, getRandom(40), 2, 2, eventID),
                Ticket(category, getRandom(40), 2, 3, eventID),
                Ticket(category, getRandom(40), 2, 1, eventID),
                Ticket(category, getRandom(40), 2, 1, eventID),
                Ticket(category, getRandom(40), 2, 1, eventID),
                Ticket(category, getRandom(40), 2, 3, eventID),
                Ticket(category, getRandom(40), 2, 4, eventID),
                Ticket(category, getRandom(40), 2, 3, eventID),
              ]);

  @override
  Future<void> prepareTicket(Ticket ticket, String secret) {
    if (getRandom(10) > 5) {
      throw "Network error! Please try again.";
    }
    return Future.delayed(getRandomDuration(3), () => true);
  }

  @override
  Future<void> returnTicket(Ticket ticket) {
    if (getRandom(10) > 5) {
      throw "Network error! Please try again.";
    }
    return Future.delayed(getRandomDuration(3), () => true);
  }

  @override
  Future<List<Event>> getEventsByID(List<String> eventID) {
    if (getRandom(10) > 5) {
      throw "Network error! Please try again.";
    }
    return Future.delayed(
        getRandomDuration(3),
        () => eventID
            .map((String ei) => Event(DateTime.now(),
                "mocked event ticket address", "mocked event ticket name", ei))
            .toList());
  }

  @override
  Future<List<Ticket>> getTicketsByUser() {
    if (getRandom(10) > 5) {
      throw "Network error! Please try again.";
    }
    return Future.delayed(
        getRandomDuration(3),
        () => [
              Ticket("some category", 200, 1, 2, "eventische"),
              Ticket("some other category", 200, 1, 2, "eventische"),
              Ticket("the best category", 200, 1, 2, "eventische"),
              Ticket("not the best category", 200, 1, 2, "eventische"),
              Ticket("second lowest category", 200, 1, 2, "eventische"),
              Ticket("category", 200, 1, 2, "eventische"),
            ]);
  }

  @override
  Future<void> burnTicket(Ticket t, String tID) {
    return Future.delayed(
      getRandomDuration(3),
    );
  }

  @override
  Future<String> createEvent(Event e, List<PriceCategory> prices) {
    return Future.delayed(
      getRandomDuration(3),
      () => "newely-created-id-333",
    );
  }

  @override
  Future<List<Event>> getEventsByIssuer() {
    return Future.delayed(
        getRandomDuration(3),
        () => [
              Event(DateTime.now(), "Лубянка 2", "Щелкунчик",
                  "test-event-id-string-1"),
              Event(DateTime.now(), "Лубянка 3", "Щелкунчик и Мышиный Король",
                  "test-event-id-string-2"),
              Event(DateTime.now(), "Лубянка 4", "Щелкунчик на лебедином озере",
                  "test-event-id-string-3"),
            ]);
  }

  @override
  Future<int> getUserBalance() {
    return Future.delayed(getRandomDuration(3), () => 2000);
  }

  @override
  Future<void> sendTicketTo(Ticket t, String destinationUser) {
    return Future.delayed(
      getRandomDuration(3),
    );
  }

  @override
  Future<List<PriceCategory>> getIssuerEventCategories(String eid) {
    return Future.delayed(
        getRandomDuration(3),
        () => [
              PriceCategory(name: "Партер", price: 2000, rows: 20, seats: 10),
              PriceCategory(name: "VIP", price: 8000, rows: 5, seats: 4),
              PriceCategory(name: "Балкон", price: 1500, rows: 20, seats: 4),
            ]);
  }

  @override
  Future<bool> setCategoryPrices(String eID, List<PriceCategory> categories) {
    return Future.delayed(
      getRandomDuration(3),
      () => true,
    );
  }

  @override
  Future<void> addTicketer(String ticketerAddress) {
    return Future.delayed(
      getRandomDuration(3),
    );
  }

  @override
  Future<void> deleteTicketer(String ticketerAddress) {
    return Future.delayed(
      getRandomDuration(3),
    );
  }

  @override
  Future<List<String>> getTicketers() {
    return Future.delayed(
        getRandomDuration(3),
        () => [
              "ticketer-1-address",
              "ticketer-2-address",
              "ticketer-3-address",
              "ticketer-4-address",
            ]);
  }
}
