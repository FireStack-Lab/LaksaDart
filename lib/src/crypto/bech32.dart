import 'dart:convert';
import 'package:laksadart/src/utils/validators.dart' show isAddress;
import 'package:laksadart/src/utils/numbers.dart' as numbers;
import './checksum.dart';

class TooShortHrp implements Exception {
  String toString() => "The human readable part should have non zero length.";
}

class TooLong implements Exception {
  TooLong(this.length);

  final int length;

  String toString() => "The bech32 string is too long: $length (>90)";
}

class OutOfRangeHrpCharacters implements Exception {
  OutOfRangeHrpCharacters(this.hpr);

  final String hpr;

  String toString() =>
      "The human readable part contains invalid characters: $hpr";
}

class MixedCase implements Exception {
  MixedCase(this.hpr);

  final String hpr;

  String toString() =>
      "The human readable part is mixed case, should either be all lower or all upper case: $hpr";
}

class OutOfBoundChars implements Exception {
  OutOfBoundChars(this.char);

  final String char;

  String toString() => "A character is undefined in bech32: $char";
}

class InvalidSeparator implements Exception {
  InvalidSeparator(this.pos);

  final int pos;

  String toString() => "separator '1' at invalid position: $pos";
}

class InvalidAddress implements Exception {
  String toString() => "";
}

class InvalidChecksum implements Exception {
  String toString() => "Checksum verification failed";
}

class TooShortChecksum implements Exception {
  String toString() => "Checksum is shorter than 6 characters";
}

class InvalidHrp implements Exception {
  String toString() => "Human readable part should be 'zil' or 'tzil'.";
}

class InvalidProgramLength implements Exception {
  InvalidProgramLength(this.reason);

  final String reason;

  String toString() => "Program length is invalid: $reason";
}

class InvalidWitnessVersion implements Exception {
  InvalidWitnessVersion(this.version);

  final int version;

  String toString() => "Witness version $version > 16";
}

class InvalidPadding implements Exception {
  InvalidPadding(this.reason);

  final String reason;

  String toString() => "Invalid padding: $reason";
}

const Bech32Codec bech32 = Bech32Codec();

class Bech32Codec extends Codec<Bech32, String> {
  const Bech32Codec();

  Bech32Decoder get decoder => Bech32Decoder();
  Bech32Encoder get encoder => Bech32Encoder();

  String encode(Bech32 data) {
    return Bech32Encoder().convert(data);
  }

  Bech32 decode(String data) {
    return Bech32Decoder().convert(data);
  }
}

// This class converts a Bech32 class instance to a String.
class Bech32Encoder extends Converter<Bech32, String> with Bech32Validations {
  String convert(Bech32 input) {
    var hrp = input.hrp;
    var data = input.data;

    if (hrp.length +
            data.length +
            separator.length +
            Bech32Validations.checksumLength >
        Bech32Validations.maxInputLength) {
      throw TooLong(
          hrp.length + data.length + 1 + Bech32Validations.checksumLength);
    }

    if (hrp.length < 1) {
      throw TooShortHrp();
    }

    if (hasOutOfRangeHrpCharacters(hrp)) {
      throw OutOfRangeHrpCharacters(hrp);
    }

    if (isMixedCase(hrp)) {
      throw MixedCase(hrp);
    }

    hrp = hrp.toLowerCase();

    var checksummed = data + _createChecksum(hrp, data);

    if (hasOutOfBoundsChars(checksummed)) {
      throw OutOfBoundChars('<unknown>');
    }

    return hrp + separator + checksummed.map((i) => charset[i]).join();
  }
}

// This class converts a String to a Bech32 class instance.
class Bech32Decoder extends Converter<String, Bech32> with Bech32Validations {
  Bech32 convert(String input) {
    if (input.length > Bech32Validations.maxInputLength) {
      throw TooLong(input.length);
    }

    if (isMixedCase(input)) {
      throw MixedCase(input);
    }

    if (hasInvalidSeparator(input)) {
      throw InvalidSeparator(input.lastIndexOf(separator));
    }

    var separatorPosition = input.lastIndexOf(separator);

    if (isChecksumTooShort(separatorPosition, input)) {
      throw TooShortChecksum();
    }

    if (isHrpTooShort(separatorPosition)) {
      throw TooShortHrp();
    }

    input = input.toLowerCase();

    var hrp = input.substring(0, separatorPosition);
    var data = input.substring(
        separatorPosition + 1, input.length - Bech32Validations.checksumLength);
    var checksum =
        input.substring(input.length - Bech32Validations.checksumLength);

    if (hasOutOfRangeHrpCharacters(hrp)) {
      throw OutOfRangeHrpCharacters(hrp);
    }

    List<int> dataBytes = data.split('').map((c) {
      return charset.indexOf(c);
    }).toList();

    if (hasOutOfBoundsChars(dataBytes)) {
      throw OutOfBoundChars(data[dataBytes.indexOf(-1)]);
    }

    List<int> checksumBytes = checksum.split('').map((c) {
      return charset.indexOf(c);
    }).toList();

    if (hasOutOfBoundsChars(checksumBytes)) {
      throw OutOfBoundChars(checksum[checksumBytes.indexOf(-1)]);
    }

    if (isInvalidChecksum(hrp, dataBytes, checksumBytes)) {
      throw InvalidChecksum();
    }

    return Bech32(hrp, dataBytes);
  }
}

