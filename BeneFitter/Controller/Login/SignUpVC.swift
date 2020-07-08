//
//  SignUpVC.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-06-23.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpVC: UIViewController {
    
//    MARK: - Properties
    lazy var signUpView = SignUpView()
    lazy var service = UserService.shared

//    MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerView()
        
        setDelegates()
    }
    
    func registerView() {
        view = signUpView
    }
    
    func setDelegates() {
        signUpView.delegate = self
        signUpView.emailTextField.delegate = self
        signUpView.fullnameTextField.delegate = self
        signUpView.passwordTextField.delegate = self
    }
    
    deinit {
        print("DEBUG removing")
    }
    

}


extension SignUpVC: SignUpDelegate {
    func handleSignUpPressed(_ signUpButton: UIButton, _ fullnameTextField: UITextField, _ emailTextField: UITextField, _ passwordTextField: UITextField) {
        
        signUpButton.isEnabled = false
        let group = DispatchGroup()
        group.enter()
        
        guard
            let email = emailTextField.text,
            let fullname = fullnameTextField.text,
            let password = passwordTextField.text
            
        else {
            SVProgressHUD.showError(withStatus: NetworkError.invalidUserInfo.errorDescription)
            return }
        
        service.signUpUserWithEmail(email, password) { (result) in
            
            switch result {
            case .success(_):
                group.leave()
                
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                signUpButton.isEnabled = true
            }
        }
        
        group.notify(queue: .main) {
            
            self.service.uploadUserInfo(fullname: fullname) { (result) in
                
                switch result {
                case .success(_):
                    self.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    signUpButton.isEnabled = true
                }
            }
        }
        
        
    }
    
    func alreadyHaveAnAccountButton(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
