import 'dart:isolate';

import 'package:laksadart/src/crypto/keystore/api.dart';

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncEncrypt(String prvKey, String psw,
    [Map<String, dynamic> options]) async {
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  await Isolate.spawn(_isolate_encrypt, response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([prvKey, psw, options, answer.sendPort]);
  //获得数据并返回
  return answer.first;
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
  await Isolate.spawn(_isolate_decrypt, response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([keyStore, psw, answer.sendPort]);
  //获得数据并返回
  return answer.first;
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
