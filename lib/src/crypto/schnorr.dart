import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/key_generators/api.dart';
import "package:pointycastle/key_generators/ec_key_generator.dart";
import "package:pointycastle/ecc/api.dart";
import "package:pointycastle/ecc/curves/secp256k1.dart";

import 'package:laksadart/src/utils/numbers.dart' as numbers;
import 'package:laksadart/src/utils/transaction.dart';
import 'package:laksadart/src/utils/validators.dart' show isSignature;
import 'hmac-drbg.dart';
import 'dartRandom.dart';
import 'signature.dart';

final PUBKEY_COMPRESSED_SIZE_BYTES = 33;

final ECDomainParameters params = new ECCurve_secp256k1();

final ALG = 'Schnorr+SHA256  '.codeUnits;
final ALG_LEN = 16;
// The length in bytes of entropy inputs to HMAC-DRBG
final ENT_LEN = 32;

/// Generates a new private key using the random instance provided. Please make
/// sure you're using a cryptographically secure generator.
BigInt generateNewPrivateKey(Random random) {
  var generator = new ECKeyGenerator();

  var keyParams = new ECKeyGeneratorParameters(params);

  generator.init(new ParametersWithRandom(keyParams, new DartRandom(random)));

  AsymmetricKeyPair key = generator.generateKeyPair();

  ECPrivateKey privateKey = key.privateKey;
  return privateKey.d;
}

/// Generates a public key for the given private key using the ecdsa curve which
/// Ethereum uses.
String privateKeyToPublic(Uint8List privateKey) {
  BigInt privateKeyNum = numbers.bytesToInt(privateKey);

  ECPoint p = params.G * privateKeyNum;
  Uint8List result = p.getEncoded(true);

  return numbers.bytesToHex(result);
}

String getPublic(BigInt private) {
  List<dynamic> privateKeyBytes = numbers.numberToBytes(private);
  return privateKeyToPublic(privateKeyBytes);
}

//  privateKey generation
String generatePrivateKey() {
  Random rng = new Random.secure();
  BigInt prvKeyBigInt = generateNewPrivateKey(rng);
  return prvKeyBigInt.toRadixString(16);
}

/// publicKey calculation for Zilliqa
String getPubKeyFromPrivateKey(String privateKey) {
  BigInt privateKeyBigInt = numbers.hexToInt(privateKey);
  return getPublic(privateKeyBigInt);
}

/// address calculation with privateKey for Zilliqa
String getAddressFromPrivateKey(String privateKey) {
  String publicKey = getPubKeyFromPrivateKey(privateKey);
  return getAddressFromPublicKey(publicKey);
}

/// address calculation with publicKey for zilliqa
String getAddressFromPublicKey(String publicKey) {
  return sha256.convert(numbers.hexToBytes(publicKey)).toString().substring(24);
}

/// TODO: need to implementing this
/// bool verifyPrivateKey(String privateKey) {}

BigInt hash(BigInt q, List<int> pubkey, List<int> msg) {
  final totalLength = PUBKEY_COMPRESSED_SIZE_BYTES * 2 + msg.length;

  /// 33 q + 33 pubkey + variable msgLen

  var Q = numbers.intToBytes(q);

  List<int> B = new List(totalLength);

  B.fillRange(0, totalLength, 0);

  B.setRange(0, Q.length, Q);

  B.setRange(33, 33 + pubkey.length, pubkey);

  B.setRange(66, 66 + msg.length, msg);

  var hashByte = sha256.convert(B).bytes;

  return numbers.bytesToInt(hashByte);
}

DRBG getDRBG(List<int> msg) {
  String nonce = numbers.bytesToHex(msg);

  DartRandom rn = new DartRandom(new Random.secure());

  var entropy = rn.nextBigInteger(ENT_LEN * 8).toRadixString(16);

  if (entropy.length > ENT_LEN * 2) {
    entropy = entropy.substring(0, ENT_LEN * 2);
  }

  var randomPers = rn.nextBigInteger((ENT_LEN) * 8).toRadixString(16);

  if (randomPers.length > (ENT_LEN) * 2) {
    randomPers = randomPers.substring(0, (ENT_LEN) * 2);
  }
  var randomPerBytes = numbers.hexToBytes(randomPers);
  var pers = new List<int>(ALG_LEN + ENT_LEN);
  pers.fillRange(0, pers.length, 0);

  pers.setRange(0, randomPerBytes.length, randomPerBytes);
  pers.setRange(ENT_LEN, pers.length, ALG);

  return new DRBG(hash: sha256, entropy: entropy, nonce: nonce, pers: pers);
}

SchnorrSignature toSignature(List<int> serialised) {
  var r = numbers.bytesToInt(serialised.sublist(0, 64));
  var s = numbers.bytesToInt(serialised.sublist(64));
  return new SchnorrSignature(r, s);
}

