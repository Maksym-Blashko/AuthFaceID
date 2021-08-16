//
//  PasscodeViewController.swift
//  AuthFaceID
//
//  Created by Blashko Maksim on 12.08.2021.
//

import UIKit

class PasscodeViewController: UIViewController {

    private let authController = AuthController.shared
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userIsAlreadyLoggedIn()
    }

    @IBAction func didPressLoginButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        // show alert if needed
        if loginTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Error", message: "Please enter your login details", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return
        }
        
        // save and login
        guard let login = loginTextField.text, let pass = passwordTextField.text else { return }
        let user = User(username: login, password: pass)
        
        authController.saveAndLogin(user: user) { [weak self] success in
            if success { self?.dismiss(animated: true, completion: nil) }
        }
    }
    
    private func userIsAlreadyLoggedIn() {
        let currentUser = authController.getCurrentUser(key: .currentUser)
        if !currentUser.isEmpty {
            self.loginTextField.text = currentUser
            authController.identifyYourself { [weak self] success in
                if success { self?.dismiss(animated: true, completion: nil) }
            }
        }
    }
    
}
