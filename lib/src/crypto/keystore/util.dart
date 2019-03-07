part of 'keyStore.dart';

/// getDerivedKey by ``kdf`` type
_KeyDerivator getDerivedKey(String kdf, Map<String, dynamic> params) {
  var salt = numbers.hexToBytes(params['salt']);
  if (kdf == 'pbkdf2') {
    var c = params['c'];
    var dklen = params['dklen'];
    return new _PBDKDF2KeyDerivator(c, salt, dklen);
  } else if (kdf == 'scrypt') {
    var n = params['n'];
    var r = params['r'];
    var p = params['p'];
    var dklen = params['dklen'];
    return new _ScryptKeyDerivator(dklen, n, r, p, salt);
  } else {
    throw new ArgumentError('Only pbkdf2 and scrypt are supported');
  }
}

CTRStreamCipher _initCipher(bool forEncryption, List<int> key, List<int> iv) {
  return new CTRStreamCipher(new AESFastEngine())
    ..init(false, new ParametersWithIV(new KeyParameter(key), iv));
}

List<int> _encryptPrivateKey(_KeyDerivator _derivator, Uint8List _password,
    Uint8List _iv, String privateKey) {
  var derived = _derivator.deriveKey(_password);
  var aesKey = derived.sublist(0, 16);
  var aes = _initCipher(true, aesKey, _iv);
  return aes.process(numbers.hexToBytes(privateKey));
}