SchnorrSignature trySign(
    List<int> msg, BigInt k, BigInt privKey, List<int> pubKey) {
  bool isZero(BigInt test) =>
      test.compareTo(BigInt.from(0)) != 0 ? false : true;
  bool isGteCurve(BigInt test) => test.compareTo(params.n) > 1 ? true : false;

  if (isZero(privKey)) {
    throw 'Bad private key.';
  }
  if (isGteCurve(privKey)) {
    throw 'Bad private key';
  }

  /// 1a. check that k is not 0
  if (isZero(k)) {
    return null;
  }

  /// 1b. check that k is < the order of the group
  if (isGteCurve(k)) {
    return null;
  }

  /// 2. Compute commitment Q = kG, where g is the base point
  ECPoint Q = params.G * k;

  /// convert the commitment to octets first
  BigInt compressedQ = numbers.bytesToInt(Q.getEncoded());

  /// 3. Compute the challenge r = H(Q || pubKey || msg)
  /// mod reduce the r value by the order of secp256k1, n

  BigInt r = hash(compressedQ, pubKey, msg) % (params.n);

  BigInt h = r;

  if (isZero(h)) {
    return null;
  }

  /// 4. Compute s = k - r * prv
  /// 4a. Compute r * prv
  BigInt s = (h * privKey) % (params.n);

  /// 4b. Compute s = k - r * prv mod n
  s = (k - s) % (params.n);

  if (isZero(s)) {
    return null;
  }

  return new SchnorrSignature(r, s);
}

SchnorrSignature sign(List<int> msg, List<int> privKey, List<int> pubKey) {
  BigInt prv = numbers.bytesToInt(privKey);
  DRBG drbg = getDRBG(msg);
  int len = numbers.intToBytes(params.n).length;

  var sig;

  while (sig == null) {
    var k = numbers.hexToInt(drbg.generate(len));

    var trySig = trySign(msg, k, prv, pubKey);
    bool res = verify(
      msg,
      trySig.r,
      trySig.s,
      pubKey,
    );
    if (res && isSignature(trySig.signature)) {
      sig = trySig;
    } else {
      sig = null;
    }
  }
  return sig;
}

bool verify(List<int> msg, BigInt sigR, BigInt sigS, List<int> key) {
  bool isZero(BigInt test) =>
      test.compareTo(BigInt.from(0)) != 0 ? false : true;
  bool isGteCurve(BigInt test) => test.compareTo(params.n) > 1 ? true : false;

  var sig = new SchnorrSignature(sigR, sigS);

  if (isZero(sig.s) || isZero(sig.r)) {
    throw 'Invalid signature';
  }

  if (sig.s.isNegative || sig.r.isNegative) {
    throw 'Invalid signature';
  }

  if (isGteCurve(sig.s) || isGteCurve(sig.r)) {
    throw 'Invalid signature';
  }

  ECPoint kpub = params.curve.decodePoint(key);

  ///   TODO: implementation with curve.validate
  ///   if (!curve.validate(kpub)) {
  ///     throw new Error('Invalid public key')
  ///   }
  ///

  ECPoint l = kpub * (sig.r);

  ECPoint r = params.G * (sig.s);

  ECPoint Q = l + r;

  if (Q.isInfinity) {
    throw 'Invalid intermediate point.';
  }

  BigInt compressedQ = numbers.bytesToInt(Q.getEncoded());

  BigInt r1 = hash(compressedQ, key, msg) % (params.n);

  if (isZero(r1)) {
    throw 'Invalid hash.';
  }

  return r1 == sig.r;
}

List<int> randomBytes(int byteLength) {
  DartRandom rn = new DartRandom(new Random.secure());
  return rn.nextBytes(byteLength);
}

String randomHex(int hexLength) {
  return numbers.bytesToHex(randomBytes(hexLength ~/ 2));
}

typedef SignedTransaction = Map<String, dynamic> Function(
    String privateKey, Map txnDetails);

Map<String, dynamic> SchnorrSign(
    String privateKey, Map<String, dynamic> txnDetails) {
  var pubKey = getPubKeyFromPrivateKey(privateKey);

  Map<String, dynamic> txn = {
    'version': txnDetails['version'],
    'nonce': txnDetails['nonce'],
    'toAddr': txnDetails['toAddr'],
    'amount': txnDetails['amount'],
    'pubKey': pubKey,
    'gasPrice': txnDetails['gasPrice'],
    'gasLimit': txnDetails['gasLimit'],
    'code': txnDetails['code'] != null ? txnDetails['code'] : '',
    'data': txnDetails['data'] != null ? txnDetails['data'] : ''
  };

  Uint8List encodedTx = encodeTransactionProto(txn);

  SchnorrSignature signature = sign(
      encodedTx, numbers.hexToBytes(privateKey), numbers.hexToBytes(pubKey));

  txn.addEntries([new MapEntry('signature', signature.signature)]);
  if (verify(encodedTx, signature.r, signature.s, numbers.hexToBytes(pubKey))) {
    return txn;
  } else {
    throw 'Signature verify failure';
  }
}
