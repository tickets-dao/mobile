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
  Future<List<String>> getCategories(String eventID) => Future.delayed(
      getRandomDuration(3),
      () => [
            TicketCategory.lodge.toString(),
            TicketCategory.parter.toString(),
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
  Future<List<Ticket>> getAvailableTicketsByEventAndCategory(String eventID, String category,
          [int? sector]) =>
      Future.delayed(
          getRandomDuration(3),
          () => [
                Ticket(category, getRandom(40), 1, 1, 2, eventID),
                Ticket(category, getRandom(40), 1, 1, 3, eventID),
                Ticket(category, getRandom(40), 1, 2, 2, eventID),
                Ticket(category, getRandom(40), 1, 2, 3, eventID),
                Ticket(category, getRandom(40), 3, 2, 1, eventID),
                Ticket(category, getRandom(40), 3, 2, 1, eventID),
                Ticket(category, getRandom(40), 3, 2, 1, eventID),
                Ticket(category, getRandom(40), 4, 2, 3, eventID),
                Ticket(category, getRandom(40), 5, 2, 4, eventID),
                Ticket(category, getRandom(40), 5, 2, 3, eventID),
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
}
