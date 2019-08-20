import 'package:validators/validators.dart' as validators;
import 'package:laksadart/src/crypto/checksum.dart';

bool isUrl(String url) {
  return validators.isURL(url);
}

bool isByteString(String byStr, {int length}) {
  var str = byStr.startsWith(new RegExp(r'0x', caseSensitive: false))
      ? byStr.substring(2)
      : byStr;
  return validators.matches(str, '^[0-9a-fA-F]{${length}}') &&
      validators.isLength(str, length, length);
}

bool isAddress(String str) {
  return isByteString(str, length: 40);
}

bool isPrivateKey(String str) {
  return isByteString(str, length: 64);
}

bool isPublicKey(String str) {
  return isByteString(str, length: 66);
}

bool isSignature(String str) {
  return isByteString(str, length: 128);
}

bool isValidChecksumAddress(String str) {
  return (isAddress(str.replaceAll('0x', '')) && toChecksum(str) == str);
}

bool isBech32(String str) {
  return validators.matches(str, 'zil1[qpzry9x8gf2tvdw0s3jn54khce6mua7l]{38}');
}
