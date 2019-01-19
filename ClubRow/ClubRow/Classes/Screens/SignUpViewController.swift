//
//  ViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD
import Toast_Swift

class SignUpViewController: SuperViewController {

    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    var email: String?
    var password: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
		
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTouchScreen(_ sender: Any) {
        hideKeyboards()
    }
    
    func hideKeyboards() {
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        self.txtConfirmPassword.resignFirstResponder()
        self.txtFirstName.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        if validateFields() {
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            let params: [String: Any] = [
                KEY_USER: [
                    KEY_FIRST_NAME: txtFirstName.text!,
                    KEY_LAST_NAME: txtLastName.text!,
                    KEY_EMAIL: txtEmail.text!,
                    KEY_PASSWORD: txtPassword.text!,
                    KEY_PASSWORD_CONFIRMATION: txtConfirmPassword.text!
                ]
            ]
            KRProgressHUD.show()
            let signupRequest: String = SERVER_URL + KEY_API_SIGNUP
            Alamofire.request(signupRequest, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
                KRProgressHUD.dismiss()
                switch response.result
                {
                    case .failure(let error):
                        if let data = response.data {
                            
                            print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                            let alert = UIAlertController(title: APP_NAME, message: MSG_SIGNUP_FAILED_NETWORK, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        print(error)
                    case .success(_):
                        if let httpsStatusCode = response.response?.statusCode {
                            
                            if httpsStatusCode == 200 || httpsStatusCode == 201 {
                                
                                let alert = UIAlertController(title: APP_NAME, message: MSG_SIGNUP_SUCCESS, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                                    self.email = self.txtEmail.text
                                    self.password = self.txtPassword.text
                                    self.performSegue(withIdentifier: "segueToLogin", sender: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                
                                let alert = UIAlertController(title: APP_NAME, message: MSG_SIGNUP_FAILED_UNKNOWN, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let loginVC = segue.destination as? LoginViewController else {
            return
        }
        
        if let _ = self.email, let _ = self.password {
            print("registered")
            loginVC.registeredEmail = self.email
            loginVC.registeredPassword = self.password
        }
    }
    
    func validateFields() -> Bool {
        //check empty
        var msg: String = ""
        if (self.txtFirstName.text == "") {
            
            msg = MSG_SIGNUP_FIRST_NAME_EMPTY
        } else if (self.txtLastName.text == "") {
            
            msg = MSG_SIGNUP_FIRST_NAME_EMPTY
        } else if (txtEmail.text == "") {
            
            msg = MSG_SIGNUP_EMAIL_EMPTY
        } else if (txtPassword.text == "") {
            
            msg = MSG_SIGNUP_PASSWORD_EMPTY
        } else if (txtConfirmPassword.text == "") {
            
            msg = MSG_SIGNUP_PASSWORD_CONFIRM_EMPTY
        }
        if (!Util.validateEmail(emailStr: self.txtEmail.text!)) {
            
            msg = MSG_SIGNUP_EMAIL_FORMAT_ERROR
        }
        if (txtPassword.text != txtConfirmPassword.text) {
            
            msg = MSG_SIGNUP_PASSWORD_CONFIRM_ERROR
        }
        if msg == "" {
            return true
        } else {
            self.view.makeToast(msg)
            return false
        }
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(txtFirstName) {
            txtLastName.becomeFirstResponder()
        } else if textField.isEqual(txtLastName) {
            txtEmail.becomeFirstResponder()
        } else if textField.isEqual(txtEmail) {
            txtPassword.becomeFirstResponder()
        } else if textField.isEqual(txtPassword) {
            txtConfirmPassword.becomeFirstResponder()
        } else if textField.isEqual(txtConfirmPassword) {
            hideKeyboards()
        }
        return false
    }
}

