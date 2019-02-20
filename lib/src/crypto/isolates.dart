import 'dart:isolate';
import 'schnorr.dart';
import 'keystore/api.dart';

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncEncrypt(String prvKey, String psw,
    [Map<String, dynamic> options]) async {
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  var isolate = await Isolate.spawn(_isolate_encrypt, response.sendPort,
      onExit: response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([prvKey, psw, options, answer.sendPort]);
  //获得数据并返回
  final result = await answer.first;
  response.close();
  answer.close();
  isolate.kill();
  return result;
}

//创建isolate必须要的参数
void _isolate_encrypt(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) async {
    //获取数据并解析
    final prvKey = message[0] as String;
    final psw = message[1] as String;
    final options = message[2] as Map<String, dynamic>;
    final send = message[3] as SendPort;
    //返回结果
    var encrypted = await encrypt(prvKey, psw, options);
    send.send(encrypted);
  });
}

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncDecrypt(
  Map<String, dynamic> keyStore,
  String psw,
) async {
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  var isolate = await Isolate.spawn(_isolate_decrypt, response.sendPort,
      onExit: response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([keyStore, psw, answer.sendPort]);
  final result = await answer.first;
  //获得数据并返回
  response.close();
  answer.close();
  isolate.kill();
  return result;
}

//创建isolate必须要的参数
void _isolate_decrypt(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) async {
    //获取数据并解析
    final keyStore = message[0] as Map<String, dynamic>;
    final psw = message[1] as String;
    final send = message[2] as SendPort;
    //返回结果
    var encrypted = await decrypt(keyStore, psw);
    send.send(encrypted);
  });
}

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncGeneratePrivateKey() async {
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  var isolate = await Isolate.spawn(_isolate_genratePrvKey, response.sendPort,
      onExit: response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([answer.sendPort]);
  final result = await answer.first;
  //获得数据并返回
  response.close();
  answer.close();
  isolate.kill();
  return result;
}

//创建isolate必须要的参数
void _isolate_genratePrvKey(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    //获取数据并解析

    final send = message[0] as SendPort;
    //返回结果
    var encrypted = generatePrivateKey();
    send.send(encrypted);
  });
}

Future<dynamic> asyncSchnorrSign(
  String privateKey,
  Map<String, dynamic> txnDetails,
) async {
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  var isolate = await Isolate.spawn(_isolate_SchnorrSign, response.sendPort,
      onExit: response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([privateKey, txnDetails, answer.sendPort]);
  //获得数据并返回
  final result = answer.first;
  response.close();
  answer.close();
  isolate.kill();
  return result;
}

//创建isolate必须要的参数
void _isolate_SchnorrSign(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    //获取数据并解析
    final prv = message[0] as String;
    final txn = message[1] as Map<String, dynamic>;
    final send = message[2] as SendPort;
    //返回结果
    var signed = SchnorrSign(prv, txn);
    send.send(signed);
  });
}

Future<dynamic> asyncGetPubKeyFromPrivateKey(
  String privateKey,
) async {
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  var isolate =
      await Isolate.spawn(_isolate_getPubKeyFromPrivateKey, response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([privateKey, answer.sendPort]);
  final result = answer.first;
  response.close();
  answer.close();
  isolate.kill();
  //获得数据并返回
  return result;
}

//创建isolate必须要的参数
void _isolate_getPubKeyFromPrivateKey(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    //获取数据并解析
    final prv = message[0] as String;
    final send = message[1] as SendPort;
    //返回结果
    var signed = getPubKeyFromPrivateKey(prv);
    send.send(signed);
  });
}

Future<dynamic> asyncGetAddressFromPrivateKey(
  String privateKey,
) async {
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  var isolate =
      await Isolate.spawn(_isolate_getAddressFromPrivateKey, response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([privateKey, answer.sendPort]);
  final result = answer.first;
  response.close();
  answer.close();
  isolate.kill();
  //获得数据并返回
  return result;
}

//创建isolate必须要的参数
void _isolate_getAddressFromPrivateKey(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    //获取数据并解析
    final prv = message[0] as String;
    final send = message[1] as SendPort;
    //返回结果
    var signed = getAddressFromPrivateKey(prv);
    send.send(signed);
  });
}

Future<dynamic> asyncGetAddressFromPublicKey(
  String pubKey,
) async {
  //��先创建一个ReceivePort，为什么要创建这个？
  //因���创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  var isolate =
      await Isolate.spawn(_isolate_getAddressFromPublicKey, response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([pubKey, answer.sendPort]);
  //获得数据并返回
  final result = answer.first;
  response.close();
  answer.close();
  isolate.kill();
  //获得数据并返回
  return result;
}

//创建isolate必须要的参数
void _isolate_getAddressFromPublicKey(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    //获取数据并解析
    final pub = message[0] as String;
    final send = message[1] as SendPort;
    //返回结果
    var signed = getAddressFromPublicKey(pub);
    send.send(signed);
  });
}
