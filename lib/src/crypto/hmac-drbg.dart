import 'package:crypto/crypto.dart';
import '../utils/common.dart';

class HMAC extends Hmac {
  Hash hash;

  dynamic key;
  List<int> inner;
  int get blockSize => hash.blockSize ~/ 8;

  // 父类没有无参数的非命名构造函数，必须手动调用一个构造函数
  HMAC(hash, key) : super(hash, key) {
    this.hash = hash;
    this.key = key;
    this.inner = List.from([]);
    // this.init(key);
  }
  HMAC _hmac() {
    return new HMAC(this.hash, this.key);
  }

  HMAC update(List<int> data) {
    this.inner.insertAll(this.inner.length, data);
    return this;
  }

  Digest digest() {
    return this.convert(this.inner);
  }
}

class DRBG<T> {
  Hash hash;
  List<int> entropy;
  List<int> nonce;
  List<int> pers;
  int get outLen => hash.blockSize * 4;
  dynamic K;
  dynamic V;
  dynamic _reseed;
  dynamic reseedInterval;

  DRBG(
      {Hash hash,
      dynamic entropy,
      dynamic nonce,
      dynamic pers,
      String entropyEnc,
      String nonceEnc,
      String persEnc}) {
    this.hash = hash;
    this.entropy = (entropy is List<int>)
        ? entropy
        : toArray(entropy, entropyEnc is String ? entropyEnc : 'hex');
    this.nonce = (nonce is List<int>)
        ? nonce
        : toArray(nonce, nonceEnc is String ? nonceEnc : 'hex');
    this.pers = (pers is List<int>)
        ? pers
        : toArray(pers, persEnc is String ? persEnc : 'hex');
    this.init();
  }

  void init() {
    //var seed = entropy.concat(nonce).concat(pers)
    List<int> seed = new List<int>(
        this.entropy.length + this.nonce.length + this.pers.length);
    seed.setRange(0, this.entropy.length, this.entropy);
    seed.setRange(this.entropy.length, this.entropy.length + this.nonce.length,
        this.nonce);
    seed.setRange(
        this.entropy.length + this.nonce.length, seed.length, this.pers);

    this.K = new List<int>(this.outLen ~/ 8);
    this.V = new List<int>(this.outLen ~/ 8);

    for (int i = 0; i < this.V.length; i++) {
      this.K[i] = 0x00;
      this.V[i] = 0x01;
    }
    this._update(seed);
    this._reseed = 1;
    this.reseedInterval = 0x1000000000000; // 2^48
    // print({'seedLength': seed.length, 'seed': seed});
  }

  HMAC _hmac() {
    return new HMAC(this.hash, this.K);
  }

  void _update(seed) {
    var kmac = this._hmac().update(this.V).update([0x00]);

    if (seed != null) {
      kmac.update(seed);
    }
    this.K = kmac.digest().bytes;
    this.V = this._hmac().update(this.V).digest().bytes;
    if (seed == null) return;

    this.K =
        this._hmac().update(this.V).update([0x01]).update(seed).digest().bytes;
    this.V = this._hmac().update(this.V).digest().bytes;
  }

  String generate(int len, [dynamic add]) {
    var temp = new List<T>();

    while (temp.length < len) {
      this.V = this._hmac().update(this.V).digest().bytes;
      temp.insertAll(temp.length, this.V);
    }

    var res = temp.sublist(0, len);
    this._update(add);
    this._reseed++;
    return toHex(res);
  }
}
