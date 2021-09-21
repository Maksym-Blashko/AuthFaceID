//
//  AuthController.swift
//  AuthFaceID
//
//  Created by Blashko Maksim on 12.08.2021.
//

//import Foundation
import LocalAuthentication

enum CashKey: String {
    case currentUser
}

class AuthController {
    
    private let userDefaults = UserDefaults.standard
        
    // MARK: TouchID & FaceID
    /// Checks the device's ability to authenticate with a FaceID or TouchID and logs into the app using biometric data
    func identifyYourself(completion: @escaping (Bool)->()) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Please authenticate to proceed"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                
                if success {
                    DispatchQueue.main.async { //[unowned self] in
                        print("Success")
                        completion(true)
                    }
                } else {
                    guard let error = error else { return }
                    print(error.localizedDescription)
                    completion(false)
                }
            }
            
        } else {
            print("Face/Touch ID not found")
            completion(false)
        }
    }
    
    
    // MARK: Keychain service
    /// Stores credentials in a keychain and logs into the app
    func saveAndLogin(user: User, completion: @escaping (Bool)->()) {
        let apiManager = ApiManager()
        apiManager.tryToLogIn(user: user) { [weak self] (result) in
            if result {
                self?.saveUserData(user: user)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func saveUserData(user: User) {
        let keychainService = KeychainService()
        keychainService.save(user.password, for: user.username)
        setCurrentUser(account: user.username, key: .currentUser)
    }
    
    
    // MARK: User defaults
    /// Returns the username "String" from user defaults
    func getCurrentUser(key: CashKey) -> String {
        return userDefaults.string(forKey: key.rawValue) ?? ""
    }

    /// Remembers the current user
    func setCurrentUser(account: String, key: CashKey) {
        userDefaults.setValue(account, forKey: key.rawValue)
    }
}
