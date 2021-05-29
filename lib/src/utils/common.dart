import './numbers.dart' as numbers;

String toHex(dynamic msg) {
  var res = '';
  for (var i = 0; i < msg.length; i++) {
    res += zero2(numbers.toHex(msg[i]));
  }
  return res;
}

String zero2(word) {
  if (word.length == 1)
    return '0' + word;
  else
    return word;
}

bool isSurrogatePair(String msg, i) {
  if ((msg.codeUnitAt(i) & 0xFC00) != 0xD800) {
    return false;
  }
  if (i < 0 || i + 1 >= msg.length) {
    return false;
  }
  return (msg.codeUnitAt(i + 1) & 0xFC00) == 0xDC00;
}

List<int> toArray(String msg, [String enc]) {
  if (enc == 'hex') {
    List<int> hexRes = [];
    msg = msg.replaceAll(new RegExp("[^a-z0-9]"), '');
    if (msg.length % 2 != 0) msg = '0' + msg;
    for (var i = 0; i < msg.length; i += 2) {
      var cul = msg[i] + msg[i + 1];
      var result = int.parse(cul, radix: 16);
      hexRes.add(result);
    }
    return hexRes;
  } else {
    List<int> noHexRes = [];
    for (var i = 0; i < msg.length; i++) {
      var c = msg.codeUnitAt(i);
      var hi = c >> 8;
      var lo = c & 0xff;
      if (hi > 0) {
        noHexRes.add(hi);
        noHexRes.add(lo);
      } else {
        noHexRes.add(lo);
      }
    }

    return noHexRes;
  }
}
