class RPCMethod {
  // Network-related methods
  final GetNetworkId = 'GetNetworkId';
  // GetClientVersion = 'GetClientVersion';
  // GetProtocolVersion = 'GetProtocolVersion';

  // Blockchain-related methods
  final GetBlockchainInfo = 'GetBlockchainInfo';
  final GetShardingStructure = 'GetShardingStructure';
  final GetDSBlock = 'GetDsBlock';
  final GetLatestDSBlock = 'GetLatestDsBlock';
  final GetNumDSBlocks = 'GetNumDSBlocks';
  final GetDSBlockRate = 'GetDSBlockRate';
  final DSBlockListing = 'DSBlockListing';
  final GetTxBlock = 'GetTxBlock';
  final GetLatestTxBlock = 'GetLatestTxBlock';
  final GetNumTxBlocks = 'GetNumTxBlocks';
  final GetTxBlockRate = 'GetTxBlockRate';
  final TxBlockListing = 'TxBlockListing';
  final GetNumTransactions = 'GetNumTransactions';
  final GetTransactionRate = 'GetTransactionRate';
  final GetCurrentMiniEpoch = 'GetCurrentMiniEpoch';
  final GetCurrentDSEpoch = 'GetCurrentDSEpoch';
  final GetPrevDifficulty = 'GetPrevDifficulty';
  final GetPrevDSDifficulty = 'GetPrevDSDifficulty';
  // GetBlockTransactionCount = 'GetBlockTransactionCount';

  // Transaction-related methods
  final CreateTransaction = 'CreateTransaction';
  final GetTransaction = 'GetTransaction';
  // GetTransactionReceipt = 'GetTransactionReceipt';
  final GetRecentTransactions = 'GetRecentTransactions';
  final GetNumTxnsTxEpoch = 'GetNumTxnsTxEpoch';
  final GetNumTxnsDSEpoch = 'GetNumTxnsDSEpoch';
  final GetMinimumGasPrice = 'GetMinimumGasPrice';
  // GetGasEstimate = 'GetGasEstimate';

  // Contract-related methods
  final GetSmartContractCode = 'GetSmartContractCode';
  final GetSmartContractInit = 'GetSmartContractInit';
  final GetSmartContractState = 'GetSmartContractState';
  final GetContractAddressFromTransactionID =
      'GetContractAddressFromTransactionID';
  // GetStorageAt = 'GetStorageAt';

  // Account-related methods
  final GetBalance = 'GetBalance';
}

class RPCErrorCode {
  // Standard JSON-RPC 2.0 errors
  // RPC_INVALID_REQUEST is internally mapped to HTTP_BAD_REQUEST (400).
  // It should not be used for application-layer errors.
  final RPC_INVALID_REQUEST = -32600;
  // RPC_METHOD_NOT_FOUND is internally mapped to HTTP_NOT_FOUND (404).
  // It should not be used for application-layer errors.
  final RPC_METHOD_NOT_FOUND = -32601;
  final RPC_INVALID_PARAMS = -32602;
  // RPC_INTERNAL_ERROR should only be used for genuine errors in bitcoind
  // (for example datadir corruption).
  final RPC_INTERNAL_ERROR = -32603;
  final RPC_PARSE_ERROR = -32700;

  // General application defined errors
  // std::exception thrown in command handling
  final RPC_MISC_ERROR = -1;
  // Unexpected type was passed as parameter
  final RPC_TYPE_ERROR = -3;
  // Invalid address or key
  final RPC_INVALID_ADDRESS_OR_KEY = -5;
  // Invalid; missing or duplicate parameter
  final RPC_INVALID_PARAMETER = -8;
  // Database error
  final RPC_DATABASE_ERROR = -20;
  // Error parsing or validating structure in raw format
  final RPC_DESERIALIZATION_ERROR = -22;
  // General error during transaction or block submission
  final RPC_VERIFY_ERROR = -25;
  // Transaction or block was rejected by network rules
  final RPC_VERIFY_REJECTED = -26;
  // Client still warming up
  final RPC_IN_WARMUP = -28;
  // RPC method is deprecated
  final RPC_METHOD_DEPRECATED = -32;
}

abstract class RPCRequestPayload<T> {
  final id = 1;
  final jsonrpc = '2.0';
  RPCMethod method;
  T params;
}

abstract class RPCRequestOptions {
  List headers;
  String method;
}

abstract class RPCRequest<T> {
  String url;
  RPCRequestPayload<T> payload;
  RPCRequestOptions options;
}

abstract class RPCResponseBase {
  final jsonrpc = '2.0';
  final id = '1';
}

abstract class RPCResponseSuccess<R> extends RPCResponseBase {
  R result;
  var error;
}

abstract class RPCResponseError<E> extends RPCResponseBase {
  var result;
  RPCError<E> error;
}

abstract class RPCError<E> {
  RPCErrorCode code;
  String message;
  E data;
}
