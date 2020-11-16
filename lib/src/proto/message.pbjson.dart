///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const ByteArray$json = const {
  '1': 'ByteArray',
  '2': const [
    const {'1': 'data', '3': 1, '4': 2, '5': 12, '10': 'data'},
  ],
};

const ProtoTransactionCoreInfo$json = const {
  '1': 'ProtoTransactionCoreInfo',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 13, '10': 'version'},
    const {'1': 'nonce', '3': 2, '4': 1, '5': 4, '10': 'nonce'},
    const {'1': 'toaddr', '3': 3, '4': 1, '5': 12, '10': 'toaddr'},
    const {'1': 'senderpubkey', '3': 4, '4': 1, '5': 11, '6': '.ZilliqaMessage.ByteArray', '10': 'senderpubkey'},
    const {'1': 'amount', '3': 5, '4': 1, '5': 11, '6': '.ZilliqaMessage.ByteArray', '10': 'amount'},
    const {'1': 'gasprice', '3': 6, '4': 1, '5': 11, '6': '.ZilliqaMessage.ByteArray', '10': 'gasprice'},
    const {'1': 'gaslimit', '3': 7, '4': 1, '5': 4, '10': 'gaslimit'},
    const {'1': 'code', '3': 8, '4': 1, '5': 12, '10': 'code'},
    const {'1': 'data', '3': 9, '4': 1, '5': 12, '10': 'data'},
  ],
};

const ProtoTransaction$json = const {
  '1': 'ProtoTransaction',
  '2': const [
    const {'1': 'tranid', '3': 1, '4': 1, '5': 12, '10': 'tranid'},
    const {'1': 'info', '3': 2, '4': 1, '5': 11, '6': '.ZilliqaMessage.ProtoTransactionCoreInfo', '10': 'info'},
    const {'1': 'signature', '3': 3, '4': 1, '5': 11, '6': '.ZilliqaMessage.ByteArray', '10': 'signature'},
  ],
};

const ProtoTransactionReceipt$json = const {
  '1': 'ProtoTransactionReceipt',
  '2': const [
    const {'1': 'receipt', '3': 1, '4': 1, '5': 12, '10': 'receipt'},
    const {'1': 'cumgas', '3': 2, '4': 1, '5': 4, '10': 'cumgas'},
  ],
};

const ProtoTransactionWithReceipt$json = const {
  '1': 'ProtoTransactionWithReceipt',
  '2': const [
    const {'1': 'transaction', '3': 1, '4': 1, '5': 11, '6': '.ZilliqaMessage.ProtoTransaction', '10': 'transaction'},
    const {'1': 'receipt', '3': 2, '4': 1, '5': 11, '6': '.ZilliqaMessage.ProtoTransactionReceipt', '10': 'receipt'},
  ],
};

