//
//  SignupViewController.swift
//  ClubRow
//
//  Created by Guru on 7/16/19.
//  Copyright © 2019 CREATORSNEVERDIE. All rights reserved.
//

import UIKit
import SDWebImage

class SignupViewController: BaseViewController {

    let logoImageView: UIImageView = {
        let imageView = UIImageView(false)
        imageView.image = UIImage(named: "logo-white")
        return imageView
    }()
    
    let pagerView: UIScrollView = {
        let scrollView = UIScrollView(false)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setAttributedTitle(NSAttributedString(string: "LOG IN", attributes: Theme.bottomButtonTextAttributes), for: .normal)
        return button
    }()
    
    // step 0
    let emailTextField: TextField = {
        let textField = TextField(placeholder: "Email")
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
    
    // step 1
    let avatarView: UIImageView = {
        let imageView = UIImageView(false)
        imageView.sd_setImage(with: nil, placeholderImage: UIImage(named: "avatar-default"))
        imageView.backgroundColor = UIColor("#FFFFFF", alpha: 0.25)
        imageView.borderColor = UIColor("#92D1C4", alpha: 0.25)
        imageView.borderWidth = 1
        imageView.cornerRadius = 75
        return imageView
    }()
    
    let fullNameTextField: TextField = {
        let textField = TextField(placeholder: "Full Name")
        return textField
    }()
    
    let usernameTextField: TextField = {
        let textField = TextField(placeholder: "Username")
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "required", attributes: Theme.additionalActionTextAttributes)
        label.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        textField.rightView = label
        return textField
    }()

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appPink
        // Do any additional setup after loading the view.
        
        view.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        view.addSubview(pagerView)
        view.addSubview(bottomButton)
        
