# Laksa, Dart Version

Waiting for Usage example and docs

## Porting from Laksa and ZilliqaJS

- Account

  - [x] create
  - [x] toFile
  - [x] fromFile
  - [x] signTransaction

- Wallet

  - [x] add
  - [x] remove
  - [x] getAccount
  - [x] encryptAccount
  - [x] decryptAccount
  - [x] setDefaultAccount
  - [x] getDefaultAccount

- crypto

  - [x] getDerivedKey ((keystore))
  - [x] encrypt(keystore)
  - [x] decrypt(keystore)
  - [x] sign(Schnorr function)
  - [x] verify(Schnorr function)
  - [x] SchnorrSign(Schnorr function with protobuf encodation)
  - [x] generatePrivateKey
  - [x] getPublicKeyFromPrivateKey
  - [x] getPublicKeyFromPrivateKey
  - [x] getAddressFromPublicKey
  - [x] getAddressFromPrivateKey
  - [x] hmac-drbg(HMAC update digest)
  - [x] getDRBG(inner function)
  - [x] generateNewPrivateKey(inner function)
  - [x] privateKeyToPublic(inner function)
  - [x] getPublic(inner function)

- Messenger

  - [x] send
  - [x] sendServer(Scilla runner)
  - [x] setNodeProvider
  - [x] setScillaProvider
  - [x] setMiddleware
  - [x] useMiddleware

- Blockchain(RPC methods)

  - [x] getBalance
  - [x] getBlockchainInfo
  - [x] getDSBlock
  - [x] getTxBlock
  - [x] getLatestDSBlock
  - [x] getNumDSBlocks
  - [x] getDSBlockRate
  - [x] getDSBlockListing
  - [x] getLatestTxBlock
  - [x] getNumTxBlocks
  - [x] getTxBlockRate
  - [x] getTxBlockListing
  - [x] getNumTransactions
  - [x] getTransactionRate
  - [x] getCurrentMiniEpoch
  - [x] getCurrentDSEpoch
  - [x] getPrevDifficulty
  - [x] getPrevDSDifficulty
  - [x] getRecentTransactions
  - [x] getNumTxnsTxEpoch
  - [x] getNumTxnsDSEpoch
  - [x] getMinimumGasPrice
  - [x] createTransaction
  - [x] checkCode(Scilla runner)
  - [x] testCall(Scilla runner)

- Provider

  - BaseProvider
  - HttpProvider
    - [x] buildPayload
    - [x] buildEndpointPayload
    - [x] performRPC
    - [x] send
    - [x] sendServer(Scilla runner)
  - RPCMiddleware
    - [x] RPCResponseBody
    - [x] SuccessMiddleware
    - [x] ErrorMiddleware
  - RPCMehod
  - Endpoint

- Transaction

  - [x] Factory
  - [x] sendTransaction
  - [x] trackTx
  - [x] confirm
  - [x] getVersion(calculate version number)

- Contract

  - [x] Factory
  - [x] deploy
  - [x] call
  - [x] confirmTx
  - [x] sendContract
  - [x] signTxn
  - [x] getState
  - [x] setInitParamsValues
  - [x] setDeployPayload
  - [x] setCallPayload

- utils
  - [x] numbers.strip0x
  - [x] numbers.toHex
  - [x] numbers.bytesToHex
  - [x] numbers.numberToBytes
  - [x] numbers.hexToBytes
  - [x] numbers.intToBytes
  - [x] numbers.hexToInt
  - [x] validators.isUrl
  - [x] validators.isByteString
  - [x] validators.isAddres
  - [x] validators.isPublicKey
  - [x] validators.isPrivateKey
  - [x] validators.isSignature
  - [x] unit.fromQa
  - [x] unit.toQa
  - [x] encodeTransactionProto

## Thanks to

- Zilliqa, who make the js lib originally.
- PointyCastle, who make the dart crypto packages.
- Web3Dart, who make the web3 dart version.
