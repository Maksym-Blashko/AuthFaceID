//
//  AuthController.swift
//  AuthFaceID
//
//  Created by Blashko Maksim on 12.08.2021.
//

//import Foundation
import LocalAuthentication

class AuthController {
    
    var login: String
    var password: String
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
    
    func identifyYourself(completion: @escaping (Bool)->()) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Please authenticate to proceed"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                
                if success {
                    DispatchQueue.main.async { [unowned self] in
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
            print("Face/Touch ID не найден")
            completion(false)
        }
    }

}
