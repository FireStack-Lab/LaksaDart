abstract class Signature {}

class SchnorrSignature implements Signature {
  final BigInt r;
  final BigInt s;

  SchnorrSignature(this.r, this.s);

  String toString() => "(${r.toString()},${s.toString()})";

  bool operator ==(other) {
    if (other == null) return false;
    if (other is! SchnorrSignature) return false;
    return (other.r == this.r) && (other.s == this.s);
  }

  int get hashCode {
    return r.hashCode + s.hashCode;
  }
}
