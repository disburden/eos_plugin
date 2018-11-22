import 'dart:convert' show json;

/// eos 钱包
class EosWallet {
  /// 账号
  String account;

  /// 公钥
  String publicKey;

  /// 私钥
  String privateKey;

  /// 助记词
  String mnemonic;

  /// 助记次提示，协助记忆助记词
  String mnemonicHit;

  EosWallet();

  EosWallet.fromJson(jsonRes) {
    account = jsonRes['account'];
    mnemonic = jsonRes['mnemonic'];
    mnemonicHit = jsonRes['mnemonicHit'];
    privateKey = jsonRes['privateKey'];
    publicKey = jsonRes['publicKey'];
  }

  @override
  String toString() {
    return '{"account": ${account != null ? '${json.encode(account)}' : 'null'},"mnemonic": ${mnemonic != null ? '${json.encode(mnemonic)}' : 'null'},"mnemonicHit": ${mnemonicHit != null ? '${json.encode(mnemonicHit)}' : 'null'},"privateKey": ${privateKey != null ? '${json.encode(privateKey)}' : 'null'},"publicKey": ${publicKey != null ? '${json.encode(publicKey)}' : 'null'}}';
  }
}
