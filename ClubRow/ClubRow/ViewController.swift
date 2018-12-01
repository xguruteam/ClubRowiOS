//
//  ViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
import KRProgressHUD


class ViewController: SuperViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (appDelegate.g_token == "") {
            
            let vc = self.getStoryboardWithIdentifier(identifier: "LoginViewController")
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
            let vc = self.getStoryboardWithIdentifier(identifier: "MainViewController")
            self.navigationController?.pushViewController(vc, animated: true)
//            KRProgressHUD.show()
//            let loginRequest: String = SERVER_URL + KEY_API_SIGNIN
//            Alamofire.request(loginRequest, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON{ response in
//                KRProgressHUD.dismiss()
//                switch response.result
//                {
//                case .failure( _):
//                    if response.data != nil {
//
//                        let vc = self.getStoryboardWithIdentifier(identifier: "LoginViewController")
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                case .success(let value):
//                    if let httpsStatusCode = response.response?.statusCode {
//
//                        if httpsStatusCode == 200 || httpsStatusCode == 201 {
//                            let response  = value as! NSDictionary
//                            let token_dic = response.value(forKey: "data") as! NSDictionary
//                            let token = token_dic.value(forKey: KEY_TOKEN)
//                            UserDefaults.standard.set(token, forKey: KEY_TOKEN)
//
//                            let vc = self.getStoryboardWithIdentifier(identifier: "MainViewController")
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        } else {
//
//                            let alert = UIAlertController(title: APP_NAME, message: MSG_SIGNIN_FAILED_UNKNOWN, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                }
//            }
        }
    }
		
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

