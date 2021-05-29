import 'dart:async';
import 'package:meta/meta.dart';

import 'package:laksadart/src/crypto/schnorr.dart' as crypto;
import 'package:laksadart/src/crypto/isolates.dart';
import 'package:laksadart/src/crypto/bech32.dart';
import 'package:laksadart/src/crypto/checksum.dart';
import 'package:laksadart/src/utils/numbers.dart' as numbers;
import 'package:laksadart/src/utils/validators.dart' as validator;

@immutable
class Address {
  static final RegExp basicAddress = new RegExp(r"^(0x)?[0-9a-f]{40}", caseSensitive: false);

  static const int _addLenBytes = 20;
  static final BigInt biggestAddress = (BigInt.one << (_addLenBytes * 8)) - BigInt.one;

  /// The number associated with the address
  final BigInt number;
  // final String str;
  Address(String hex) : this.fromNumber(_hexToAddressNum(hex));

  /// Creates an address from its number
  Address.fromNumber(this.number) {
    if (number.isNegative) {
      throw new ArgumentError("Addresses must be positive");
    }
    if (number > biggestAddress) {
      throw new ArgumentError("Addresses must fit in $_addLenBytes bytes");
    }
  }

  /// Returns this address in a hexadecimal representation, with 0x prefixed.
  String get hex =>
      numbers.toHex(number, pad: true, forcePadLen: _addLenBytes * 2, include0x: true);

  /// Returns this address in a hexadecimal representation, without any prefix
  String get address =>
      numbers.toHex(number, pad: true, forcePadLen: _addLenBytes * 2, include0x: false);

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

enum AddressType { CheckSum, Bech32, Bytes20, Bytes20Hex, Invalid }

/// extends the Address to Zillia Standard
///
///
class ZilAddress extends Address {
  String get hexAddress => this._getHexAddress();
  BigInt get bnAddress => this._getBigIntAddress();
  List<int> get byteAddress => this.toByteAddress(this.address);
  String get checkSumAddress => this.toCheckSumAddress(this.address);
  String get bech32 => toBech32Address(this.checkSumAddress);
  String get bytes20Hex => this.toBytes20Hex(this.address);
  bool get isValid => this.isAddress(this.address);

  String get address => super.address;

  /// constructor super from Address
  ZilAddress(String str) : super(str);

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

  /// check if address is valid
  bool isAddress(str) {
    RegExp superReg = Address.basicAddress;
    return superReg.hasMatch(str);
  }

  /// convert address to checkSumAddress
  String toCheckSumAddress(String address) {
    return toChecksum(address);
  }

  String toBytes20Hex(String address) {
    return this.toCheckSumAddress(address).toLowerCase();
  }

  /// conver hex string to Byte
  List<int> toByteAddress(String address) {
    String stripAddress = numbers.strip0x(address.toLowerCase());
    return numbers.hexToBytes(stripAddress);
  }

  static String toCheckSum(String address) {
    return toChecksum(address);
  }

  static ZilAddress fromPrivateKey(String privateKey) =>
      new ZilAddress(crypto.getAddressFromPrivateKey(privateKey));

  static ZilAddress fromPublicKey(String publicKey) =>
      new ZilAddress(crypto.getAddressFromPublicKey(publicKey));

  static Future<ZilAddress> asyncFromPrivateKey(String privateKey) async {
    return new ZilAddress(await (asyncGetAddressFromPrivateKey(privateKey) as FutureOr<String>));
  }

  static Future<ZilAddress> asyncFromPublicKey(String publicKey) async {
    return new ZilAddress(await (asyncGetAddressFromPublicKey(publicKey) as FutureOr<String>));
  }

  static ZilAddress fromAddress(String address) => new ZilAddress(address.toLowerCase());

  static ZilAddress fromBigInt(BigInt number) =>
      new ZilAddress(new Address.fromNumber(number).address);

  static AddressType getAddressType(String raw) {
    if (validator.isAddress(raw) && validator.isValidChecksumAddress(raw)) {
      return AddressType.CheckSum;
    } else if (validator.isAddress(raw) &&
        !validator.isValidChecksumAddress(raw) &&
        raw.startsWith('0x')) {
      return AddressType.Bytes20Hex;
    } else if (validator.isAddress(raw) &&
        !validator.isValidChecksumAddress(raw) &&
        !raw.startsWith('0x')) {
      return AddressType.Bytes20;
    } else if (validator.isBech32(raw) &&
        validator.isValidChecksumAddress(fromBech32Address(raw))) {
      return AddressType.Bech32;
    } else {
      return AddressType.Invalid;
    }
  }

  static toValidAddress(String addr) {
    if (getAddressType(addr) == AddressType.CheckSum) {
      return addr;
    } else if (getAddressType(addr) == AddressType.Bech32) {
      return toChecksum(fromBech32Address(addr));
    } else {
      throw 'Invalid address';
    }
  }
}
