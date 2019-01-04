// import 'numbers.dart' as numbers;

class Units {
  final String Zil = 'zil';
  final String Li = 'li';
  final String Qa = 'qa';
}

final Units units = new Units();

Map<String, String> unitMap = {
  units.Qa: '1',
  units.Li: '1000000',
  units.Zil: '1000000000000'
};

String fromQa(BigInt qa, String unit, {pad: false}) {
  if (unit == 'qa') {
    return qa.toString();
  }
  String baseStr = unitMap[unit];

  if (baseStr == null) {
    throw 'No unit of type ${unit} exists.';
  }

  BigInt base = BigInt.parse(baseStr);
  int baseNumDecimals = baseStr.length - 1;

  String fraction = ((qa.abs()) % base).toString();

  while (fraction.length < baseNumDecimals) {
    fraction = '0${fraction}';
  }
  var reg = new RegExp(r"/^([0-9]*[1-9]|0)(0*)/");
  // print(reg.allMatches(fraction));
  if (pad == false) {
    fraction = fraction.splitMapJoin(reg);
  }

  String whole = (qa ~/ base).toString();

  return fraction == '0' ? '${whole}' : '${whole}.${fraction}';
}

BigInt toQa(dynamic input, String unit) {
  String inputStr = num.parse(input).toString();
  String baseStr = unitMap[unit];

  if (baseStr == null) {
    throw 'No unit of type ${unit} exists.';
  }

  int baseNumDecimals = baseStr.length - 1;

  BigInt base = BigInt.parse(baseStr);

  // Is it negative?
  bool isNegative = inputStr.substring(0, 1) == '-';
  if (isNegative) {
    inputStr = inputStr.substring(1);
  }

  if (inputStr == '.') {
    throw 'type error: Cannot convert ${inputStr} to Qa.';
  }

  // Split it into a whole and fractional part
  List<String> comps = inputStr.split('.'); // eslint-disable-line
  if (comps.length > 2) {
    throw 'too long: Cannot convert ${inputStr} to Qa.';
  }
  String whole = comps.first;
  String fraction = comps.last;

  if (whole == null) {
    whole = '0';
  }
  if (fraction == null) {
    fraction = '0';
  }
  if (fraction.length > baseNumDecimals) {
    throw 'fraction is too long :Cannot convert ${inputStr} to Qa.';
  }

  while (fraction.length < baseNumDecimals) {
    fraction += '0';
  }

  BigInt wholeBN = BigInt.parse(whole);
  BigInt fractionBN = BigInt.parse(fraction);
  BigInt wei = wholeBN * base + fractionBN; // eslint-disable-line

  if (isNegative) {
    wei = -(wei);
  }

  return BigInt.parse(wei.toString());
}
