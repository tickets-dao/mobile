import "dart:convert";
import "package:cryptography/cryptography.dart";
import "package:bs58/bs58.dart";
import "package:dao_ticketer/backend_service/real_implementations/sign.dart";
import "package:dao_ticketer/types/price_category.dart";
import "package:dao_ticketer/types/ticket.dart";
import "package:dao_ticketer/types/event.dart";
import "package:dao_ticketer/types/dao_service.dart";

import "./async_utils.dart";

const local = '192.168.1.151';
const cloud = '51.250.110.24';

class RealDAOService implements IDAOService {
  SimpleKeyPairData? _privateKey;

  late final Uri queryURL;
  late final Uri invokeURL;

  static late RealDAOService _instance;

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

  RealDAOService([bool? isLocal]) {
    _instance = RealDAOService._privateConstructor(isLocal);
    print(_instance.queryURL.toString());
  }

  factory RealDAOService.getSingleton() {
    return _instance;
  }

  Future<SimpleKeyPairData> _getPrivate() async {
    // We will never need this fallback, but flutter will never shutup abt the
    // keypair that we have to initialize asyncronously and not in the constructor
    // of the backendService that calls this function
    final fallbackKPair = SimpleKeyPairData([],
        publicKey: SimplePublicKey([], type: KeyPairType.ed25519),
        type: KeyPairType.ed25519);

    return await _instance._privateKey?.extract() ?? fallbackKPair;
  }

  // необходимо вызвать перед инвоуком
  // инициализация ключа - async, поэтому нельзя вызывать в конструкторе
  init(String fileString) async {
    if (_instance._privateKey != null) return;
    _instance._privateKey = await readPrivateKeyFromString(fileString);
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
    final payload = await invokeWithSign([
      ticket.eventID,
      ticket.category,
      ticket.row.toString(),
      ticket.number.toString()
    ], 'buy');

    return jsonDecode(payload)['price'] as int;
  }

  @override
  Future<List<PriceCategory>> getCategories(String eventID) async {
    // eventID is still unused in blockchain
    final result = await doRequest(queryURL, [eventID], 'eventCategories');

    return parsePriceCategories(result);
  }

  @override
  Future<List<Event>> getEvents() async {
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
      ticket.eventID,
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

    final result =
        await doRequest(queryURL, [jsonEncode(eventID)], 'eventsByIDs');

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
  Future<void> sendTicketTo(Ticket t, String destinationUser) async {
    final keyPairData = await _instance._getPrivate();
    final payload = await invokeWithSign([
      getAddressByPublicKey(await keyPairData.extractPublicKey()),
      destinationUser,
      t.eventID,
      t.category,
      t.row.toString(),
      t.number.toString()
    ], 'transferTo');

    print('transfer $payload succeeded');
  }

  @override
  Future<void> burnTicket(Ticket ticket, String secretPhrase) async {
    final payload = await invokeWithSign([
      ticket.eventID,
      ticket.category,
      ticket.row.toString(),
      ticket.number.toString(),
      secretPhrase
    ], 'burn');

    print('transfer $payload succeeded');
  }

  @override
  Future<void> addTicketer(String ticketerAddress) async {
    final payload = await invokeWithSign([
      ticketerAddress,
    ], 'addTicketer');

    print('add ticketer $payload succeeded');
  }

  @override
  Future<List<String>> getTicketers() async {
    final keyPairData = (await _instance._getPrivate());
    final result = await doRequest(
        queryURL,
        [getAddressByPublicKey(await keyPairData.extractPublicKey())],
        'ticketers');

    print('query ticketers succeeded: $result');
    if (result == "null"){
      return [];
    }

    List<dynamic> dynamicList = jsonDecode(result);
    List<String> stringList = dynamicList.cast<String>();

    return stringList;
  }

  @override
  Future<void> deleteTicketer(String ticketerAddress) async {
    final payload = await invokeWithSign([
      ticketerAddress,
    ], 'deleteTicketer');

    print('delete ticketer $payload succeeded');
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
    var encode = jsonEncode(categories);
    print('encoded categories: $categories');

    final payload = await invokeWithSign(
        [encode, e.name, e.address, e.startTime.toString()], 'emission');

    return payload;
  }

  @override
  Future<List<PriceCategory>> getIssuerEventCategories(String eid) async {
    final result = await doRequest(queryURL, [eid], 'eventCategories');

    return parsePriceCategories(result);
  }

  @override
  Future<bool> setCategoryPrices(
      String eventID, List<PriceCategory> categories) async {
    final Map<String, PriceCategory> categoryMap = categories.asMap().map(
          (index, category) => MapEntry(category.name, category),
        );

    final payload = await invokeWithSign(
        [eventID, jsonEncode(categoryMap)], 'setPricesCategories');

    print("after setting price categories got reponse: $payload");

    return true;
  }
}