/// Generic validations for Bech32 standard.
class Bech32Validations {
  static const int maxInputLength = 90;
  static const checksumLength = 6;

  // From the entire input subtract the hrp length, the separator and the required checksum length
  bool isChecksumTooShort(int separatorPosition, String input) {
    return (input.length - separatorPosition - 1 - checksumLength) < 0;
  }

  bool hasOutOfBoundsChars(List<int> data) {
    return data.any((c) => c == -1);
  }

  bool isHrpTooShort(int separatorPosition) {
    return separatorPosition == 0;
  }

  bool isInvalidChecksum(String hrp, List<int> data, List<int> checksum) {
    return !_verifyChecksum(hrp, data + checksum);
  }

  bool isMixedCase(String input) {
    return input.toLowerCase() != input && input.toUpperCase() != input;
  }

  bool hasInvalidSeparator(String bech32) {
    return bech32.lastIndexOf(separator) == -1;
  }

  bool hasOutOfRangeHrpCharacters(String hrp) {
    return hrp.codeUnits.any((c) => c < 33 || c > 126);
  }
}

class Bech32 {
  Bech32(this.hrp, this.data);

  final String hrp;
  final List<int> data;
}

const String separator = "1";

const List<String> charset = [
  "q",
  "p",
  "z",
  "r",
  "y",
  "9",
  "x",
  "8",
  "g",
  "f",
  "2",
  "t",
  "v",
  "d",
  "w",
  "0",
  "s",
  "3",
  "j",
  "n",
  "5",
  "4",
  "k",
  "h",
  "c",
  "e",
  "6",
  "m",
  "u",
  "a",
  "7",
  "l",
];

const List<int> generator = [
  0x3b6a57b2,
  0x26508e6d,
  0x1ea119fa,
  0x3d4233dd,
  0x2a1462b3,
];

int _polymod(List<int> values) {
  var chk = 1;
  values.forEach((int v) {
    var top = chk >> 25;
    chk = (chk & 0x1ffffff) << 5 ^ v;
    for (int i = 0; i < generator.length; i++) {
      if ((top >> i) & 1 == 1) {
        chk ^= generator[i];
      }
    }
  });

  return chk;
}

List<int> _hrpExpand(String hrp) {
  var result = hrp.codeUnits.map((c) => c >> 5).toList();
  result = result + [0];

  result = result + hrp.codeUnits.map((c) => c & 31).toList();

  return result;
}

bool _verifyChecksum(String hrp, List<int> dataIncludingChecksum) {
  return _polymod(_hrpExpand(hrp) + dataIncludingChecksum) == 1;
}

List<int> _createChecksum(String hrp, List<int> data) {
  var values = _hrpExpand(hrp) + data + [0, 0, 0, 0, 0, 0];
  var polymod = _polymod(values) ^ 1;

  List<int> result = []..length = 6;

  for (int i = 0; i < result.length; i++) {
    result[i] = (polymod >> (5 * (5 - i))) & 31;
  }
  return result;
}

List<int> _convertBits(List<int> data, int from, int to, {bool pad: true}) {
  var acc = 0;
  var bits = 0;
  List<int> result = [];
  var maxv = (1 << to) - 1;

  data.forEach((v) {
    if (v < 0 || (v >> from) != 0) {
      throw Exception();
    }
    acc = (acc << from) | v;
    bits += from;
    while (bits >= to) {
      bits -= to;
      result.add((acc >> bits) & maxv);
    }
  });

  if (pad) {
    if (bits > 0) {
      result.add((acc << (to - bits)) & maxv);
    }
  } else if (bits >= from) {
    throw InvalidPadding("illegal zero padding");
  } else if (((acc << (to - bits)) & maxv) != 0) {
    throw InvalidPadding("non zero");
  }

  return result;
}

final String HRP = 'zil';

String toBech32Address(String address) {
  if (!isAddress(address)) {
    throw 'Invalid address format.';
  }

  List<int> addrBz = _convertBits(
    numbers.hexToBytes(address.replaceAll('0x', '')),
    8,
    5,
  );

  var b32Class = Bech32(HRP, addrBz);

  return bech32.encode(b32Class);
}

String fromBech32Address(String address) {
  try {
    Bech32 res = bech32.decode(address);
    var hrp = res.hrp;
    var data = res.data;

    if (hrp != HRP) {
      throw InvalidHrp();
    }

    List<int> buf = _convertBits(data, 5, 8, pad: false);
    return toChecksum(numbers.bytesToHex(buf));
  } catch (e) {
    rethrow;
  }
}
