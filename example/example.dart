import 'dart:convert';
import 'dart:io';
import 'package:laksadart/src/utils/network.dart';
import 'package:laksadart/src/utils/unit.dart' as unit;
import 'package:laksadart/laksadart.dart';
import 'package:laksadart/src/utils/numbers.dart' as numbers;

main() async {
  var zilliqa = new Zilliqa(network: zilliqaNetworks["dev"]);
  wallet(zilliqa);
  var account = zilliqa.wallet
      .add('e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');

  autoTransaction(account, zilliqa);
  deploy();
}

void wallet(Zilliqa zilliqa) async {
  print("Creating a New Wallet");
  var newAcc = zilliqa.wallet.create();
  await newAcc.encryptAccount('passphrase');
  print("New Wallet Bech32 Address: ${newAcc.address!.bech32}");
  await newAcc.updateBalance();
  print("New Wallet Balance ${newAcc.balance}");
}

void autoTransaction(Account? acc, Zilliqa zilliqa) async {
  print("Auto Transaction");
  await acc!.encryptAccount('111');
  await acc.updateBalance();
  var nonce = acc.nonce!;
  var txn = zilliqa.transactions.newTx({
    'toAddr': ZilAddress('2e3c9b415b19ae4035503a06192a0fad76e04243').bech32,
    'amount': unit.Unit.Li(nonce + 1).qa,
    'gasPrice': unit.Unit.Li(2000).qa,
    'gasLimit': 50,
    'version': numbers.pack(zilliqa.network!.chainID!, 1),
  });

  var signed = await acc.signTransaction(txn, passphrase: '111');
  print("Transaction Payload: ${json.encode(signed.toPayload)}");
  var sent = await signed.sendTransaction();
  if (sent == null) {
    print("sent txn is null");
    return;
  }
  print("Transaction ID ${sent.transaction.transactionID}");
  var sendTime = DateTime.now();
  print("Transaction is confirmed?");
  var result =
      await sent.transaction.confirm(txHash: sent.transaction.transactionID);
  print(result.getReceiptInfo(zilliqa.network!.blockExplorerNetwork!));
  var during = DateTime.now().difference(sendTime);
  print('Transaction Confirmed: $during');
}

void deploy() async {
  print("Deploy Contract");
  File contract = new File('contracts/hello_world.scilla');

  await contract.readAsString().then((contractString) async {
    Zilliqa zilliqa = new Zilliqa(nodeUrl: 'https://dev-api.zilliqa.com');
    var init = [
      {"vname": "_scilla_version", "type": "Uint32", "value": "0"},
      {
        "vname": "owner",
        "type": "ByStr20",
        "value": "0x9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a"
      },
    ];

    zilliqa.wallet.add(
        'e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');

    var newContract = zilliqa.contracts.newContract(
        code: contractString,
        init: init,
        version: numbers.pack(zilliqa.network!.chainID!, 1));
    newContract.setDeployPayload(
        gasLimit: 1225, gasPrice: BigInt.from(3000000000), toDS: false);
    var sent = await newContract.sendContract();
    print("Sent Transaction Payload: ${sent.transaction!.toPayload}");
    var sendTime = DateTime.now();
    print('Sent Contract at: $sendTime');
    print("Sent Transaction ID: ${sent.transaction!.transactionID}");
    var deployed = await sent.confirmTx();
    print("Deployed Contract Status ${deployed.status}");
    print("Deployed Contract Address: ${deployed.contractAddress}");
    var during = DateTime.now().difference(sendTime);
    print('Deployed Confirmed: $during');

    // test call contract

    deployed.setCallPayload(
        transition: 'setHello',
        params: [
          {'vname': "msg", 'type': "String", 'value': "Hello Worldz!"}
        ],
        gasLimit: 10000,
        gasPrice: unit.Unit.Li(2000).qa,
        amount: unit.Unit.Qa(0).qa,
        toDS: false);
    var sentCall = await deployed.sendContract();
    print("Sent Call Transaction Payload: ${sentCall.transaction!.toPayload}");
    var calledTime = DateTime.now();
    print('Sent Call Time: $calledTime');
    print("Sent Call Transaction ID: ${sentCall.transaction!.transactionID}");

    var result = await sentCall.confirmTx();
    print("Called Contract Status: ${result.status}");
    print("Called Contract Address: ${sentCall.contractAddress}");
    var during2 = DateTime.now().difference(calledTime);
    var state = await sentCall.getState();
    var message = state!.resultMap!["welcome_msg"];
    print("Called Contract State: $message");
    print('Called Confirmed: $during2');
    //'https://scilla-runner.zilliqa.com'
  });
}
