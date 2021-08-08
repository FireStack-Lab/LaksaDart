part of 'key_store.dart';

abstract class _KeyDerivator {
  Uint8List deriveKey(List<int> password);

  String getName();
  Map<String, dynamic> encode();
}

class _PBDKDF2KeyDerivator extends _KeyDerivator {
  final int? iterations;
  final Uint8List salt;
  final int? dklen;

  /// The docs (https://github.com/ethereum/wiki/wiki/Web3-Secret-Storage-Definition)
  /// say that HMAC with SHA-256 is the only mac supported at the moment
  static final Mac mac = new HMac(new SHA256Digest(), 64);

  _PBDKDF2KeyDerivator(this.iterations, this.salt, this.dklen);

  @override
  Uint8List deriveKey(List<int> password) {
    var impl = new pbkdf2.PBKDF2KeyDerivator(mac)
      ..init(new Pbkdf2Parameters(salt, iterations!, dklen!));

    return impl.process(password as Uint8List);
  }

  @override
  Map<String, dynamic> encode() {
    return {
      'c': iterations,
      'dklen': dklen,
      'prf': 'hmac-sha256',
      'salt': numbers.bytesToHex(salt)
    };
  }

  @override
  String getName() {
    return "pbkdf2";
  }
}

class _ScryptKeyDerivator extends _KeyDerivator {
  final int? dklen;
  final int? n;
  final int? r;
  final int? p;
  final List<int> salt;

  _ScryptKeyDerivator(this.dklen, this.n, this.r, this.p, this.salt);

  @override
  Uint8List deriveKey(List<int> password) {
    var impl = new scrypt.Scrypt()
      ..init(new ScryptParameters(n!, r!, p!, dklen!, salt as Uint8List));

    return impl.process(password as Uint8List);
  }

  @override
  Map<String, dynamic> encode() {
    return {
      "dklen": dklen,
      "n": n,
      "r": r,
      "p": p,
      "salt": numbers.bytesToHex(salt),
    };
  }

  @override
  String getName() => "scrypt";
}
