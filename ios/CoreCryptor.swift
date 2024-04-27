//
//  CoreCryptor.swift
//  ExpoEncryptor
//
//  Created by Palaneappan Rajalingam on 25/04/24.
//

import Foundation
import CryptoKit

class CoreCryptor: NSObject {
    
    // Define the error types
    enum EncryptionError: Error {
        case invalidInput
        case encryptionFailed
    }
    
    // Define the error types
    enum DecryptionError: Error {
        case inputDataError
        case decryptionFailed
    }
    
    // Function that encrypts text and can throw errors
    class func encryptText(symmetricKeyString: String?, plaintext: String) throws -> [String: String] {
        
        // Generate or use the provided AES key
        let symmetricKey: SymmetricKey
        if let keyString = symmetricKeyString, let keyData = Data(base64Encoded: keyString) {
            symmetricKey = SymmetricKey(data: keyData)
        } else {
            symmetricKey = SymmetricKey(size: .bits256)
        }
        
        // Convert plaintext to Data
        guard let plaintextData = plaintext.data(using: .utf8) else {
            throw EncryptionError.invalidInput
        }
        
        // Create a new nonce for AES encryption
        let nonce = AES.GCM.Nonce()
        guard let encrypted = try? AES.GCM.seal(plaintextData, using: symmetricKey, nonce: nonce) else {
            throw EncryptionError.encryptionFailed
        }
        
        // Convert the key, nonce, and encrypted text to Base64 strings to return
        let keyString = symmetricKey.withUnsafeBytes {
            Data(Array($0)).base64EncodedString()
        }
        let tag = encrypted.tag.base64EncodedString()
        let nonceString = Data(nonce).base64EncodedString()
        let encryptedTextString = encrypted.ciphertext.base64EncodedString()
        
        return ["key": keyString, "tag": tag, "nonce": nonceString, "encryptedText": encryptedTextString]
    }
    
    // Function that decrypts text
    class func decryptText(encryptedText: String, nonceBase64String: String, symmetricKeyString: String, tag: String) throws -> String {
        // Convert nonce and encrypted text from hex/base64 strings to Data
        guard let nonceData = Data(base64Encoded: nonceBase64String),
              let tag = Data(base64Encoded: tag),
              let nonce = try? AES.GCM.Nonce(data: nonceData),
              let encryptedData = Data(base64Encoded: encryptedText),
              let keyData = Data(base64Encoded: symmetricKeyString),
              let sealedBox = try? AES.GCM.SealedBox(nonce: nonce, ciphertext: encryptedData, tag: tag) else {
            throw DecryptionError.inputDataError
        }
        
        // Generate the symmetric key from the provided string
        let symmetricKey = SymmetricKey(data: keyData)
        
        // Perform decryption
        guard let decryptedData = try? AES.GCM.open(sealedBox, using: symmetricKey),
              let decryptedText = String(data: decryptedData, encoding: .utf8) else {
            throw DecryptionError.decryptionFailed
        }
        return decryptedText
    }
    
    class func encryptWithPublicKey(plainText: String, publicKeyString: String) throws -> String {

        guard let publicKey = publicKeyFromString(base64String: publicKeyString) else {
            throw EncryptionError.invalidInput
        }
        
        guard let data = plainText.data(using: .utf8) else {
            throw EncryptionError.invalidInput
        }
        
        let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA256
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            throw EncryptionError.invalidInput
        }
        
        var error: Unmanaged<CFError>?
        guard let encrypted = SecKeyCreateEncryptedData(publicKey,
                                                         algorithm,
                                                         data as CFData,
                                                         &error) as? Data else {
            throw EncryptionError.encryptionFailed
        }
        
        return encrypted.base64EncodedString()
    }
    
    private class func publicKeyFromString(base64String: String) -> SecKey? {
        guard let data = Data(base64Encoded: base64String) else {
            print("Error: Can't create data from Base64 string")
            return nil
        }
        
        let keyDict: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: NSNumber(value: 2048),
            kSecReturnPersistentRef: true as CFBoolean
        ]
        
        guard let key = SecKeyCreateWithData(data as CFData, keyDict as CFDictionary, nil) else {
            print("Error: Can't create key from data")
            return nil
        }
        return key
    }
}

// Extension to convert hex string to Data
extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            if let b = UInt8(hexString[j..<k], radix: 16) {
                data.append(b)
            } else {
                return nil
            }
        }
        self = data
    }
    
    func toHexString() -> String {
        return self.map { String(format: "%02hhx", $0) }.joined()
    }
}
