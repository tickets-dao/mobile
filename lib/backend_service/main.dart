import "dart:convert";
import "dart:io";
import "package:cryptography/cryptography.dart";

import 'mock_implementations/key_pair_impl.dart';

Future<DAOKeyPair> loadKeysFromFile(String path) async {
  final publicKeyBytes = await File("keys/public_key.ed25519").readAsBytes();
  final privateKeyBytes = await File(path).readAsBytes();

  final publicKey = SimplePublicKey(publicKeyBytes, type: KeyPairType.ed25519);
  return DAOKeyPair(
    publicKey,
    SimpleKeyPairData(privateKeyBytes,
        publicKey: publicKey, type: KeyPairType.ed25519),
  );
}

Future<void> main() async {
  // final algorithm = Ed25519();
  // final _keyPair = await algorithm.newKeyPair();
  // var keyPair =
  //     DAOKeyPair(await _keyPair.extractPublicKey(), await _keyPair.extract());
  // Создаем пару ключей
  // KeyPair keyPair = await generateKeyPair();
  //
  // // Сохраняем ключи в файл
  // keyPair.saveKeysToFile();
  // keyPair.saveBase64KeysToFile();
  //
  // print(base64.encode(keyPair.publicKey.bytes));
  // print(base64.encode(keyPair.privateKey.bytes));

  // Читаем ключи из файла
  // DAOKeyPair loadedKeyPair = await loadKeysFromFile("keys/private_key.ed25519");
  // print(base64EncodeString("100"));

  // print("------ new keys --------");

  // print(base64.encode(loadedKeyPair.publicKey.bytes));
  // print(base64.encode(loadedKeyPair.privateKey.bytes));

  // Создаем и кодируем JSON массив
  // List<String> data = ["custom_address", "parter", "10   0", "1", "2"];

  // List<String> encodedList = data.map(base64EncodeString).toList();

  // print(encodedList);
  // String jsonBody = jsonEncode(encodedList);

  // Создаем подпись на массив
  // Signature signature =
  //     await loadedKeyPair.createSignature(jsonBody, loadedKeyPair.privateKey);

  // print("Подпись создана: ${base64.encode(signature.bytes)}");

  // encodedList.add(base64Encode(signature.bytes));
  // print(jsonEncode(encodedList));

  // await sendPostRequest(
  //     "http://localhost:9001/invoke", jsonEncode(encodedList));
}
