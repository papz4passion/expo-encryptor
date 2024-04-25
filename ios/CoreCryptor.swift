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
    
    // Function that encrypts text and can throw errors
    class func encryptText(symmetricKeyString: String?, plaintext: String) throws -> [String: String] {
        // Function to convert Data to hexadecimal string
        func hexString(from data: Data) -> String {
            return data.map { String(format: "%02hhx", $0) }.joined()
        }
        
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
        let nonceString = hexString(from: Data(nonce))
        let encryptedTextString = encrypted.combined?.base64EncodedString() ?? ""
        
        return ["key": keyString, "nonce": nonceString, "encryptedText": encryptedTextString]
    }
}
