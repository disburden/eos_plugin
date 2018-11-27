package name.wgq.eosplugin;

import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

import com.develop.mnemonic.KeyPairUtils
import com.develop.mnemonic.MnemonicUtils
import com.develop.wallet.WalletManager
import com.develop.wallet.eos.utils.EccTool
import java.util.HashMap
import com.develop.wallet.BuildConfig
import com.develop.wallet.eos.utils.EException

class EosPlugin() : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "com.rapaq.eos_plugin")
            channel.setMethodCallHandler(EosPlugin())
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        if (call.method == "createEosWallet") {
            val map = createEosWallet()
            result.success(map)
        } else if (call.method == "mnemonicToPrivateKey") {
            val priKey = mnemonicToPrivateKey(call.arguments as String)
            result.success(priKey)
        } else if (call.method == "mnemonicToPublicKey") {
            val pubKey = mnemonicToPublicKey(call.arguments as String)
            result.success(pubKey)
        } else if (call.method == "privateKeyToPublicKey") {
            val pubKey = privateKeyToPublicKey(call.arguments as String)
            result.success(pubKey)
        } else if (call.method == "transfer") {
            val map = call.arguments as HashMap<String, String>
            transfer(map["code"]!!, map["eosBaseUrl"]!!, map["fromAccount"]!!, map["fromPrivateKey"]!!, map["toAccount"]!!, map["quantity"]!!, map["memo"] ?: "", result)
        } else {
            result.notImplemented()
        }
    }

    private fun createEosWallet(): HashMap<String, String> {
        // 生成助记词
        val mnemonic = MnemonicUtils.generateMnemonic()
        // 生成种子
        val seed = MnemonicUtils.generateSeed(mnemonic, "")
        // bip44 bip32 私钥
        val privateKeyBytes = KeyPairUtils.generatePrivateKey(seed, KeyPairUtils.CoinTypes.EOS)
        // 生成EOS私钥
        val pk = EccTool.privateKeyFromSeed(privateKeyBytes)
        // 生成EOS公钥
        val pu = EccTool.privateToPublic(pk)

        val map = HashMap<String, String>()
        map["mnemonic"] = mnemonic
        map["private_key"] = pk
        map["public_key"] = pu
        return map
    }

    private fun mnemonicToPrivateKey(mnemonic: String): String {
        // 生成种子
        val seed = MnemonicUtils.generateSeed(mnemonic, "")
        // bip44 bip32 私钥
        val privateKeyBytes = KeyPairUtils.generatePrivateKey(seed, KeyPairUtils.CoinTypes.EOS)
        // 生成EOS私钥
        val pk = EccTool.privateKeyFromSeed(privateKeyBytes)
        return pk
    }

    private fun mnemonicToPublicKey(mnemonic: String): String {
        // 生成种子
        val seed = MnemonicUtils.generateSeed(mnemonic, "")
        // bip44 bip32 私钥
        val privateKeyBytes = KeyPairUtils.generatePrivateKey(seed, KeyPairUtils.CoinTypes.EOS)
        // 生成EOS私钥
        val pk = EccTool.privateKeyFromSeed(privateKeyBytes)
        // 生成EOS公钥
        val pu = EccTool.privateToPublic(pk)
        return pu
    }

    private fun privateKeyToPublicKey(privateKey: String): String {
        // 生成EOS公钥
        val pu = EccTool.privateToPublic(privateKey)
        return pu
    }

    // 转账
    private fun transfer(code: String, eosBaseUrl: String, fromAccount: String, fromPrivateKey: String, toAccount: String, quantity: String, memo: String, result: Result) {
        BuildConfig.EOS_CREATOR_ACCOUNT = code
        BuildConfig.EOS_URL = eosBaseUrl
        Thread {
            try {
                WalletManager.transfer(fromAccount, fromPrivateKey, toAccount, quantity, memo)
                result.success("success")
            } catch (e: Exception) {
                Log.d("hbl", "失败原因：$e")
                if(e is EException){
                    Log.d("hbl", "失败原因：${e.code}  -- ${e.msg}")
                }
                result.success("failed")
            }
        }.start()
    }

}
