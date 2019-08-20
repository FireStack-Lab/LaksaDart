import 'package:crypto/crypto.dart';
import 'package:laksadart/src/utils/numbers.dart' as numbers;

String toChecksum(String address) {
  String stripAddress = numbers.strip0x(address.toLowerCase());

  final hash = sha256.convert(numbers.hexToBytes(stripAddress)).toString();
  String ret = '0x';

  BigInt v = numbers.hexToInt(hash);

  for (int i = 0; i < stripAddress.length; i++) {
    if ('0123456789'.contains(stripAddress[i])) {
      ret += stripAddress[i];
    } else {
      var checker = v & BigInt.from(2).pow(BigInt.from(255 - 6 * i).toInt());
      ret += checker >= BigInt.from(1)
          ? stripAddress[i].toUpperCase()
          : stripAddress[i].toLowerCase();
    }
  }

  return ret;
}
