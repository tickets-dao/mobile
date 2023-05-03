import "dart:convert";
import "package:cryptography/cryptography.dart";
import "package:dao_ticketer/backend_service/real_implementations/sign.dart";
import 'package:http/http.dart' as http;
import "../../types/ticket.dart";
import "../../types/event.dart";
import "../../types/dao_service.dart";
import "./async_utils.dart";

class RealDAOService implements IDAOService {
  late SimpleKeyPairData _privateKey;

  init(String filename) async {
    _privateKey = await readPrivateKeyFromFile(filename);
  }

  Future<String> invokeWithSign(List<String> params, String fnName) async {
    List<String> signedArgs =
        await sign(_privateKey, 'tickets', 'tickets', fnName, params);

    final List<String> encodedArgs =
        signedArgs.map(base64EncodeString).toList();

    return invokeSmartContract(encodedArgs, fnName);
  }

  @override
  Future<void> buyTicket(Ticket ticket) async {
    final payload = await invokeWithSign([
      ticket.category,
      ticket.sector.toString(),
      ticket.row.toString(),
      ticket.number.toString()
    ], 'buy');

    return jsonDecode(payload)['price'];
  }

  @override
  Future<List<String>> getCategories(String eventID) async {
    // eventID is still unused in blockchain
    final result =
        await queryBlockchain([eventID, 'eventCategories'], 'eventCategories');

    return List<String>.from(jsonDecode(result));
  }

  @override
  Future<List<Event>> getEvents() async {
    // eventID is still unused in blockchain
    final result = await queryBlockchain(['events'], 'events');

    print(result);

    return parseEvents(result);
  }

  @override
  Future<List<Ticket>> getTicketsByEvent(String eventID, String category,
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
