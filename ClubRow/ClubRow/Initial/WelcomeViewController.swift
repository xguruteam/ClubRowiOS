//
//  WelcomeViewController.swift
//  ClubRow
//
//  Created by Guru on 7/8/19.
//  Copyright © 2019 CREATORSNEVERDIE. All rights reserved.
//

import UIKit
import DeviceKit

class WelcomeViewController: BaseViewController {
    
    @IBOutlet weak var lblMakeWaves: UILabel!
    @IBOutlet weak var ivBackground: UIImageView!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lblSubTitle1: UILabel!
    @IBOutlet weak var lblSubTitle2: UILabel!
    @IBOutlet weak var ctSubTitle1: NSLayoutConstraint!
    @IBOutlet weak var ctSubTitle2: NSLayoutConstraint!
    @IBOutlet weak var ctSignup: NSLayoutConstraint!
    @IBOutlet weak var ctLogin: NSLayoutConstraint!
    
    
    let tiltSize = 20
    var loginButtonBottomConstraint:CGFloat = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let vc = LoginViewController()
        self.show(vc, sender: self)
    }
    
    @IBAction func onSignup(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if device.isOneOf(groupOfiPhoneX) {
            loginButtonBottomConstraint = 79
        } else {
            loginButtonBottomConstraint = 29
        }

        // Do any additional setup after loading the view.
        lblMakeWaves.layer.masksToBounds = false
        lblMakeWaves.clipsToBounds = false
        
        let font = UIFont(name: "BebasNeue", size: 60)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let shadow = NSShadow()
        shadow.shadowColor = UIColor("#020101", alpha: 0.43)
        shadow.shadowBlurRadius = 6
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle,
            .shadow: shadow
        ]
        
        lblMakeWaves.attributedText = NSAttributedString(string: "#MAKEWAVES", attributes: attributes)
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -tiltSize
        horizontalMotionEffect.maximumRelativeValue = tiltSize
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -tiltSize
        verticalMotionEffect.maximumRelativeValue = tiltSize
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        ivBackground.addMotionEffect(motionEffectGroup)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ivLogo.alpha = 0
        lblMakeWaves.alpha = 0
        
        ctSubTitle1.constant = view.frame.size.width
        ctSubTitle2.constant = view.frame.size.width
        
        ctSignup.constant = -60
        ctLogin.constant = -60
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseOut, animations: {
            self.ivLogo.alpha = 1.0
            self.lblMakeWaves.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.ctSubTitle1.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseInOut, animations: {
            self.ctSubTitle2.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 1, options: .curveEaseInOut, animations: {
            self.ctSignup.constant = self.loginButtonBottomConstraint + 55 + 8
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 1.2, options: .curveEaseInOut, animations: {
            self.ctLogin.constant = self.loginButtonBottomConstraint
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
