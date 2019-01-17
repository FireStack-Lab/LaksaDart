import 'dart:typed_data';
import 'dart:convert';
import 'package:laksaDart/src/account/account.dart';
import 'package:laksaDart/src/core/ZilliqaModule.dart';
import 'package:laksaDart/src/messenger/Messenger.dart';
import 'package:laksaDart/src/account/wallet.dart';
import 'package:laksaDart/src/transaction/transaction.dart';
import 'util.dart';
import 'api.dart';
import 'contract.dart';
import 'testScilla.dart';

class Contracts implements ZilliqaModule<Messenger, void> {
  Messenger messenger;
  Wallet wallet;
  void setMessenger(Messenger data) {
    this.messenger = data;
  }

  Contracts({Messenger messenger, Wallet wallet}) {
    this.messenger = messenger;
    this.wallet = wallet;
  }

  Contract newContract({String code, List init}) {
    return new Contract(
        params: {'code': code, 'init': init},
        messenger: this.messenger,
        wallet: this.wallet,
        status: ContractStatus.INITIALISED);
  }

  Contract at(Contract contract) {
    return new Contract(
      params: {
        'code': contract.code,
        'init': contract.init,
        'ContractAddress': contract.ContractAddress,
        'status': contract.status,
        'transaction': contract.transaction
      },
      messenger: this.messenger,
      wallet: this.wallet,
    );
  }

  Future<bool> testContract({String code, List init}) async {
    TestScilla contract = new TestScilla(
        params: {'code': code, 'init': init},
        messenger: this.messenger,
        status: ContractStatus.INITIALISED);
    Map result = await contract
        // decode ABI from code first
        .decodeABI(code: code)
        // we set the init params to decoded ABI
        .then((decoded) =>
            decoded.setInitParamsValues(decoded.abi.getInitParams(), init))
        // we get the current block number from node, and set it to params
        .then((inited) => inited.setBlockNumber(null))
        // but we have to give it a test
        .then((ready) => ready.testCall(2000))
        // now we change the status to wait for sign
        .then((state) => state.status == ContractStatus.TESTED
            ? {'abi': state.abi, 'init': state.init, 'status': state.status}
            : false);
    if (result['status'] == ContractStatus.TESTED)
      return true;
    else
      return false;
  }
}
