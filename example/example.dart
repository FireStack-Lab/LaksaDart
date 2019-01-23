import 'dart:convert';
import 'dart:io';
// import 'package:crypto/crypto.dart';
// import 'package:crypto/src/digest_sink.dart';

import 'package:laksadart/src/utils/unit.dart' as unit;
import 'package:laksadart/laksadart.dart';

main() async {
  var laksa = new Laksa(
      nodeUrl: 'https://api.zilliqa.com', // 'https://api.zilliqa.com',
      scillaUrl: 'https://scilla-runner.zilliqa.com');

  var acc = laksa.wallet
      .add('e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');

  void autoTransaction() async {
    await acc.updateBalance();
    var nonce = acc.nonce;
    var txn = laksa.transactions.newTx({
      'toAddr': '2E3C9B415B19AE4035503A06192A0FAD76E04243',
      'amount': unit.Unit.Li(nonce + 1).qa,
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
    File contract = new File('../test/contracts/helloworldversion.txt');
    await contract.readAsString().then((contractString) async {
      Laksa laksa = new Laksa(
          nodeUrl:
              'https://api.zilliqa.com', //'https://staging-api.aws.z7a.xyz'
          scillaUrl: 'https://scilla-runner.zilliqa.com');
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
          gasLimit: 10000, gasPrice: BigInt.from(1000000000));
      var sent = await newContract.sendContract();
      print(sent.transaction.toPayload);
      var sendTime = DateTime.now();
      print('sent contract at:$sendTime');
      print(sent.transaction.TranID);
      var deployed = await sent.confirmTx(maxAttempts: 33, interval: 1000);
      print(deployed.ContractAddress);
      if (deployed != null) {
        var during = DateTime.now().difference(sendTime);
        print('deployed confirmed during:$during');
      }

      // test call contract

      deployed.setCallPayload(
          params: [
            {'vname': "msg", 'type': "String", 'value': "Hello World"}
          ],
          gasLimit: 8000,
          gasPrice: unit.Unit.Li(1000).qa,
          amount: unit.Unit.Qa(0).qa);
      var sentCall = await deployed.sendContract();
      print(sentCall.transaction.toPayload);
      var calledTime = DateTime.now();
      print('sent called time:$calledTime');
      print(sentCall.transaction.TranID);

      var called = await sentCall.confirmTx(maxAttempts: 33, interval: 1000);
      print(called.ContractAddress);
      if (called != null) {
        var during2 = DateTime.now().difference(calledTime);
        print('deployed confirmed during:$during2');
      }
      var state = await called.getState();
      print("The state of the contract is:$state");
    });
  }

  void wallet() async {
    Laksa laksa = new Laksa(
        nodeUrl: 'https://api.zilliqa.com', //'https://staging-api.aws.z7a.xyz'
        scillaUrl: 'https://scilla-runner.zilliqa.com');
    var newAcc = laksa.wallet.create();
    await newAcc.updateBalance();
    print(newAcc.balance);
  }

  // await wallet();
  // await autoTransaction();
  // await deploy();
  // var addr =
  //     new HMAC(sha256, hexToBytes('9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a'))
  //         .update(hexToBytes(numberToHexArray(18, 16).join('')))
  //         .digest()
  //         .bytes;
  // print(bytesToHex(addr).substring(24));

  // var ds = new DigestSink();
  // var s = sha256.startChunkedConversion(ds);
  // s.add(hexToBytes('9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a'));
  // s.add(hexToBytes(numberToHexArray(18, 16)
  //     .join(''))); // call `add` for every chunk of input data
  // s.close();
  // var digest = ds.value;

  var newSha = SHA256()
      .update(hexToBytes('9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a'))
      .update(hexToBytes(numberToHexArray(18, 16).join('')))
      .toString();

  print(newSha.substring(24));
}
