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


class RootViewController: SuperViewController {
    
    
    static var instance: RootViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        RootViewController.instance = self
        let vc = self.getStoryboardWithIdentifier(identifier: "LoginViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
		
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

