import 'package:bech32/bech32.dart';
import 'package:laksadart/src/utils/validators.dart' show isAddress;
import 'package:laksadart/src/utils/numbers.dart' as numbers;
import './checksum.dart';

final String HRP = 'zil';

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
