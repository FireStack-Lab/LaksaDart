enum Units { Zil, Li, Qa }

Map<Units, String> unitMap = {
  Units.Qa: '1',
  Units.Li: '1000000',
  Units.Zil: '1000000000000'
};

String fromQaFunc(BigInt qa, Units unit, {pad = false}) {
  if (unit.toString() == 'qa') {
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

BigInt toQaFunc(String input, Units unit) {
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
  String fraction = comps.length == 2 ? comps.last : null;

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
  BigInt wei = wholeBN * base + fractionBN;

  if (isNegative) {
    wei = -(wei);
  }

  return BigInt.parse(wei.toString());
}

class Unit {
  String unit;
  BigInt qa;
  static from(dynamic str) {
    return new Unit(str);
  }

  static Zil(dynamic str) {
    return new Unit(str).asZil();
  }

  static Li(dynamic str) {
    return new Unit(str).asLi();
  }

  static Qa(dynamic str) {
    return new Unit(str).asQa();
  }

  Unit(dynamic str) {
    this.unit = str is String
        ? num.parse(str).toString()
        : str is int ? str.toString() : str is BigInt ? str.toString() : '';
  }

  asZil() {
    this.qa = toQaFunc(this.unit, Units.Zil);
    return this;
  }

  asLi() {
    this.qa = toQaFunc(this.unit, Units.Li);
    return this;
  }

  asQa() {
    this.qa = BigInt.parse(this.unit);
    return this;
  }

  toQa() {
    return this.qa;
  }

  toLi() {
    return fromQaFunc(this.qa, Units.Li);
  }

  toZil() {
    return fromQaFunc(this.qa, Units.Zil);
  }

  toQaString() {
    return this.qa.toString();
  }
}
