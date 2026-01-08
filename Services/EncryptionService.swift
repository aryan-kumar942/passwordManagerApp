//
//  EncryptionService.swift
//  PasswordManagerApp
//
//  Created by Aryan kumar giri on 08/01/26.
//

import Foundation
import CryptoKit
import Security

class EncryptionService {
    static let shared = EncryptionService()
    
    private init() {}
    
    // Generate a symmetric key from keychain or create new one
    private func getOrCreateKey() throws -> SymmetricKey {
        let tag = "com.passwordmanager.encryptionkey"
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            if let keyData = item as? Data {
                return SymmetricKey(data: keyData)
            }
        }
        
        // Create new key if not found
        let newKey = SymmetricKey(size: .bits256)
        let keyData = newKey.withUnsafeBytes { Data($0) }
        
        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecValueData as String: keyData
        ]
        
        let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
        guard addStatus == errSecSuccess else {
            throw EncryptionError.keyGenerationFailed
        }
        
        return newKey
    }
    
    // Encrypt password
    func encrypt(password: String) throws -> Data {
        let key = try getOrCreateKey()
        let passwordData = Data(password.utf8)
        
        let sealedBox = try AES.GCM.seal(passwordData, using: key)
        guard let combined = sealedBox.combined else {
            throw EncryptionError.encryptionFailed
        }
        
        return combined
    }
    
    // Decrypt password
    func decrypt(data: Data) throws -> String {
        let key = try getOrCreateKey()
        
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        
        guard let password = String(data: decryptedData, encoding: .utf8) else {
            throw EncryptionError.decryptionFailed
        }
        
        return password
    }
}

enum EncryptionError: Error {
    case keyGenerationFailed
    case encryptionFailed
    case decryptionFailed
    
    var localizedDescription: String {
        switch self {
        case .keyGenerationFailed:
            return "Failed to generate encryption key"
        case .encryptionFailed:
            return "Failed to encrypt password"
        case .decryptionFailed:
            return "Failed to decrypt password"
        }
    }
}

