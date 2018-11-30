//
//  TabbarViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.isHidden = true
        
        self.cornerRadiusOn(view: self.view)
        self.shadowOn(view: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func shadowOn(view: UIView) {
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize.zero
        
        //        view.layer.shouldRasterize = true
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 1
        
        //        view.layer.masksToBounds = true
        
        //        view.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //        view.layer.shouldRasterize = true
        //        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func cornerRadiusOn(view: UIView) {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 15
    }

}
