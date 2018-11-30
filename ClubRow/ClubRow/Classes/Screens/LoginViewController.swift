//
//  ViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import KRProgressHUD
import Toast_Swift
import Alamofire

class LoginViewController: SuperViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
		
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTouchScreen(_ sender: Any) {
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        if validateFields() {
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            let params: [String: Any] = [
                KEY_USER: [
                    KEY_EMAIL: txtEmail.text!,
                    KEY_PASSWORD: txtPassword.text!
                ]
            ]
            
            KRProgressHUD.show()
            let loginRequest: String = SERVER_URL + KEY_API_SIGNIN
            Alamofire.request(loginRequest, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
                KRProgressHUD.dismiss()
                switch response.result
                {
                case .failure( _):
                    if response.data != nil {
                        
                        let alert = UIAlertController(title: APP_NAME, message: MSG_SIGNIN_FAILED_NETWORK, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                case .success(let value):
                    if let httpsStatusCode = response.response?.statusCode {
                        
                        if httpsStatusCode == 200 || httpsStatusCode == 201 {
                            let response  = value as! NSDictionary
                            let token_dic = response.value(forKey: "data") as! NSDictionary
                            let token = token_dic.value(forKey: KEY_TOKEN) as! String
                            UserDefaults.standard.set(token, forKey: KEY_TOKEN)
                            
                            let vc = self.getStoryboardWithIdentifier(identifier: "MainViewController")
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            
                            let alert = UIAlertController(title: APP_NAME, message: MSG_SIGNIN_FAILED_UNKNOWN, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
        
    }
    
    func validateFields() -> Bool {
        //check empty
        var msg: String = ""
        
        if (txtEmail.text == "") {
            
            msg = MSG_SIGNUP_EMAIL_EMPTY
        }
        if msg == "" {
            return true
        } else {
            self.view.makeToast(msg)
            return false
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(txtEmail) {
            txtPassword.becomeFirstResponder()
        } else if textField.isEqual(txtPassword) {
            onLogin(textField)
        }
        return false
    }
}

