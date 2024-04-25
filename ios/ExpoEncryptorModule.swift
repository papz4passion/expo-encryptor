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
      Function("encryptWithSymmKey") { (key: String?, message: String) in
        do {
            let result = try CoreCryptor.encryptText(symmetricKeyString: key, plaintext: message)
            return result
        } catch {
            return ["error":error.localizedDescription]
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
