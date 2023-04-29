import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "package:cryptography/cryptography.dart";
import 'package:http/http.dart' as http;


Future<void> main() async {
  // Создаем пару ключей
  // KeyPair keyPair = await generateKeyPair();
  //
  // // Сохраняем ключи в файл
  // keyPair.saveKeysToFile();
  // keyPair.saveBas64KeysToFile();
  //
  // print(base64.encode(keyPair.publicKey.bytes));
  // print(base64.encode(keyPair.privateKey.bytes));

  // Читаем ключи из файла
  KeyPair loadedKeyPair = await loadKeysFromFile();
  print(base64EncodeString("100"));

  print("------ new keys --------");

  print(base64.encode(loadedKeyPair.publicKey.bytes));
  print(base64.encode(loadedKeyPair.privateKey.bytes));

  // Создаем и кодируем JSON массив
  List<String> data = ["custom_address", "parter", "10   0", "1", "2"];


  List<String> encodedList = data.map(base64EncodeString).toList();


  print(encodedList);
  String jsonBody = jsonEncode(encodedList);

  // Создаем подпись на массив
  Signature signature =
      await createSignature(jsonBody, loadedKeyPair.privateKey);

  print("Подпись создана: ${base64.encode(signature.bytes)}");

  encodedList.add(base64Encode(signature.bytes));
  print(jsonEncode(encodedList));

  await sendPostRequest("http://localhost:9001/invoke", jsonEncode(encodedList));
}

class KeyPair {
  final SimplePublicKey publicKey;
  final SimpleKeyPairData privateKey;

  KeyPair(this.publicKey, this.privateKey);

  void saveKeysToFile() {
    File("keys/public_key.ed25519").writeAsBytesSync(publicKey.bytes);
    File("keys/private_key.ed25519").writeAsBytesSync(privateKey.bytes);
  }

  void saveBas64KeysToFile() {
    File("keys/public_key_base64.ed25519")
        .writeAsStringSync(base64Encode(publicKey.bytes));
    File("keys/private_key_base64.ed25519")
        .writeAsStringSync(base64Encode(privateKey.bytes));
  }
}

Future<KeyPair> generateKeyPair() async {
  final algorithm = Ed25519();
  final keyPair = await algorithm.newKeyPair();
  return KeyPair(await keyPair.extractPublicKey(), await keyPair.extract());
}

//
Future<KeyPair> loadKeysFromFile() async {
  final publicKeyBytes = await File("keys/public_key.ed25519").readAsBytes();
  final privateKeyBytes = await File("keys/private_key.ed25519").readAsBytes();

  final publicKey = SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519);
  return KeyPair(
    publicKey,
    SimpleKeyPairData(privateKeyBytes,
        publicKey: publicKey, type: KeyPairType.ed25519),
  );
}

Future<Signature> createSignature(
    String data, SimpleKeyPairData privateKey) async {
  final algorithm = Ed25519();
  final signature = await algorithm.sign(
    Uint8List.fromList(data.codeUnits),
    keyPair: privateKey,
  );
  return signature;
}

String base64EncodeString(String input) {
  return base64.encode(utf8.encode(input));
}

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
      print('Ошибка при выполнении запроса. Код ответа: ${response.statusCode}');
    }
  } catch (e) {
    print('Произошла ошибка при отправке запроса: $e');
  }
}
