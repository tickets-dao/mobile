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
  Future<List<String>> getCategories(String eventID) => Future.delayed(
      getRandomDuration(3),
      () => [
            "lodge",
            "parter",
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
  Future<void> sendPostRequest(String url, String jsonBody) async {
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Запрос успешно выполнен: ${response.body}');
      } else {
        print(
            'Ошибка при выполнении запроса. Код ответа: ${response.statusCode}');
      }
    } catch (e) {
      print('Произошла ошибка при отправке запроса: $e');
    }
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
  Future<void> burnTicket(String ticketID) {
    // TODO: implement burnTicket
    throw UnimplementedError();
  }

  @override
  Future<String> createEvent(Event e, List<PriceCategory> prices) {
    // TODO: implement createEvent
    throw UnimplementedError();
  }

  @override
  Future<void> createEventCategories(String eid, Map<String, int> categories) {
    // TODO: implement createEventCategories
    throw UnimplementedError();
  }

  @override
  Future<List<Event>> getEventsByIssuer() {
    // TODO: implement getEventsByEmittent
    throw UnimplementedError();
  }

  @override
  Future<int> getUserBalance() {
    // TODO: implement getUserBalance
    throw UnimplementedError();
  }

  @override
  Future<void> sendTicketTo(Ticket t, String destinationUser) {
    // TODO: implement sendTicketTo
    throw UnimplementedError();
  }

  @override
  Future<List<PriceCategory>> getIssuerEventCategories(String eid) {
    // TODO: implement getEmittentEventCategories
    throw UnimplementedError();
  }

  @override
  Future<String> getUserErrorState(String role, String invokeKey) {
    // TODO: implement getUserErrorState
    throw UnimplementedError();
  }

  @override
  Future<bool> setCategoryPrices(List<PriceCategory> categories) {
    // TODO: implement setCategoryPices
    throw UnimplementedError();
  }
}