        pagerView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor).isActive = true
        pagerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pagerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pagerView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor).isActive = true
        
        pagerView.contentSize = CGSize(width: view.frame.width * CGFloat(3), height: 0)
        pagerView.addSubview(containerView)
        containerView.frame = CGRect(x: 0, y: 0, width: pagerView.contentSize.width, height: pagerView.contentSize.height)
        
        bottomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true
        bottomButton.addTarget(self, action: #selector(onButtomButtonTouched), for: .touchUpInside)
        
        setupStep0View()
        setupStep1View()
        setupStep2View()
        
        step = .step0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.frame.size.height = pagerView.frame.height
    }
    
    func setupStep0View() {
        let view = UIView(false)
        
        containerView.addSubview(view)
        view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        let topPaddingView = UIView(false)
        view.addSubview(topPaddingView)
        
        let bottomPaddingView = UIView(false)
        view.addSubview(bottomPaddingView)
        
        let titleLabel = UILabel(false)
        titleLabel.attributedText = NSAttributedString(string: "LET'S MAKE WAVES!", attributes: Theme.titleTextAttributes)
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topPaddingView.bottomAnchor).isActive = true
        
        let subTitleLabel = UILabel(false)
        let font = UIFont(name: .textFontName, size: 12)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor("#0A0707", alpha: 0.55) as Any,
        ]
        subTitleLabel.attributedText = NSAttributedString(string: "Create an account to get started.", attributes: attributes)
        view.addSubview(subTitleLabel)
        subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true

        view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 31).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 42).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -42).isActive = true
        
        view.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 42).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -42).isActive = true
        
        let createButton = Button(title: "CREATE ACCOUNT", backgroundColor: .appCyan)
        view.addSubview(createButton)
        createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 103).isActive = true
        createButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 42).isActive = true
        createButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -42).isActive = true
        createButton.bottomAnchor.constraint(equalTo: bottomPaddingView.topAnchor).isActive = true
        
        topPaddingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topPaddingView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        topPaddingView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        topPaddingView.heightAnchor.constraint(equalTo: bottomPaddingView.heightAnchor).isActive = true
        
        bottomPaddingView.topAnchor.constraint(equalTo: createButton.bottomAnchor).isActive = true
        bottomPaddingView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        bottomPaddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        createButton.addTarget(self, action: #selector(onCreate), for: .touchUpInside)
    }
    
    func setupStep1View() {
        let view = UIView(false)
        
        containerView.addSubview(view)
        view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: self.view.frame.width).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        let topPaddingView = UIView(false)
        view.addSubview(topPaddingView)
        
        let bottomPaddingView = UIView(false)
        view.addSubview(bottomPaddingView)
        
        let titleLabel = UILabel(false)
        titleLabel.attributedText = NSAttributedString(string: "STEP ONE", attributes: Theme.titleTextAttributes)
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topPaddingView.bottomAnchor).isActive = true
        
        let subTitleLabel = UILabel(false)
        var font = UIFont(name: .textFontName, size: 12)
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor("#0A0707", alpha: 0.55) as Any,
        ]
        subTitleLabel.attributedText = NSAttributedString(string: "All you need is to complete your profile!", attributes: attributes)
        view.addSubview(subTitleLabel)
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(avatarView)
        avatarView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 14).isActive = true
        avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        let cameraButton = UIButton(type: .system)
        cameraButton.setImage(UIImage(named: "ic-camera"), for: .normal)
        cameraButton.tintColor = UIColor("#000000", alpha: 0.55)
        cameraButton.backgroundColor = .white
        cameraButton.cornerRadius = 16
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.rightAnchor.constraint(equalTo: avatarView.rightAnchor, constant: 0).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 0).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        view.addSubview(fullNameTextField)
        fullNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fullNameTextField.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 24).isActive = true
        fullNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 42).isActive = true
        fullNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -42).isActive = true
        
        view.addSubview(usernameTextField)
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 10).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 42).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -42).isActive = true
        
        let tipLabel = UILabel(false)
        font = UIFont(name: .textFontName, size: 6)
        attributes = [
            .font: font as Any,
            .foregroundColor: UIColor("#0A0707", alpha: 0.55) as Any,
        ]
        tipLabel.attributedText = NSAttributedString(string: "This will be your display name for your classes and scores.", attributes: attributes)
        view.addSubview(tipLabel)
        tipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tipLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 7).isActive = true
        
        let nextButton = Button(title: "NEXT", backgroundColor: .appCyan)
        view.addSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: tipLabel.bottomAnchor, constant: 30).isActive = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 42).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -42).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: bottomPaddingView.topAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(onNextInStep1), for: .touchUpInside)
        
        topPaddingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topPaddingView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        topPaddingView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        topPaddingView.heightAnchor.constraint(equalTo: bottomPaddingView.heightAnchor).isActive = true
        
        bottomPaddingView.topAnchor.constraint(equalTo: nextButton.bottomAnchor).isActive = true
        bottomPaddingView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        bottomPaddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupStep2View() {
        let view = UIView(false)
        
        containerView.addSubview(view)
        view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: self.view.frame.width * 2).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        let topPaddingView = UIView(false)
        view.addSubview(topPaddingView)
        
        let bottomPaddingView = UIView(false)
        view.addSubview(bottomPaddingView)
        
        let titleLabel = UILabel(false)
        titleLabel.attributedText = NSAttributedString(string: "ALMOST DONE", attributes: Theme.titleTextAttributes)
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topPaddingView.bottomAnchor).isActive = true
        
        let subTitleLabel = UILabel(false)
        var font = UIFont(name: .textFontName, size: 12)
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor("#0A0707", alpha: 0.55) as Any,
        ]
        subTitleLabel.attributedText = NSAttributedString(string: "Personalize your profile for the best experience.", attributes: attributes)
        view.addSubview(subTitleLabel)
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let nextButton = Button(title: "LET’S MAKE WAVES!", backgroundColor: .appCyan)
        view.addSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 318).isActive = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 42).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -42).isActive = true
        
        let skipButton = UIButton(type: .system)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setAttributedTitle(NSAttributedString(string: "SKIP FOR NOW", attributes: Theme.bottomButtonTextAttributes), for: .normal)
        view.addSubview(skipButton)
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 15).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: bottomPaddingView.topAnchor).isActive = true
        
        topPaddingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topPaddingView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        topPaddingView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        topPaddingView.heightAnchor.constraint(equalTo: bottomPaddingView.heightAnchor).isActive = true
        
        bottomPaddingView.topAnchor.constraint(equalTo: skipButton.bottomAnchor).isActive = true
        bottomPaddingView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        bottomPaddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    enum SignupStep: Int {
        case step0 = 0
        case step1 = 1
        case step2 = 2
    }
    
    var step: SignupStep = .step0 {
        didSet {
            switch step {
            case .step0:
                pagerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                bottomButton.setAttributedTitle(NSAttributedString(string: "LOG IN", attributes: Theme.bottomButtonTextAttributes), for: .normal)
            case .step1:
                pagerView.setContentOffset(CGPoint(x: view.frame.width, y: 0), animated: true)
                bottomButton.setAttributedTitle(NSAttributedString(string: "GO BACK", attributes: Theme.bottomButtonTextAttributes), for: .normal)
            case .step2:
                pagerView.setContentOffset(CGPoint(x: view.frame.width * 2, y: 0), animated: true)
                bottomButton.setAttributedTitle(NSAttributedString(string: "GO BACK", attributes: Theme.bottomButtonTextAttributes), for: .normal)
            }
        }
    }

    @objc func onButtomButtonTouched() {
        switch step {
        case .step0:
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .signupViewControllerDidDismissToGoLogin, object: nil)
            }
        case .step1:
            step = .step0
        case .step2:
            step = .step1
        }
    }
    
    @objc func onCreate() {
        step = .step1
    }

    @objc func onNextInStep1() {
        step = .step2
    }
    
    @objc func onCamera() {
        
    }
}
