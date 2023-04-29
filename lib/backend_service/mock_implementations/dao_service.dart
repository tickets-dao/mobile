import 'dart:math';
import 'package:http/http.dart' as http;

import "package:dao_ticketer/types/ticket.dart";
import "package:dao_ticketer/types/event.dart";
import "../../types/dao_service.dart";

int getRandom(int max) => Random().nextInt(max);
Duration getRandomDuration(int max) => Duration(seconds: getRandom(max));

class MockedDAOService implements IDAOService {
  @override
  Future<void> buyTicket(Ticket ticket) => Future.delayed(
      getRandomDuration(3),
      () => [
            Ticket(TicketCategory.lodge, getRandom(50), 1, 2, 3, ""),
            Ticket(TicketCategory.lodge, getRandom(50), 1, 5, 3, ""),
            Ticket(TicketCategory.lodge, getRandom(50), 6, 2, 3, ""),
            Ticket(TicketCategory.lodge, getRandom(50), 3, 2, 3, ""),
            Ticket(TicketCategory.lodge, getRandom(50), 1, 4, 3, ""),
            Ticket(TicketCategory.lodge, getRandom(50), 1, 2, 7, ""),
          ]);

  @override
  Future<List<TicketCategory>> getCategories() => Future.delayed(
      getRandomDuration(3),
      () => [
            TicketCategory.lodge,
            TicketCategory.parter,
          ]);

  @override
  Future<List<Event>> getEvents() => Future.delayed(
      getRandomDuration(3),
      () => [
            Event(DateTime.now(), "Loobyanka, 1", "Swan lake", ""),
            Event(DateTime.now(), "Tintmouth", "Radiohead", ""),
            Event(DateTime.now(), "London", "Deep Purple", ""),
            Event(DateTime.now(), "Tverskaya", "Some shish", ""),
          ]);

  @override
  Future<List<Ticket>> getTicketsByCategory(
          String eventID, TicketCategory category) =>
      Future.delayed(
          getRandomDuration(3),
          () => [
                Ticket(category, getRandom(40), 1, 2, 3, eventID),
                Ticket(category, getRandom(40), 3, 2, 3, eventID),
                Ticket(category, getRandom(40), 4, 2, 3, eventID),
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
