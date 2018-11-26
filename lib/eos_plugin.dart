import 'dart:async';

import 'package:eos_plugin/EosWallet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class EosPlugin {
  /// 通道名称
  static const MethodChannel _channel = const MethodChannel('com.rapaq.eos_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 创建eos钱包
  static Future<EosWallet> createEosWallet() async {
    final Map<dynamic, dynamic> map = await _channel.invokeMethod('createEosWallet') as Map<dynamic, dynamic>;
    var eosWallet = new EosWallet();
    eosWallet.publicKey = map["public_key"];
    eosWallet.privateKey = map["private_key"];
    eosWallet.mnemonic = map["mnemonic"];
    assert(eosWallet.publicKey != null, "生成的公钥不能为null");
    assert(eosWallet.privateKey != null, "生成的私钥不能为null");
    assert(eosWallet.mnemonic != null, "生成的助记词不能为null");
    return eosWallet;
  }

  /// 助记词 推导出 私钥
  static Future<String> mnemonicToPrivateKey(String mnemonic) async {
    final String priKey = await _channel.invokeMethod('mnemonicToPrivateKey', mnemonic);
    return priKey;
  }

//  /// 助记词 推导出 公钥
//  static Future<String> mnemonicToPublicKey(String mnemonic) async {
//    final String pubKey = await _channel.invokeMethod('mnemonicToPublicKey', mnemonic);
//    return pubKey;
//  }

  /// 私钥 推导出 公钥
  static Future<String> privateKeyToPublicKey(String privateKey) async {
    final String pubKey = await _channel.invokeMethod('privateKeyToPublicKey', privateKey);
    return pubKey;
  }

  /// 转账
  static Future<bool> transfer(String code, String eosBaseUrl, String fromAccount, String fromPrivateKey, String toAccount, String quantity, String memo) async {
    var map = Map();
    map["code"] = code;
    map["eosBaseUrl"] = eosBaseUrl;
    map["fromAccount"] = fromAccount;
    map["fromPrivateKey"] = fromPrivateKey;
    map["toAccount"] = toAccount;
    map["quantity"] = quantity;
    map["memo"] = memo;
    final String result = await _channel.invokeMethod("transfer", map) as String;
    return result == "success";
  }
}
