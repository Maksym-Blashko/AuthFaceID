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
    
    static let shared = AuthController()
    private let keychainService = KeychainService.shared
    private let apiManager = ApiManager.shared
    private let userDefaults = UserDefaults.standard
    
    private init() {}
        
    // MARK: TouchID & FaceID
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
    func saveAndLogin(user: User, completion: @escaping (Bool)->()) {
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
        keychainService.save(user.password, for: user.username)
        setCurrentUser(account: user.username, key: .currentUser)
    }
    
    
    // MARK: User defaults
    func getCurrentUser(key: CashKey) -> String {
        return userDefaults.string(forKey: key.rawValue) ?? ""
    }

    func setCurrentUser(account: String, key: CashKey) {
        userDefaults.setValue(account, forKey: key.rawValue)
    }
}
