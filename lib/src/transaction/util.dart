import 'dart:async';

const mil = const Duration(milliseconds: 1);
Timer sleep({int ms, Function callback}) {
  var duration = mil * ms;
  return new Timer(duration, () => callback);
}
