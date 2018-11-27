import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:eos_plugin/eos_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  String dd = '''
  ♏️必抢！iPhone
☻——————————☻

👉苹果数据线充电线1m 
👉劵后【1.9元】包邮秒杀 
👉3C认证，无损急速
👉2A快速充电，七重保护
👉智能兼容，双口输出，
👉体积小巧，携带方便！''';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var eosWallet = await EosPlugin.createEosWallet();
      print("获取到的eos钱包账号是：$eosWallet");
      var pk = await EosPlugin.mnemonicToPrivateKey(eosWallet.mnemonic);
      //var pu = await EosPlugin.mnemonicToPublicKey(eosWallet.mnemonic);
      var pu2 = await EosPlugin.privateKeyToPublicKey(pk);
      platformVersion = eosWallet.toString();
      print("获取到的eos钱包账号是pk：$pk");
      //print("获取到的eos钱包账号是pu：$pu");
      print("获取到的eos钱包账号是pu2：$pu2");
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    var quantity = (2.0.toString().split(".")[0] + "." + (2.0.toString().split(".")[1] + "0000").substring(0, 4)) + " EOS";
    print("quantity -----=  ：$quantity");
    await EosPlugin.transfer("eosio.token", "http://dev.cryptolions.io:38888", "vo2ye2oxs2qp", "5HvhDiNmFE8wMnBXbkuCZtiEVfbqRFePf51TzAf8XvX5XZomq4e", "wumingdengng", quantity, "33");


    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
