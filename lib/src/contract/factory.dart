import 'dart:async';
import 'package:laksadart/src/core/zilliqa_module.dart';
import 'package:laksadart/src/messenger/messenger.dart';
import 'package:laksadart/src/account/wallet.dart';
import 'package:laksadart/src/transaction/index.dart';
import 'package:laksadart/src/crypto/index.dart';
import 'package:laksadart/src/utils/numbers.dart' as numbers;

import 'util.dart';
import 'contract.dart';
import 'testScilla.dart';

class Contracts implements ZilliqaModule {
  Messenger? _messenger;
  Wallet? _wallet;

  @override
  Messenger get messenger => this._messenger!;

  @override
  void set messenger(Messenger? messenger) => this._messenger = messenger;

  Wallet get wallet => this._wallet!;
  void set wallet(Wallet? wallet) => this._wallet = wallet;

  Contracts({Messenger? messenger, Wallet? wallet}) {
    this.messenger = messenger;
    this.wallet = wallet;
  }

  Contract newContract({String? code, List? init, int? version, bool? toDS}) {
    return new Contract(
        params: {'code': code, 'init': init, 'version': version},
        messenger: this.messenger,
        wallet: this.wallet,
        status: ContractStatus.INITIALISED,
        toDS: toDS);
  }

  Contract at(Contract contract) {
    return new Contract(params: {
      'code': contract.code,
      'init': contract.init,
      'version': contract.version,
      'ContractAddress': contract.contractAddress,
      'status': contract.status,
      'transaction': contract.transaction,
    }, messenger: this.messenger, wallet: this.wallet, toDS: contract.toDS);
  }

  String getAddressForContract(Transaction tx) {
    var nonce = tx.txParams['nonce'] ? tx.txParams['nonce'] - 1 : 0;
    var newSha = SHA256()
        .update(numbers.hexToBytes(tx.senderAddress))
        .update(
            numbers.hexToBytes(numbers.numberToHexArray(nonce, 16).join('')))
        .toString();
    return newSha.substring(24);
  }

  Future<bool> testContract({String? code, List? init, int? version}) async {
    TestScilla contract = new TestScilla(
        params: {'code': code, 'init': init, 'version': version},
        messenger: this.messenger,
        status: ContractStatus.INITIALISED);
    Map result = await contract
        // decode ABI from code first
        .decodeABI(code: code)
        // we set the init params to decoded ABI
        .then((decoded) => decoded.setInitParamsValues(
            decoded.abi!.getInitParams()!,
            init as List<Map<dynamic, dynamic>>?))
        // we get the current block number from node, and set it to params
        .then((inited) => inited.setBlockNumber(null))
        // but we have to give it a test
        .then((ready) => ready.testCall(2000))
        // now we change the status to wait for sign
        .then((state) => state.status == ContractStatus.TESTED
            ? {'abi': state.abi, 'init': state.init, 'status': state.status}
            : {
                'abi': state.abi,
                'init': state.init,
                'status': ContractStatus.ERROR,
              });
    return result['status'] == ContractStatus.TESTED;
  }
}
