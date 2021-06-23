import 'dart:async';

const mil = const Duration(milliseconds: 1);
Timer sleep({required int ms, Function? callback}) {
  var duration = mil * ms;
  return new Timer(duration, () => callback);
}
