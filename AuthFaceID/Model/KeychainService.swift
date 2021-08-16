//
//  KeychainService.swift
//  AuthFaceID
//
//  Created by Blashko Maksim on 12.08.2021.
//

import Foundation
import Security

class KeychainService {
    
    static let shared = KeychainService()
    private init() {}
    
    func save(_ password: String, for account: String) {
        let password = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: password]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("save error") } // after reinstallation there is already such a name
    }
    
    func retrievePassword(for account: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue ?? ""]
        
        var retrievedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrievedData)
        
        guard let data = retrievedData as? Data else { return nil }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func update(_ password: String, for account: String) {
        let password = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecAttrAccount as String: account,
                                    kSecValueData as String: password]
        
        let status = SecItemUpdate(query as CFDictionary, query as CFDictionary)
        guard status != errSecItemNotFound else { return print("update error: no password") }
        guard status == errSecSuccess else { return print("update error") }
    }

    func delete(_ password: String, for account: String) {
        let password = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecAttrAccount as String: account,
                                    kSecValueData as String: password]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { return print("delete error") }
    }

}
