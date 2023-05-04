import "dart:convert";
import "package:cryptography/cryptography.dart";
import "package:dao_ticketer/backend_service/real_implementations/sign.dart";
import "../../types/ticket.dart";
import "../../types/event.dart";
import "../../types/dao_service.dart";
import "./async_utils.dart";

const local = 'localhost';
const cloud = '51.250.110.24';

class RealDAOService implements IDAOService {
  late SimpleKeyPairData _privateKey;

  late final Uri queryURL;
  late final Uri invokeURL;

  RealDAOService([bool? isLocal]) {
    late String address;
    if (isLocal ?? false) {
      address = local;
    } else {
      address = cloud;
    }

    queryURL = Uri.parse('http://$address:9001/query');
    invokeURL = Uri.parse('http://$address:9001/invoke');
  }

  // необходимо вызвать перед инвоуком
  // инициализация ключа - async, поэтому нельзя вызывать в конструкторе
  init(String filename) async {
    _privateKey = await readPrivateKeyFromFile(filename);
  }

  Future<String> invokeWithSign(List<String> params, String fnName) async {
    List<String> signedArgs =
        await sign(_privateKey, 'tickets', 'tickets', fnName, params);

    final List<String> encodedArgs =
        signedArgs.map(base64EncodeString).toList();

    return doRequest(invokeURL, encodedArgs, fnName);
  }

  @override
  Future<int> buyTicket(Ticket ticket) async {
    final payload = await invokeWithSign([
      ticket.category,
      ticket.sector.toString(),
      ticket.row.toString(),
      ticket.number.toString()
    ], 'buy');

    return jsonDecode(payload)['price'] as int;
  }

  @override
  Future<List<String>> getCategories(String eventID) async {
    // eventID is still unused in blockchain
    final result = await doRequest(
        queryURL, [eventID, 'eventCategories'], 'eventCategories');

    return List<String>.from(jsonDecode(result));
  }

  @override
  Future<List<Event>> getEvents() async {
    // eventID is still unused in blockchain
    final result = await doRequest(queryURL, ['events'], 'events');

    print(result);

    return parseEvents(result);
  }

  @override
  Future<List<Ticket>> getAvailableTicketsByEventAndCategory(
      String eventID, String category,
      [int? sector]) async {
    final result = await doRequest(queryURL,
        [eventID, category, 'ticketsByCategory'], 'ticketsByCategory');

    print('tickets JSON: $result');

    return parseTickets(result);
  }

  @override
  Future<void> prepareTicket(Ticket ticket, String secret) async {
    final payload = await invokeWithSign([
      ticket.category,
      ticket.sector.toString(),
      ticket.row.toString(),
      ticket.number.toString(),
      generateMd5(secret),
    ], 'prepare');

    print('after prepare got $payload');
  }

  @override
  //TODO update
  Future<void> returnTicket(Ticket ticket) {
    if (getRandom(10) > 5) {
      throw "Network error! Please try again.";
    }
    return Future.delayed(getRandomDuration(3), () => true);
  }

  @override
  Future<void> addFunds() async {
    final payload = await invokeWithSign([], 'addAlowedBalance');

    print('addfunds response: $payload');
  }
}
