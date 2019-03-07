part of 'keyStore.dart';

final String ALGO_IDENTIFIER = 'aes-128-ctr';

Future<String> encrypt(String privateKey, String passphrase,
    [Map<String, dynamic> options]) async {
  Uint8List uuid = new Uint8List(16);
  Uuid uuidParser = new Uuid()..v4(buffer: uuid);

  String salt = crypto.randomHex(64);
  List<int> iv = crypto.randomBytes(16);
  String kdf = 'scrypt';
  int level = 8192;
  int n = kdf == 'pbkdf2' ? 262144 : level;
  if (options == null) {
    kdf = 'scrypt';
    level = 8192;
    n = kdf == 'pbkdf2' ? 262144 : level;
  } else {
    kdf = options['kdf'] is String ? options['kdf'] : 'scrypt';
    level = options['level'] is int ? options['level'] : 8192;
    n = kdf == 'pbkdf2' ? 262144 : level;
  }

  Map<String, dynamic> kdfParams = {
    'salt': salt,
    'n': n,
    'r': 8,
    'p': 1,
    'dklen': 32
  };

  List<int> encodedPassword = utf8.encode(passphrase);
  _KeyDerivator derivator = getDerivedKey(kdf, kdfParams);
  List<int> derivedKey = derivator.deriveKey(encodedPassword);

  List<int> ciphertextBytes =
      await _encryptPrivateKey(derivator, encodedPassword, iv, privateKey);

  List<int> macBuffer = derivedKey.sublist(16, 32) +
      ciphertextBytes +
      iv +
      ALGO_IDENTIFIER.codeUnits;

  String mac = numbers.bytesToHex(
      new HMAC(sha256, derivedKey).update(macBuffer).digest().bytes);

  Map<String, dynamic> map = {
    'crypto': {
      'cipher': 'aes-128-ctr',
      'cipherparams': {'iv': numbers.bytesToHex(iv)},
      'ciphertext': numbers.bytesToHex(ciphertextBytes),
      'kdf': kdf,
      'kdfparams': json.encode(kdfParams),
      'mac': mac,
    },
    'id': uuidParser.unparse(uuid),
    'version': 3,
  };
  String result = json.encode(map);
  return result;
}

Future<String> decrypt(Map<String, dynamic> keyStore, String passphrase) async {
  List<int> ciphertext = numbers.hexToBytes(keyStore['crypto']['ciphertext']);
  String kdf = keyStore['crypto']['kdf'];

  Map<String, dynamic> kdfparams = keyStore['crypto']['kdfparams'] is String
      ? json.decode(keyStore['crypto']['kdfparams'])
      : keyStore['crypto']['kdfparams'];
  var cipherparams = keyStore['crypto']["cipherparams"];
  var iv = numbers.hexToBytes(cipherparams["iv"]);

  List<int> encodedPassword = utf8.encode(passphrase);
  _KeyDerivator derivator = getDerivedKey(kdf, kdfparams);
  List<int> derivedKey = derivator.deriveKey(encodedPassword);
  List<int> macBuffer =
      derivedKey.sublist(16, 32) + ciphertext + iv + ALGO_IDENTIFIER.codeUnits;

  String mac = numbers.bytesToHex(
      new HMAC(sha256, derivedKey).update(macBuffer).digest().bytes);

  String macString = keyStore['crypto']['mac'];

  Function eq = const ListEquality().equals;
  if (!eq(mac.toUpperCase().codeUnits, macString.toUpperCase().codeUnits)) {
    throw 'Decryption Failed';
  }

  var aesKey = derivedKey.sublist(0, 16);
  var encryptedPrivateKey =
      numbers.hexToBytes(keyStore["crypto"]["ciphertext"]);

  var aes = _initCipher(false, aesKey, iv);

  var privateKeyByte = await aes.process(encryptedPrivateKey);
  return numbers.bytesToHex(privateKeyByte);
}
