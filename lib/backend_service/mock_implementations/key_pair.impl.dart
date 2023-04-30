import "package:cryptography/cryptography.dart";
import 'dart:typed_data';
import "dart:convert";
import 'dart:io';
import '../../types/key_pair.dart';

class DAOKeyPair implements IKeyPair {
  final SimplePublicKey publicKey;
  final SimpleKeyPairData privateKey;

  DAOKeyPair(this.publicKey, this.privateKey);

  @override
  void saveKeysToFile() {
    File("keys/public_key.ed25519").writeAsBytesSync(publicKey.bytes);
    File("keys/private_key.ed25519").writeAsBytesSync(privateKey.bytes);
  }

  @override
  String base64EncodeString(String input) {
    return base64.encode(utf8.encode(input));
  }

  @override
  void saveBase64KeysToFile() {
    File("keys/public_key_base64.ed25519")
        .writeAsStringSync(base64Encode(publicKey.bytes));
    File("keys/private_key_base64.ed25519")
        .writeAsStringSync(base64Encode(privateKey.bytes));
  }

  @override
  Future<Signature> createSignature(
      String data, SimpleKeyPairData privateKey) async {
    final algorithm = Ed25519();
    final signature = await algorithm.sign(
      Uint8List.fromList(data.codeUnits),
      keyPair: privateKey,
    );
    return signature;
  }
}
