import 'package:angel_validate/server.dart' as angel;

bool isUrl(String url) {
  var urlString = {'url': url};
  var validator = new angel.Validator({'url': angel.isUrl});
  var result = validator.check(urlString);
  return result.errors.length > 0 ? false : true;
}

bool isByteString(String byStr, {int length}) {
  var byStrMap = {byStr: byStr};
  var regString = r"^(0x)?[0-9a-f]" + "{$length}";
  var validator = new angel.Validator({
    byStr: (data) {
      var reg = new RegExp(regString, caseSensitive: false);
      return reg.hasMatch(data);
    }
  });
  var result = validator.check(byStrMap);
  return result.errors.length > 0 ? false : true;
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
