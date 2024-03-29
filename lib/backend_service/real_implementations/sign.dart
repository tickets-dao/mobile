import 'dart:convert';
import 'package:base58check/base58check.dart';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'package:bs58/bs58.dart';
import "package:cryptography/cryptography.dart";
import "package:pointycastle/pointycastle.dart" as pc;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

String getAddressByPublicKey(SimplePublicKey publicKey) {
  final hash = sha3_256(publicKey.bytes);
  final encoded = Base58CheckCodec(Base58CheckCodec.BITCOIN_ALPHABET)
      .encode(Base58CheckPayload(hash[0], hash.sublist(1)));

  print('encoded address is $encoded}');

  return encoded;
}

Future<SimpleKeyPairData> readPrivateKeyFromString(String fileString) async {
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
    keyPair: privateKey,
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

  return utf8.decode(base64Decode(encoded["payload"] ?? ""));
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
