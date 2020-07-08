//
//  SignUpView.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-06-22.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    
//    MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel.textLabel(titleLabel: "Benefitter", ofFontSize: 46)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView.inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x").withTintColor(.black), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = UIView.inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x").withTintColor(.black), textField: fullnameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView.inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x").withTintColor(.black), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField.textField(withPlaceHolder: "Email",
                                              isSecureTextEntry: false)
        return textField
    }()
    
    let fullnameTextField: UITextField = {
        let textField = UITextField.textField(withPlaceHolder: "Fullname",
                                              isSecureTextEntry: false)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField.textField(withPlaceHolder: "Password",
                                                isSecureTextEntry: true)
        return textField
    }()
    
    lazy var signUpButton: ConfirmButton = {
        let button = ConfirmButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black])
        
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.systemBlue]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
    }()
    
    weak var delegate: SignUpDelegate?
    
//    MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers functions
    func configureUI() {
        backgroundColor = .backgroundYellow
        
        addSubview(titleLabel)
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        titleLabel.centerX(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullnameContainerView, passwordContainerView])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        addSubviews(stack, signUpButton, alreadyHaveAnAccountButton)
        
        stack.anchor(top: titleLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        signUpButton.centerX(inView: self)
        signUpButton.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 25, paddingLeft: 16, paddingRight: 16)
        
        alreadyHaveAnAccountButton.centerX(inView: self)
        alreadyHaveAnAccountButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
//    MARK: Handlers
    
    @objc func handleSignUp() {

        delegate?.handleSignUpPressed(signUpButton, fullnameTextField, emailTextField, passwordTextField)
    }
    
    @objc func handleShowLogin() {
        delegate?.alreadyHaveAnAccountButton(alreadyHaveAnAccountButton)
    }
        
}

