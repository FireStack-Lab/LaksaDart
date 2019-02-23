import 'dart:isolate';
import 'dart:async';
import 'schnorr.dart';
import 'keystore/api.dart';

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncEncrypt(String prvKey, String psw,
    [Map<String, dynamic> options]) async {
  final response = new ReceivePort();

  await Isolate.spawn(
    _isolate_encrypt,
    response.sendPort,
    onExit: response.sendPort,
  );

  final sendPort = await response.first as SendPort;
  final receivePort = new ReceivePort();
  //发送数据
  sendPort.send([prvKey, psw, options, receivePort.sendPort]);

  try {
    final result = await receivePort.first;
    var resultString = result.toString();

    if (resultString.startsWith('@@LaksaError@@')) {
      throw resultString.substring(14);
    }
    response.close();
    return result;
  } catch (e) {
    throw e;
  }
}

//创建isolate必须要的参数
void _isolate_encrypt(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) async {
    try {
      final prvKey = message[0] as String;
      final psw = message[1] as String;
      final options = message[2] as Map<String, dynamic>;
      final send = message.last as SendPort;
      var encrypted;
      encrypted = await encrypt(prvKey, psw, options);
      //返回结果
      send.send(encrypted);
    } catch (e) {
      message.last.send('@@LaksaError@@$e');
    }
  });
}

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncDecrypt(
  Map<String, dynamic> keyStore,
  String psw,
) async {
  // standard procedure
  final response = new ReceivePort();

  await Isolate.spawn(
    _isolate_decrypt,
    response.sendPort,
    onExit: response.sendPort,
    onError: response.sendPort,
  );

  // setup sendport and receiveport;

  final sendPort = await response.first as SendPort;
  final receivePort = new ReceivePort();

  sendPort.send([keyStore, psw, receivePort.sendPort]);

  try {
    final result = await receivePort.first;
    var resultString = result.toString();

    if (resultString.startsWith('@@LaksaError@@')) {
      throw resultString.substring(14);
    }
    response.close();
    return result;
  } catch (e) {
    throw e;
  }
}

//创建isolate必须要的参数
void _isolate_decrypt(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听

  port.listen((message) async {
    try {
      final send = message.last as SendPort;
      final keyStore = message[0] as Map<String, dynamic>;
      final psw = message[1] as String;
      //返回结果
      var decrypted = await decrypt(keyStore, psw);
      send.send(decrypted);
    } catch (e) {
      message.last.send('@@LaksaError@@$e');
    }
  });
}

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncGeneratePrivateKey() async {
  final response = new ReceivePort();

  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  await Isolate.spawn(_isolate_genratePrvKey, response.sendPort,
      onExit: response.sendPort);

  // setup error listener
  // should place before normal result

  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final receivePort = new ReceivePort();
  //发送数据

  sendPort.send([receivePort.sendPort]);

  try {
    final result = await receivePort.first;
    var resultString = result.toString();

    if (resultString.startsWith('@@LaksaError@@')) {
      throw resultString.substring(14);
    }
    response.close();
    return result;
  } catch (e) {
    throw e;
  }
}

//创建isolate必须要的参数
void _isolate_genratePrvKey(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    //获取数据并解析
    try {
      final send = message.last as SendPort;
      //返回结果
      send.send(generatePrivateKey());
    } catch (e) {
      message.last.send('@@LaksaError@@$e');
    }
  });
}

Future<dynamic> asyncSchnorrSign(
  String privateKey,
  Map<String, dynamic> txnDetails,
) async {
  final response = new ReceivePort();

  await Isolate.spawn(
    _isolate_SchnorrSign,
    response.sendPort,
    onExit: response.sendPort,
  );
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final receivePort = new ReceivePort();
  //发送数据
  sendPort.send([privateKey, txnDetails, receivePort.sendPort]);

  try {
    final result = await receivePort.first;
    var resultString = result.toString();

    if (resultString.startsWith('@@LaksaError@@')) {
      throw resultString.substring(14);
    }
    response.close();
    return result;
  } catch (e) {
    throw e;
  }
}

//创建isolate必须要的参数
void _isolate_SchnorrSign(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    //获取数据并解析
    try {
      final prv = message[0] as String;
      final txn = message[1] as Map<String, dynamic>;
      final send = message.last as SendPort;
      //返回结果
      send.send(SchnorrSign(prv, txn));
    } catch (e) {
      message.last.send('@@LaksaError@@$e');
    }
  });
}

