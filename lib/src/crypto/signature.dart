abstract class Signature {}

class SchnorrSignature implements Signature {
  final BigInt? r;
  final BigInt? s;

  SchnorrSignature(this.r, this.s);

  String toString() => "(${r.toString()},${s.toString()})";

  String get signature => "${r!.toRadixString(16)}" + "${s!.toRadixString(16)}";

  bool operator ==(Object? other) {
    if (other == null) return false;
    if (other is! SchnorrSignature) return false;
    return (other.r == this.r) && (other.s == this.s);
  }

  int get hashCode {
    return r.hashCode + s.hashCode;
  }
}
