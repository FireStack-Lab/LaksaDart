@TestOn("vm")

import "package:test/test.dart";
import 'package:laksadart/src/utils/numbers.dart' as numbers;
import 'package:laksadart/src/utils/transaction.dart';

void main() {
  test('test protobuf encode transaction', () {
    Map<String, dynamic> txn = {
      'version': 0,
      'nonce': 0,
      'toAddr': '2E3C9B415B19AE4035503A06192A0FAD76E04243',
      'pubKey':
          '0246e7178dc8253201101e18fd6f6eb9972451d121fc57aa2a06dd5c111e58dc6a',
      'amount': BigInt.from(10000),
      'gasPrice': BigInt.from(100),
      'gasLimit': 1000,
      'code': '(* HelloWorld contract *)',
      'data': '[{"vname":"fuck"}]'
    };
    var encodedBuffer = encodeTransactionProto(txn);
    var expectedResult =
        '080010001a142e3c9b415b19ae4035503a06192a0fad76e0424322230a210246e7178dc8253201101e18fd6f6eb9972451d121fc57aa2a06dd5c111e58dc6a2a120a100000000000000000000000000000271032120a100000000000000000000000000000006438e8074219282a2048656c6c6f576f726c6420636f6e7472616374202a294a125b7b22766e616d65223a226675636b227d5d';
    expect(numbers.bytesToHex(encodedBuffer), equals(expectedResult));
  });
}
