class RPCMethod {
  // Network-related methods
  static final GetNetworkId = 'GetNetworkId';
  static final GetClientVersion = 'GetClientVersion';
  static final GetProtocolVersion = 'GetProtocolVersion';

  // Blockchain-related methods
  static final GetBalance = 'GetBalance';
  static final GetBlockchainInfo = 'GetBlockchainInfo';
  static final GetShardingStructure = 'GetShardingStructure';
  static final GetDSBlock = 'GetDsBlock';
  static final GetLatestDSBlock = 'GetLatestDsBlock';
  static final GetNumDSBlocks = 'GetNumDSBlocks';
  static final GetDSBlockRate = 'GetDSBlockRate';
  static final DSBlockListing = 'DSBlockListing';
  static final GetTxBlock = 'GetTxBlock';
  static final GetLatestTxBlock = 'GetLatestTxBlock';
  static final GetNumTxBlocks = 'GetNumTxBlocks';
  static final GetTxBlockRate = 'GetTxBlockRate';
  static final TxBlockListing = 'TxBlockListing';
  static final GetNumTransactions = 'GetNumTransactions';
  static final GetTransactionRate = 'GetTransactionRate';
  static final GetCurrentMiniEpoch = 'GetCurrentMiniEpoch';
  static final GetCurrentDSEpoch = 'GetCurrentDSEpoch';
  static final GetPrevDifficulty = 'GetPrevDifficulty';
  static final GetPrevDSDifficulty = 'GetPrevDSDifficulty';
  // GetBlockTransactionCount = 'GetBlockTransactionCount';

  // Transaction-related methods
  static final CreateTransaction = 'CreateTransaction';
  static final GetTransaction = 'GetTransaction';
  // GetTransactionReceipt = 'GetTransactionReceipt';
  static final GetRecentTransactions = 'GetRecentTransactions';
  static final GetNumTxnsTxEpoch = 'GetNumTxnsTxEpoch';
  static final GetNumTxnsDSEpoch = 'GetNumTxnsDSEpoch';
  static final GetMinimumGasPrice = 'GetMinimumGasPrice';
  // GetGasEstimate = 'GetGasEstimate';

  // Contract-related methods
  static final GetSmartContractCode = 'GetSmartContractCode';
  static final GetSmartContractInit = 'GetSmartContractInit';
  static final GetSmartContractState = 'GetSmartContractState';
  static final GetContractAddressFromTransactionID =
      'GetContractAddressFromTransactionID';
  // GetStorageAt = 'GetStorageAt';

  // Account-related methods

  Map get Mapping => {
        GetNetworkId: 'GetNetworkId',
        GetClientVersion: 'GetClientVersion',
        GetProtocolVersion: 'GetProtocolVersion',
        GetBlockchainInfo: 'GetBlockchainInfo',
        GetShardingStructure: 'GetShardingStructure',
        GetDSBlock: 'GetDsBlock',
        GetLatestDSBlock: 'GetLatestDsBlock',
        GetNumDSBlocks: 'GetNumDSBlocks',
        GetDSBlockRate: 'GetDSBlockRate',
        DSBlockListing: 'DSBlockListing',
        GetTxBlock: 'GetTxBlock',
        GetLatestTxBlock: 'GetLatestTxBlock',
        GetNumTxBlocks: 'GetNumTxBlocks',
        GetTxBlockRate: 'GetTxBlockRate',
        TxBlockListing: 'TxBlockListing',
        GetNumTransactions: 'GetNumTransactions',
        GetTransactionRate: 'GetTransactionRate',
        GetCurrentMiniEpoch: 'GetCurrentMiniEpoch',
        GetCurrentDSEpoch: 'GetCurrentDSEpoch',
        GetPrevDifficulty: 'GetPrevDifficulty',
        GetPrevDSDifficulty: 'GetPrevDSDifficulty',
        // GetBlockTransactionCount : 'GetBlockTransactionCount',

        // Transaction-related methods
        CreateTransaction: 'CreateTransaction',
        GetTransaction: 'GetTransaction',
        // GetTransactionReceipt : 'GetTransactionReceipt',
        GetRecentTransactions: 'GetRecentTransactions',
        GetNumTxnsTxEpoch: 'GetNumTxnsTxEpoch',
        GetNumTxnsDSEpoch: 'GetNumTxnsDSEpoch',
        GetMinimumGasPrice: 'GetMinimumGasPrice',
        // GetGasEstimate : 'GetGasEstimate',

        // Contract-related methods
        GetSmartContractCode: 'GetSmartContractCode',
        GetSmartContractInit: 'GetSmartContractInit',
        GetSmartContractState: 'GetSmartContractState',
        GetContractAddressFromTransactionID:
            'GetContractAddressFromTransactionID',
        // GetStorageAt : 'GetStorageAt',

        // Account-related methods
        GetBalance: 'GetBalance',
      };
}

