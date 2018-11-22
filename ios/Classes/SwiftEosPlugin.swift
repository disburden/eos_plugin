import Flutter
import UIKit

public class SwiftEosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "eos_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftEosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let (pk, pub) = generateRandomKeyPair(enclave: .Secp256k1)
    //result("iOS " + UIDevice.current.systemVersion)
    result("iOS " + pub!.rawPublicKey())

  }
}
