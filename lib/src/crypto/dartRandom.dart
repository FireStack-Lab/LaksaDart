import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/api.dart';

import '../utils/numbers.dart' as numbers;

/// Utility to use dart:math's Random class to generate numbers used by
/// pointycastle.
class DartRandom implements SecureRandom {
  Random dartRandom;

  DartRandom(this.dartRandom);

  @override
  String get algorithmName => "DartRandom";

  @override
  BigInt nextBigInteger(int bitLength) {
    int fullBytes = bitLength ~/ 8;
    BigInt main = numbers.bytesToInt(nextBytes(fullBytes));

    /// forcing remainingBits to be calculate with bitLength
    int remainingBits = (bitLength - main.bitLength);
    int additional = remainingBits < 4
        ? dartRandom.nextInt(pow(2, remainingBits) as int)
        : remainingBits;
    BigInt additionalBit = (new BigInt.from(additional) << (fullBytes * 8));
    BigInt result = main + additionalBit;
    return result;
  }

  @override
  Uint8List nextBytes(int count) {
    Uint8List list = new Uint8List(count);

    for (int i = 0; i < list.length; i++) {
      list[i] = nextUint8();
    }
    return list;
  }

  @override
  int nextUint16() => dartRandom.nextInt(pow(2, 32) as int);

  @override
  int nextUint32() => dartRandom.nextInt(pow(2, 32) as int);

  @override
  int nextUint8() => dartRandom.nextInt(pow(2, 8) as int);

  @override
  void seed(CipherParameters params) {
    /// ignore, dartRandom will already be seeded if wanted
  }
}
