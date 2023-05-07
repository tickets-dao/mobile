import "dart:convert";
import "package:cryptography/cryptography.dart";
import "package:dao_ticketer/backend_service/real_implementations/sign.dart";
import "package:dao_ticketer/types/ticket.dart";
import "package:dao_ticketer/types/event.dart";
import "package:dao_ticketer/types/dao_service.dart";

import "./async_utils.dart";

const local = 'localhost';
const cloud = '51.250.110.24';

class RealDAOService implements IDAOService {
  String? _filename;
  SimpleKeyPairData? _privateKey;

  late final Uri queryURL;
  late final Uri invokeURL;

  // lines 19 through 36 make this class a singleton
  RealDAOService._privateConstructor([bool? isLocal]) {
    late String address;
    if (isLocal ?? false) {
      address = local;
    } else {
      address = cloud;
    }

    queryURL = Uri.parse('http://$address:9001/query');
    invokeURL = Uri.parse('http://$address:9001/invoke');
  }

  static late final RealDAOService _instance;

  RealDAOService([bool? isLocal]) {
    _instance = RealDAOService._privateConstructor(isLocal);
    print('realdaoservice public constructor called, instance:');
    print(_instance);
  }

  factory RealDAOService.getSingleton() {
    return _instance;
  }

  // необходимо вызвать перед инвоуком
  // инициализация ключа - async, поэтому нельзя вызывать в конструкторе
  init(String filename) async {
    if (_instance._privateKey != null) return;
    _instance._filename = filename;
    _instance._privateKey = await readPrivateKeyFromFile(filename);
  }

  Future<String> invokeWithSign(List<String> params, String fnName) async {
    List<String> signedArgs =
        await sign(_instance._privateKey, 'tickets', 'tickets', fnName, params);

    return doRequest(invokeURL, signedArgs, fnName);
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
    final result = await doRequest(_instance.queryURL,
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
  // TODO: update
  Future<void> returnTicket(Ticket ticket) {
    if (getRandom(10) > 5) {
      throw "Network error! Please try again.";
    }
    return Future.delayed(getRandomDuration(3), () => true);
  }

  @override
  Future<void> addFunds() async {
    final payload = await invokeWithSign([], 'addAllowedBalance');

    print('addfunds response: $payload');
  }

  @override
  Future<List<Event>> getEventsByID(List<String> eventID) async {
    // eventID is still unused in blockchain
    var params = ['eventsByID'];
    params.addAll(eventID);

    final result = await doRequest(queryURL, params, 'eventsByID');

    print(result);

    return parseEvents(result);
  }

  @override
  Future<List<Ticket>> getTicketsByUser() async {
    final result = await doRequest(queryURL, ['myTickets'], 'myTickets');

    print(result);

    return parseTickets(result);
  }

  @override
  Future<void> sendTicketTo(Ticket t, String destinationUser) {
    // TODO: implement sendTicketTo
    throw UnimplementedError();
  }

  @override
  Future<void> burnTicket(String ticketID) {
    // TODO: implement burnTicket
    throw UnimplementedError();
  }
}
