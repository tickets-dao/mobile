import "dart:convert";
import "package:cryptography/cryptography.dart";
import "package:bs58/bs58.dart";
import "package:dao_ticketer/backend_service/real_implementations/sign.dart";
import "package:dao_ticketer/types/price_category.dart";
import "package:dao_ticketer/types/ticket.dart";
import "package:dao_ticketer/types/event.dart";
import "package:dao_ticketer/types/dao_service.dart";
import "package:localstorage/localstorage.dart" show LocalStorage;

import "./async_utils.dart";

const local = '192.168.1.151';
const cloud = '51.250.110.24';

class RealDAOService implements IDAOService {
  String? _filename;
  SimpleKeyPairData? _privateKey;

  late final Uri queryURL;
  late final Uri invokeURL;
  final localStorage = LocalStorage('ticketer_data.json');

  Future<SimpleKeyPairData> _getPrivate() async {
    // We will never need this fallback, but flutter will never shutup abt the
    // keypair that we have to initialize asyncronously and not in the constructor
    // of the backendService that calls this function
    final fallbackKPair = SimpleKeyPairData([],
        publicKey: SimplePublicKey([], type: KeyPairType.ed25519),
        type: KeyPairType.ed25519);

    return await _instance._privateKey?.extract() ?? fallbackKPair;
  }

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
    List<String> signedArgs = await sign(
        await _instance._getPrivate(), 'tickets', 'tickets', fnName, params);

    return doRequest(invokeURL, signedArgs, fnName);
  }

  Future<String> queryWithSign(List<String> params, String fnName) async {
    List<String> signedArgs = await sign(
        await _instance._getPrivate(), 'tickets', 'tickets', fnName, params);

    return doRequest(queryURL, signedArgs, fnName);
  }

  @override
  Future<int> buyTicket(Ticket ticket) async {
    final payload = await invokeWithSign(
        [ticket.category, ticket.row.toString(), ticket.number.toString()],
        'buy');

    return jsonDecode(payload)['price'] as int;
  }

  @override
  Future<List<PriceCategory>> getCategories(String eventID) async {
    // eventID is still unused in blockchain
    final result = await doRequest(
        queryURL, [eventID, 'eventCategories'], 'eventCategories');

    return parsePriceCategories(result);
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
      String eventID, String category) async {
    final result = await doRequest(_instance.queryURL,
        [eventID, category, 'ticketsByCategory'], 'ticketsByCategory');

    print('tickets JSON: $result');

    return parseTickets(result);
  }

  @override
  Future<void> prepareTicket(Ticket ticket, String secret) async {
    final payload = await invokeWithSign([
      ticket.category,
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
  Future<String> addFunds() async {
    final payload = await invokeWithSign([], 'addAllowedBalance');

    print('addfunds response: $payload');
    return payload;
  }

  @override
  Future<List<Event>> getEventsByID(List<String> eventID) async {
    // eventID is still unused in blockchain
    var params = ['eventsByIDs'];
    params.addAll(eventID);

    final result = await doRequest(queryURL, params, 'eventsByIDs');

    print(result);

    return parseEvents(result);
  }

  @override
  Future<List<Ticket>> getTicketsByUser() async {
    final result = await queryWithSign([], 'myTickets');

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

  @override
  Future<int> getUserBalance() async {
    final keyPairData = (await _instance._getPrivate());
    final result = await doRequest(
        queryURL,
        [getAddressByPublicKey(await keyPairData.extractPublicKey()), "RUB"],
        'allowedBalanceOf');

    print(result);

    return int.parse(result.replaceAll('"', ''));
  }

  @override
  String getLocalTicketSecret(Ticket t) {
    return localStorage
        .getItem("${t.eventID}:${t.category}:${t.row}${t.number}");
  }

  @override
  void setLocalTicketSecret(Ticket t, String secret) {
    localStorage.setItem(
        "${t.eventID}:${t.category}:${t.row}${t.number}", secret);
  }

  @override
  // вернуть эвенты, для которых пользователь является эмитентом
  Future<List<Event>> getEventsByIssuer() async {
    final keyPairData = (await _instance._getPrivate());
    final result = await doRequest(
        queryURL,
        [getAddressByPublicKey(await keyPairData.extractPublicKey())],
        'eventsByIssuer');

    return parseEvents(result);
  }

  // returns eventID?
  @override
  Future<String> createEvent(Event e, List<PriceCategory> categories) async {
    final payload = await invokeWithSign(
        [jsonEncode(categories), e.name, e.address, e.startTime.toString()],
        'emission');

    return payload;
  }

  @override
  Future<List<PriceCategory>> getIssuerEventCategories(String eid) async {
    final result = await doRequest(queryURL, [eid], 'eventCategories');

    return parsePriceCategories(result);
  }

  @override
  Future<bool> setCategoryPrices(List<PriceCategory> categories) {
    // TODO: implement setCategoryPices
    throw UnimplementedError();
  }

  // Presuming that each there will be multiple error states:
  // for every role and every invoke.
  // Even if the role isn't necessary, I'd suggest we keep it in the function
  // signature
  // cuz who knows...
  @override
  Future<String> getUserErrorState(String role, String invokeKey) {
    // TODO: implement getUserErrorState
    throw UnimplementedError();
  }
}
