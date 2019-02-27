import 'package:validators/validators.dart' as validators;

// bool isByteString(String byStr, {int length}) {
//   var byStrMap = {byStr: byStr};
//   var regString = r"^(0x)?[0-9a-f]" + "{$length}";
//   var validator = new angel.Validator({
//     byStr: (data) {
//       var reg = new RegExp(regString, caseSensitive: false);
//       return reg.hasMatch(data);
//     }
//   });
//   var result = validator.check(byStrMap);
//   return result.errors.isNotEmpty ? false : true;
// }

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
