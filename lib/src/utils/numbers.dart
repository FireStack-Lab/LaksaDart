import "dart:typed_data";
import 'package:convert/convert.dart';
import 'package:pointycastle/src/utils.dart' as p_utils;

/// If present, removes the 0x from the start of a hex-string.
String strip0x(String hex) {
  if (hex.startsWith('0x', 0)) return hex.substring(2);
  return hex;
}

/// Converts the [number], which can either be a dart [int] or a [BigInt],
/// into a hexadecimal representation. The number needs to be positive or zero.
///
/// When [pad] is set to true, this method will prefix a zero so that the result
/// will have an even length. Further, if [forcePadLen] is not null and the
/// result has a length smaller than [forcePadLen], the rest will be left-padded
/// with zeroes. Note that [forcePadLen] refers to the string length, meaning
/// that one byte has a length of 2. When [include0x] is set to true, the
/// output wil have "0x" prepended to it after any padding is done.
String toHex(dynamic number,
    {bool pad = false, bool include0x = false, int? forcePadLen}) {
  String toHexSimple() {
    if (number is int)
      return number.toRadixString(16);
    else if (number is BigInt)
      return number.toRadixString(16);
    else
      throw new TypeError();
  }

  var hexString = toHexSimple();
  if (pad && !hexString.length.isEven) hexString = "0$hexString";
  if (forcePadLen != null) hexString = hexString.padLeft(forcePadLen, "0");
  if (include0x) hexString = "0x$hexString";

  return hexString;
}

/// Converts the [bytes] given as a list of integers into a hexadecimal
/// representation.
///
/// If any of the bytes is outside of the range [0, 256], the method will throw.
/// The outcome of this function will prefix a 0 if it would otherwise not be
/// of even length. If [include0x] is set, it will prefix "0x" to the hexadecimal
/// representation.
String bytesToHex(List<int> bytes, {bool include0x = false}) {
  return (include0x ? "0x" : "") + hex.encode(bytes);
}

/// Converts the given number, either a [int] or a [BigInt] to a list of
/// bytes representing the same value.
List<int> numberToBytes(dynamic number) {
  if (number is BigInt) return p_utils.encodeBigInt(number);

  var hexString = toHex(number, pad: true);
  return hex.decode(hexString);
}

/// Converts the hexadecimal string, which can be prefixed with 0x, to a byte
/// sequence.
List<int> hexToBytes(String hexStr) {
  return hex.decode(strip0x(hexStr));
}

///Converts the bytes from that list (big endian) to a BigInt.
// BigInt bytesToInt(List<int> bytes) => p_utils.decodeBigInt(bytes);
BigInt bytesToInt(List<int> bytes) => p_utils.decodeBigIntWithSign(1, bytes);

// List<int> intToBytes(BigInt number) => p_utils.encodeBigInt(number);

/// big int to bytes
List<int> intToBytes(BigInt? number, {int? length}) {
  Uint8List bigIntList = p_utils.encodeBigInt(number);
  if (length != null && length > bigIntList.length) {
    var newList = new Int8List(length);
    newList.setRange(length - bigIntList.length, length, bigIntList);
    return newList;
  } else if (length == null) {
    return bigIntList;
  } else {
    throw 'length is to short, should be >= ${bigIntList.length}';
  }
}

///Takes the hexadecimal input and creates a BigInt.
BigInt hexToInt(String hex) {
  return BigInt.parse(strip0x(hex), radix: 16);
}

int pack(int CHAIN_ID, int rawVersion) {
  return (CHAIN_ID << 16) + rawVersion;
}

int unPack(int versioned, int CHAIN_ID) {
  return versioned - (CHAIN_ID << 16);
}

List<String> numberToHexArray(int number, int size) {
  String hexVal = number.toRadixString(16);
  List<String> hexRep = List.filled(hexVal.length, '0');
  List<String> hex = List.filled(size, '0');
  for (int i = 0; i < hexVal.length; i++) {
    hexRep[i] = hexVal.substring(i, i + 1);
  }
  hex.setRange(size - hexVal.length, size, hexRep);
  return hex;
}
