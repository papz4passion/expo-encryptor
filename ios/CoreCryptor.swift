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
        let tag = encrypted.tag.toHexString()
        let nonceString = Data(nonce).toHexString()
        let encryptedTextString = encrypted.ciphertext.base64EncodedString()
        
        return ["key": keyString, "tag": tag, "nonce": nonceString, "encryptedText": encryptedTextString]
    }
    
    // Function that decrypts text
    class func decryptText(encryptedText: String, nonceHexString: String, symmetricKeyString: String, tag: String) throws -> String {
        // Convert nonce and encrypted text from hex/base64 strings to Data
        guard let nonceData = Data(hexString: nonceHexString),
              let tag = Data(hexString: tag),
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
