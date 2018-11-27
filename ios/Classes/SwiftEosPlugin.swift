import Flutter
import UIKit

public class SwiftEosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.rapaq.eos_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftEosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    let (pk, pub) = generateRandomKeyPair(enclave: .Secp256k1)
    //result("iOS " + UIDevice.current.systemVersion)
//    result("iOS " + pub!.rawPublicKey())

    switch (call.method) {
    case "createEosWallet":
        do {
            let (pk, pub, mn) = generateRandomKeyPair(enclave: .Secp256k1);
            print("mn \(mn!)")
            let map = [
                "public_key":pub!.rawPublicKey(),
                "private_key":pk!.rawPrivateKey(),
                "mnemonic":mn!,
                ]
            result(map);
        }
        
    case "mnemonicToPrivateKey":
        do {
            
            let pk = try! PrivateKey(enclave: .Secp256k1, mnemonicString: call.arguments as! String)
//            let (pk, mn) = try! PrivateKey(enclave: SecureEnclave.Secp256k1, mnemonicString: "your words here")
            print("mnemonicToPrivateKey \(pk!.rawPrivateKey())");
            result(pk!.rawPrivateKey());
        }
        
    case "privateKeyToPublicKey":
        do {
            
            let importedPk = try! PrivateKey(keyString: call.arguments as! String)
            let importedPub = PublicKey(privateKey: importedPk!)
            result(importedPub.rawPublicKey());
        }
        
    case "transfer":
        do {
            let map  = call.arguments as! Dictionary<String,String>;
            let code = map["code"]!;
            let eosBaseUrl = map["eosBaseUrl"]!;
            let fromAccount = map["fromAccount"]!;
            let fromPrivateKey = map["fromPrivateKey"]!;
            let toAccount = map["toAccount"]!;
            let quantity = map["quantity"]!;
            let memo = map["memo"]!;
            
            var transfer = Transfer()
            transfer.from = fromAccount
            transfer.to = toAccount
            transfer.quantity = quantity
            transfer.memo = memo
            
            EOSRPC.endpoint = eosBaseUrl;
            let pk = try! PrivateKey(keyString: fromPrivateKey);
            Currency.transferCurrency(transfer: transfer, code: code, privateKey: pk!, completion: { (rs, error) in
                if error != nil {
                    if error is RPCErrorResponse {
                        print("\((error as! RPCErrorResponse).errorDescription())")
                    } else {
                        print("other error: \(String(describing: error?.localizedDescription))")
                    }
                    result("failed");
                } else {
                    print("done.")
                    result("success");
                }
            })
        }
        
    default:
        do {
        //
        }
    }

  }
}
