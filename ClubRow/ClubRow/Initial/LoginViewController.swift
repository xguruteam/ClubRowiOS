//
//  LoginViewController.swift
//  ClubRow
//
//  Created by Guru on 7/8/19.
//  Copyright © 2019 CREATORSNEVERDIE. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    let logoImageView: UIImageView = {
        let imageView = UIImageView(false)
        imageView.image = UIImage(named: "logo-white")
        return imageView
    }()
    
    let topPaddingView: UIView = {
        let view = UIView(false)
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView(false)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(false)
        label.attributedText = NSAttributedString(string: "LOG IN", attributes: Theme.titleTextAttributes)
        return label
    }()
    
    let userNameTextField: TextField = {
        let textField = TextField(placeholder: "Username or Email")
        return textField
    }()
    
    let passwordTextField: TextField = {
        let textField = TextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        let rightButton = UIButton(type: .system)
        rightButton.setAttributedTitle(NSAttributedString(string: "show", attributes: Theme.additionalActionTextAttributes), for: .normal)
        rightButton.addAction({ (button) in
            if textField.isSecureTextEntry {
                textField.isSecureTextEntry = false
                rightButton.setAttributedTitle(NSAttributedString(string: "hide", attributes: Theme.additionalActionTextAttributes), for: .normal)
            } else {
                textField.isSecureTextEntry = true
                rightButton.setAttributedTitle(NSAttributedString(string: "show", attributes: Theme.additionalActionTextAttributes), for: .normal)
            }
        })
        rightButton.contentHorizontalAlignment = .left
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 0)
        textField.rightView = rightButton
        return textField
    }()
    
    let forgetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont(name: .textFontName, size: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor("#0A0707", alpha: 0.55) as Any,
        ]
        button.setAttributedTitle(NSAttributedString(string: "Forgot Password?", attributes: attributes), for: .normal)
        return button
    }()
    
    let loginButton: Button = {
        let button = Button(title: "LOG IN", backgroundColor: .appPink)
        return button
    }()
    
    let bottomPaddingView: UIView = {
        let view = UIView(false)
        return view
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont(name: .textFontName, size: 16)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor("#0A0707", alpha: 0.55) as Any,
        ]
        
        button.setAttributedTitle(NSAttributedString(string: "CREATE ACCOUNT", attributes: attributes), for: .normal)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appCyan
        // Do any additional setup after loading the view.
        
        view.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        view.addSubview(topPaddingView)
        view.addSubview(containerView)
        view.addSubview(bottomPaddingView)
        view.addSubview(signupButton)

        topPaddingView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor).isActive = true
        topPaddingView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        topPaddingView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        topPaddingView.heightAnchor.constraint(equalTo: bottomPaddingView.heightAnchor).isActive = true
        
        bottomPaddingView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bottomPaddingView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        bottomPaddingView.bottomAnchor.constraint(equalTo: signupButton.topAnchor).isActive = true
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        containerView.addSubview(userNameTextField)
        userNameTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 58).isActive = true
        userNameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 42).isActive = true
        userNameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -42).isActive = true
        
        containerView.addSubview(passwordTextField)
        passwordTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 42).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -42).isActive = true
        
        containerView.addSubview(forgetButton)
        forgetButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        forgetButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16).isActive = true
        
        containerView.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: forgetButton.bottomAnchor, constant: 32).isActive = true
        loginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 42).isActive = true
        loginButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -42).isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 0).isActive = true
        
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true
        signupButton.addTarget(self, action: #selector(onCreate), for: .touchUpInside)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func onCreate() {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .loginViewControllerDidDismissToGoSignup, object: nil)
        }
    }

}
