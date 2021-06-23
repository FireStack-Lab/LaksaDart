import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart';
import 'package:laksadart/src/utils/numbers.dart';

class SHA256 {
  late DigestSink ds;
  late ByteConversionSink sha;

  SHA256() {
    this.ds = new DigestSink();
    this.sha = sha256.startChunkedConversion(ds);
  }

  SHA256 update(List<int> bytes) {
    this.sha.add(bytes);
    return this;
  }

  List<int> digest() {
    this.sha.close();
    return this.ds.value.bytes;
  }

  @override
  String toString() {
    var bytes = this.digest();
    return bytesToHex(bytes);
  }
}