class RPCErrorCode {
  // Standard JSON-RPC 2.0 errors
  // RPC_INVALID_REQUEST is internally mapped to HTTP_BAD_REQUEST (400).
  // It should not be used for application-layer errors.
  static final RPC_INVALID_REQUEST = -32600;
  // RPC_METHOD_NOT_FOUND is internally mapped to HTTP_NOT_FOUND (404).
  // It should not be used for application-layer errors.
  static final RPC_METHOD_NOT_FOUND = -32601;
  static final RPC_INVALID_PARAMS = -32602;
  // RPC_INTERNAL_ERROR should only be used for genuine errors in bitcoind
  // (for example datadir corruption).
  static final RPC_INTERNAL_ERROR = -32603;
  static final RPC_PARSE_ERROR = -32700;

  // General application defined errors
  // std::exception thrown in command handling
  static final RPC_MISC_ERROR = -1;
  // Unexpected type was passed as parameter
  static final RPC_TYPE_ERROR = -3;
  // Invalid address or key
  static final RPC_INVALID_ADDRESS_OR_KEY = -5;
  // Invalid; missing or duplicate parameter
  static final RPC_INVALID_PARAMETER = -8;
  // Database error
  static final RPC_DATABASE_ERROR = -20;
  // Error parsing or validating structure in raw format
  static final RPC_DESERIALIZATION_ERROR = -22;
  // General error during transaction or block submission
  static final RPC_VERIFY_ERROR = -25;
  // Transaction or block was rejected by network rules
  static final RPC_VERIFY_REJECTED = -26;
  // Client still warming up
  static final RPC_IN_WARMUP = -28;
  // RPC method is deprecated
  static final RPC_METHOD_DEPRECATED = -32;

  String CodeString;
  int CodeNumber;

  Map get Mapping => {
        RPC_INVALID_REQUEST: 'RPC_INVALID_REQUEST',
        RPC_METHOD_NOT_FOUND: 'RPC_METHOD_NOT_FOUND',
        RPC_INVALID_PARAMS: 'RPC_INVALID_PARAMS',
        RPC_INTERNAL_ERROR: 'RPC_INTERNAL_ERROR',
        RPC_PARSE_ERROR: 'RPC_PARSE_ERROR',
        RPC_MISC_ERROR: 'RPC_MISC_ERROR',
        RPC_TYPE_ERROR: 'RPC_TYPE_ERROR',
        RPC_INVALID_ADDRESS_OR_KEY: 'RPC_INVALID_ADDRESS_OR_KEY',
        RPC_INVALID_PARAMETER: 'RPC_INVALID_PARAMETER',
        RPC_DATABASE_ERROR: 'RPC_DATABASE_ERROR',
        RPC_DESERIALIZATION_ERROR: 'RPC_DESERIALIZATION_ERROR'
      };
  RPCErrorCode(int code) {
    this.CodeNumber = code;
    this.CodeString = this.Mapping[code];
  }

  Error throwError() {
    throw this.CodeString;
  }

  @override
  toString() {
    return this.CodeString;
  }
}

abstract class RPCRequestPayload<T> {
  static final id = 1;
  static final jsonrpc = '2.0';
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

abstract class RPCResponseBody<R, E> extends RPCResponseBase {
  R result;
  E error;
}

abstract class RPCError<E> {
  RPCErrorCode code;
  String message;
  E data;
}
