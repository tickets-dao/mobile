import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import "package:cryptography/cryptography.dart";
import "package:pointycastle/pointycastle.dart" as pc;
import 'package:http/http.dart' as http;

Future<void> main() async {
  final privateKey = await readPrivateKeyFromFile('./keys/user.private');
  final publicKey = await privateKey.extractPublicKey();

  final queryArgs = [
    '5unWkjiVbpAkDDvyS8pxT1hWuwqEFgFShTb8i4WBr2KdDWuuf',
    'industrialBalanceOf',
  ];
  final List<String> encodedqueryArgsList =
      queryArgs.map(base64EncodeString).toList();

  final result =
      await doRequest(Uri(), encodedqueryArgsList, "industrialBalanceOf");

  print(result);

  List<String> signedAddBalanceArgs =
      await sign(privateKey, 'tickets', 'tickets', 'addAlowedBalance', []);

  final List<String> encodedAddBalanceList =
      signedAddBalanceArgs.map(base64EncodeString).toList();

  print(await doRequest(Uri(),encodedAddBalanceList, "addAlowedBalance"));

  List<String> signedEmitArgs = await sign(
      privateKey, 'tickets', 'tickets', 'buy', ["parter", "1", "1", "2"]);
  print(signedEmitArgs);

  final List<String> encodedList =
      signedEmitArgs.map(base64EncodeString).toList();

  await doRequest(Uri(),encodedList, "buy");
}

Future<SimpleKeyPairData> readPrivateKeyFromFile(String filename) async {
  final fileString = await File(filename).readAsString();
  final keySeedBytes = base64Decode(fileString);

  final key = await Ed25519().newKeyPairFromSeed(keySeedBytes);

  return key.extract();
}

Uint8List sha3_256(List<int> data) {
  final sha3 = pc.Digest("SHA3-256");
  sha3.update(Uint8List.fromList(data), 0, data.length);
  var out = Uint8List(32);
  sha3.doFinal(out, 0);
  return out;
}

Future<List<String>> sign(SimpleKeyPairData privateKey, String channel,
    String chaincode, String methodName, List<String> args) async {
  final nonce = DateTime.now().millisecondsSinceEpoch.toString();
  final result = <String>[
    methodName,
    '',
    chaincode,
    channel,
    ...args,
    nonce,
    base58.encode(privateKey.publicKey.bytes as Uint8List),
  ];

  final message = sha3_256(utf8.encode(result.join('')));
  final signature = await Ed25519().sign(
    message,
    keyPair: await privateKey.extract(),
  );

  return [
    ...result.sublist(1),
    base58.encode(signature.bytes as Uint8List),
  ];
}

String base64EncodeString(String input) {
  return base64.encode(utf8.encode(input));
}

Future<String> doRequest(Uri url, List<String> params, String fnName) async {
  final List<String> encodedParams = params.map(base64EncodeString).toList();

  http.Response response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer test'
    },
    body: jsonEncode({
      "args": encodedParams,
      "chaincodeId": "tickets",
      "channel": "tickets",
      "fcn": fnName,
    }),
  );

  if (response.statusCode == 200) {
    print('Запрос $fnName ${url.path} успешно выполнен: ${response.body}');
  } else {
    throw ('Ошибка при выполнении запроса $fnName. Код ответа: ${response.statusCode}, тело: ${response.body}');
  }

  final encoded = json.decode(response.body);

  return utf8.decode(base64Decode(encoded["payload"]));
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
