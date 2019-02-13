import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import 'package:laksadart/src/crypto/schnorr.dart' as crypto;
import 'package:laksadart/src/utils/numbers.dart' as numbers;

@immutable
class Address {
  static final RegExp basicAddress =
      new RegExp(r"^(0x)?[0-9a-f]{40}", caseSensitive: false);

  static const int _addLenBytes = 20;
  static final BigInt biggestAddress =
      (BigInt.one << (_addLenBytes * 8)) - BigInt.one;

  /// The number associated with the address
  final BigInt number;
  // final String str;
  Address(String hex) : this.fromNumber(_hexToAddressNum(hex));

  /// Creates an address from its number
  Address.fromNumber(this.number) {
    if (number.isNegative)
      throw new ArgumentError("Addresses must be positive");
    if (number > biggestAddress)
      throw new ArgumentError("Addresses must fit in $_addLenBytes bytes");
  }

  /// Returns this address in a hexadecimal representation, with 0x prefixed.
  String get hex => numbers.toHex(number,
      pad: true, forcePadLen: _addLenBytes * 2, include0x: true);

  /// Returns this address in a hexadecimal representation, without any prefix
  String get address => numbers.toHex(number,
      pad: true, forcePadLen: _addLenBytes * 2, include0x: false);

  @override
  String toString() => hex;

  static BigInt _hexToAddressNum(String hex) {
    try {
      if (!basicAddress.hasMatch(hex)) {
        throw new ArgumentError("Not a valid Address (needs to be "
            "hexadecimal, 20 bytes and optionally prefixed with 0x): $hex");
      }
      if (hex.toUpperCase() == hex || hex.toLowerCase() == hex) {
        return numbers.hexToInt(hex);
      }
      return numbers.hexToInt(hex);
    } catch (e) {
      throw e.toString();
    }

    // Either all lower or upper case => valid address, parse
  }
}

// extends the Address to Zillia Standard
// @immutable
class ZilAddress extends Address {
  String get hexAddress => this._getHexAddress();
  BigInt get bnAddress => this._getBigIntAddress();
  List<int> get byteAddress => this.toByteAddress(this.address);
  String get checkSumAddress => this.toCheckSumAddress(this.address);
  bool get isValid => this.isAddress(this.address);

  String get address => super.address;

  // constructor super from Address
  ZilAddress(String str) : super(str) {}

  @override
  String toString() => address;

  BigInt _getBigIntAddress() {
    return this.getBigIntAddress(this.address);
  }

  String _getHexAddress() {
    return '0x' + this.address;
  }

  BigInt getBigIntAddress(str) {
    return Address._hexToAddressNum(str);
  }

  // check if address is valid
  bool isAddress(str) {
    RegExp superReg = Address.basicAddress;
    return superReg.hasMatch(str);
  }

  // convert address to checkSumAddress
  String toCheckSumAddress(String address) {
    String stripAddress = numbers.strip0x(address.toLowerCase());
    final hash = sha256.convert(numbers.hexToBytes(stripAddress)).toString();
    String ret = '0x';

    BigInt v = numbers.hexToInt(hash);

    for (int i = 0; i < address.length; i++) {
      if ('0123456789'.contains(address[i])) {
        ret += address[i];
      } else {
        var checker = v & BigInt.from(2).pow(BigInt.from(255 - 6 * i).toInt());
        ret += checker >= BigInt.from(1)
            ? address[i].toUpperCase()
            : address[i].toLowerCase();
      }
    }

    return ret;
  }

  // conver hex string to Byte
  List<int> toByteAddress(String address) {
    String stripAddress = numbers.strip0x(address.toLowerCase());
    return numbers.hexToBytes(stripAddress);
  }

  static ZilAddress fromPrivateKey(String privateKey) =>
      new ZilAddress(crypto.getAddressFromPrivateKey(privateKey));

  static ZilAddress fromPublicKey(String publicKey) =>
      new ZilAddress(crypto.getAddressFromPublicKey(publicKey));

  static ZilAddress fromAddress(String address) => new ZilAddress(address);

  static ZilAddress fromBigInt(BigInt number) =>
      new ZilAddress(new Address.fromNumber(number).address);
}
