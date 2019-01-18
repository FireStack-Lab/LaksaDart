import 'dart:convert';
import 'dart:io';

import 'package:laksaDart/src/utils/unit.dart' as unit;
import 'package:laksaDart/src/Laksa.dart' show Laksa;

main() async {
  var laksa = new Laksa(
      nodeUrl: 'https://api.zilliqa.com',
      scillaUrl: 'https://scilla-runner.zilliqa.com');

  var acc = laksa.wallet
      .add('e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');

  void autoTransaction() async {
    await acc.updateBalance();
    var nonce = acc.nonce;
    var txn = laksa.transactions.newTx({
      'toAddr': '2E3C9B415B19AE4035503A06192A0FAD76E04243',
      'amount': unit.Unit.Zil(nonce + 1).qa,
      'gasPrice': unit.Unit.Li(1000).qa,
      'gasLimit': 1,
      'version': laksa.messenger.setTransactionVersion(1)
    });

    var signed = await acc.signTransaction(txn);
    print(json.encode(signed.toPayload));
    var sent = await signed.sendTransaction();
    print(sent.transaction.TranID);
    var sendTime = DateTime.now();
    var result = await sent.transaction.confirm(
        txHash: sent.transaction.TranID, maxAttempts: 33, interval: 1000);
    print(result.receipt['success']);
    if (result != null) {
      var during = DateTime.now().difference(sendTime);
      print('confirmed during:$during');
    }
  }

  void deploy() async {
    File contract = new File('../test/contracts/helloworld.txt');
    await contract.readAsString().then((contractString) async {
      Laksa laksa = new Laksa(nodeUrl: 'https://api.zilliqa.com');
      // laksa.setScillaProvider('https://scilla-runner.zilliqa.com');
      var init = [
        {
          'vname': '_scilla_version',
          'type': 'Uint32',
          'value': '0',
        },
        {
          'value': '0x9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a',
          'vname': 'owner',
          'type': 'ByStr20'
        }
      ];

      laksa.wallet.add(
          'e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');

      var newContract =
          laksa.contracts.newContract(code: contractString, init: init);
      newContract.setDeployPayload(
          gasLimit: 2500000000000, gasPrice: BigInt.from(1000000000));
      var sent = await newContract.sendContract();
      print(sent.transaction.TranID);
      var deployed = await sent.confirmTx(maxAttempts: 33, interval: 1000);
      print(deployed.ContractAddress);
    });
  }

  await autoTransaction();
  await deploy();
}
