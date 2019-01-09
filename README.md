# Laksa, Dart Version

** !! Do Not Use in Production !! **

## Porting from Laksa and ZilliqaJS

- Account

  - create
  - toFile
  - fromFile
  - signTransaction

- Wallet

  - add
  - remove
  - getAccount
  - encryptAccount
  - decryptAccount
  - setDefaultAccount
  - getDefaultAccount

- crypto

  - getDerivedKey ((keystore))
  - encrypt(keystore)
  - decrypt(keystore)
  - sign(Schnorr function)
  - verify(Schnorr function)
  - SchnorrSign(Schnorr function with protobuf encodation)
  - generatePrivateKey
  - getPublicKeyFromPrivateKey
  - getPublicKeyFromPrivateKey
  - getAddressFromPublicKey
  - getAddressFromPrivateKey
  - hmac-drbg(HMAC update digest)
  - getDRBG(inner function)
  - generateNewPrivateKey(inner function)
  - privateKeyToPublic(inner function)
  - getPublic(inner function)

- Messenger

  - send
  - sendServer(Scilla runner)
  - setNodeProvider
  - setScillaProvider
  - setMiddleware
  - useMiddleware

- Provider

  - BaseProvider
  - HttpProvider
    - buildPayload
    - buildEndpointPayload
    - performRPC
    - send
    - sendServer(Scilla runner)
  - RPCMiddleware
    - RPCResponseBody
      - SuccessMiddleware
      - ErrorMiddleware
  - RPCMehod
  - Endpoint

- Transaction

  - Factory
  - sendTransaction
  - trackTx
  - confirm
  - getVersion(calculate version number)

- Contract

  - Factory
  - deploy
  - call
  - confirmTx
  - sendContract
  - signTxn
  - getState
  - setInitParamsValues
  - setDeployPayload
  - setCallPayload

- utils
  - numbers.strip0x
  - numbers.toHex
  - numbers.bytesToHex
  - numbers.numberToBytes
  - numbers.hexToBytes
  - numbers.intToBytes
  - numbers.hexToInt
  - validators.isUrl
  - validators.isByteString
  - validators.isAddres
  - validators.isPublicKey
  - validators.isPrivateKey
  - validators.isSignature
  - unit.fromQa
  - unit.toQa
  - encodeTransactionProto

## Thanks to

- Zilliqa, who make the js lib originally.
- PointyCastle, who make the dart crypto packages.
- Web3Dart, who make the web3 dart version.