Future<dynamic> asyncGetPubKeyFromPrivateKey(
  String privateKey,
) async {
  final response = new ReceivePort();

  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。

  await Isolate.spawn(
    _isolate_getPubKeyFromPrivateKey,
    response.sendPort,
  );
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final receivePort = new ReceivePort();
  //发送数据
  sendPort.send([privateKey, receivePort.sendPort]);

  try {
    final result = await receivePort.first;
    var resultString = result.toString();

    if (resultString.startsWith('@@LaksaError@@')) {
      throw resultString.substring(14);
    }
    response.close();
    return result;
  } catch (e) {
    throw e;
  }
}

//创建isolate必须要的参数
void _isolate_getPubKeyFromPrivateKey(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    try {
      final prv = message[0] as String;
      final send = message.last as SendPort;
      //返回结果
      send.send(getPubKeyFromPrivateKey(prv));
    } catch (e) {
      message.last.send('@@LaksaError@@$e');
    }
    //获取数据并解析
  });
}

Future<dynamic> asyncGetAddressFromPrivateKey(
  String privateKey,
) async {
  final response = new ReceivePort();

  await Isolate.spawn(
    _isolate_getAddressFromPrivateKey,
    response.sendPort,
  );

  final sendPort = await response.first as SendPort;

  final receivePort = new ReceivePort();

  sendPort.send([privateKey, receivePort.sendPort]);

  try {
    final result = await receivePort.first;
    var resultString = result.toString();

    if (resultString.startsWith('@@LaksaError@@')) {
      throw resultString.substring(14);
    }
    response.close();
    return result;
  } catch (e) {
    throw e;
  }
}

void _isolate_getAddressFromPrivateKey(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    try {
      final prv = message[0] as String;
      final send = message.last as SendPort;
      //返回结果
      send.send(getAddressFromPrivateKey(prv));
    } catch (e) {
      message.last.send('@@LaksaError@@$e');
    }
  });
}

Future<dynamic> asyncGetAddressFromPublicKey(
  String pubKey,
) async {
  final response = new ReceivePort();

  await Isolate.spawn(
    _isolate_getAddressFromPublicKey,
    response.sendPort,
  );

  final sendPort = await response.first as SendPort;

  final receivePort = new ReceivePort();

  sendPort.send([pubKey, receivePort.sendPort]);

  try {
    final result = await receivePort.first;
    var resultString = result.toString();

    if (resultString.startsWith('@@LaksaError@@')) {
      throw resultString.substring(14);
    }
    response.close();
    return result;
  } catch (e) {
    throw e;
  }
}

//创建isolate必须要的参数
void _isolate_getAddressFromPublicKey(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    //获取数据并解析
    try {
      final pub = message[0] as String;
      final send = message.last as SendPort;
      //返回结果
      var signed = getAddressFromPublicKey(pub);
      send.send(signed);
    } catch (e) {
      message.last.send('@@LaksaError@@$e');
    }
  });
}

class IsolateFunction {
  List<dynamic> params;
  Function func;

  final response = new ReceivePort();
  final receivePort = new ReceivePort();
  Isolate _isolate_instance;

  IsolateFunction({this.params, this.func});

  run() async {
    _isolate_instance = await Isolate.spawn(
        _isolate_function, response.sendPort,
        onExit: response.sendPort);
    final sendPort = await response.first as SendPort;

    sendPort.send([
      this.func,
      receivePort.sendPort,
      this.params.iterator,
    ]);
    try {
      final result = await receivePort.first;
      var resultString = result.toString();

      if (resultString.startsWith('@@LaksaError@@')) {
        throw resultString.substring(14);
      }
      // response.close();
      kill();
      return result;
    } catch (e) {
      throw e;
    }
  }

  void kill() {
    if (_isolate_instance != null) {
      _isolate_instance.kill();
      response.close();
      receivePort.close();
    }
  }
}

void _isolate_function(SendPort initialReplyTo) {
  final port = new ReceivePort();

  initialReplyTo.send(port.sendPort);

  port.listen((message) async {
    final func = message[0];
    final send = message[1] as SendPort;
    try {
      final sendParams = message.removeRange(0, 2);
      //返回结果
      var result = await func(sendParams);
      send.send(result);
    } catch (e) {
      send.send('@@LaksaError@@$e');
    }
  });
}
