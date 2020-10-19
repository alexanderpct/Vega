//
//  LoginViewController.swift
//  Vega
//
//  Created by Alexander on 30.10.2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

enum Login {
    case student
    case teacher
    case denied
}

class LoginViewController: UIViewController {
    
    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Логин"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.bounds.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.bounds.height))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let logInButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .init(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
        logInButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
    }
    
    @objc private func handleLogIn() {
        
        let loginInfo = checkAuthorization(login: loginTextField.text!, password: passwordTextField.text!)
        
        switch loginInfo {
        case .student, .teacher:
            let controller = MainTabBarController()
            controller.login = loginInfo
            navigationController?.pushViewController(controller, animated: true)
        case .denied:
            passwordTextField.shake()
        }
        
    }
    
    private func setupUI() {
        view.addSubview(loginTextField)
        loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -96).isActive = true
        loginTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        loginTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 64).isActive = true
        
        view.addSubview(passwordTextField)
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -32).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: view.bounds.width - 64).isActive = true
        
        view.addSubview(logInButton)
        logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 64).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        logInButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 64).isActive = true
    }
    
    private func checkAuthorization(login: String, password: String) -> Login {
        if login == "0" {
            return .student
        } else if login == "1" {
            return .teacher
        }
        return .denied
    }
    
}




