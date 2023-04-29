import "package:cryptography/cryptography.dart";

abstract class IKeyPair {
  abstract final SimplePublicKey publicKey;
  abstract final SimpleKeyPairData privateKey;

  void saveKeysToFile();
  void saveBase64KeysToFile();
  Future<Signature> createSignature(String data, SimpleKeyPairData privateKey);
  String base64EncodeString(String input);
}
