import ExpoModulesCore
import CryptoKit

public class ExpoEncryptorModule: Module {
    // Each module class must implement the definition function. The definition consists of components
    // that describes the module's functionality and behavior.
    // See https://docs.expo.dev/modules/module-api for more details about available components.
    public func definition() -> ModuleDefinition {
        // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
        // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
        // The module will be accessible from `requireNativeModule('ExpoEncryptor')` in JavaScript.
        Name("ExpoEncryptor")
        
        // Defines a JavaScript synchronous function that runs the native code on the JavaScript thread.
        AsyncFunction("encryptWithSymmKey") { (key: String?, message: String, promise: Promise) in
            do {
                let result = try CoreCryptor.encryptText(symmetricKeyString: key, plaintext: message)
                promise.resolve(result)
            } catch {
                promise.reject(error)
            }
        }
        
        AsyncFunction("decryptWithSymmKey") { (encryptedText: String, nonceHexString: String, symmetricKeyString: String, tag: String, promise: Promise) in
            do {
                let result = try CoreCryptor.decryptText(encryptedText: encryptedText, nonceHexString: nonceHexString, symmetricKeyString: symmetricKeyString, tag: tag)
                promise.resolve(result)
            } catch {
                promise.reject(error)
            }
        }
        
        AsyncFunction("encryptWithPublicKey") { (key: String, message: String, promise: Promise) in
            do {
                let result = try CoreCryptor.encryptWithPublicKey(plainText: message, publicKeyString: key)
                promise.resolve(result)
            } catch {
                promise.reject(error)
            }
        }
        
        // Enables the module to be used as a native view. Definition components that are accepted as part of the
        // view definition: Prop, Events.
        View(ExpoEncryptorView.self) {
            // Defines a setter for the `name` prop.
            Prop("name") { (view: ExpoEncryptorView, prop: String) in
                print(prop)
            }
        }
    }
}
