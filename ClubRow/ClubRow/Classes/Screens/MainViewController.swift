//
//  MainViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import SwiftEntryKit
import Presentr

class MainViewController: SuperViewController {

    @IBOutlet var btnHome: UIButton!
    @IBOutlet var btnCalendar: UIButton!
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    var currentIndex = 2
    
    var tabbarController = TabbarViewController()
    
    static var sharedViewController = MainViewController();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // shadow
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -1)
        shadowView.layer.shadowOpacity = 0.07
        shadowView.layer.shadowRadius = 3
        
        // Init Teachers
        

        // Do any additional setup after loading the view.
        tabbarController.selectedIndex = currentIndex
        self.selectTabButton(tag: (currentIndex + 1))
        
        MainViewController.sharedViewController = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mainViewController = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapClick(_ sender: UIButton) {
        let tag = sender.tag;
        currentIndex = tag - 1
        tabbarController.selectedIndex = currentIndex
        self.selectTabButton(tag: tag)
    }
    
    func selectTabButton(tag: Int){
        btnHome.isSelected = false
        btnCalendar.isSelected = false
        btnPlay.isSelected = false
        btnProfile.isSelected = false
        
        if (tag == 1){
            btnHome.isSelected = true
        } else if (tag == 2) {
            btnCalendar.isSelected = true
        } else if (tag == 3) {
            btnPlay.isSelected = true
        } else if (tag == 4) {
            btnProfile.isSelected = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedContainer" {
            tabbarController = segue.destination as! TabbarViewController
            tabbarController.hidesBottomBarWhenPushed = true
        }
    }
    
    public static func getInstance() -> MainViewController {
        return sharedViewController
    }
    
    public func showBottomView(){
        let controller = self.getStoryboardWithIdentifier(identifier: "DateFilterViewController") as! DateFilterViewController
        
        let presenter: Presentr = {
            let width = ModalSize.full
            let height = ModalSize.fluid(percentage: 0.50)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = .coverVerticalFromTop
            customPresenter.roundCorners = false
            customPresenter.backgroundColor = .clear
            customPresenter.backgroundOpacity = 0.5
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnSwipeDirection = .top
            return customPresenter
        }()
        
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
        
    }
    
    public func showPopupMessage(attributes: EKAttributes, title: String, titleColor: UIColor, description: String, descriptionColor: UIColor, buttonTitleColor: UIColor, buttonBackgroundColor: UIColor, image: UIImage? = nil) {
        
        var themeImage: EKPopUpMessage.ThemeImage?
        
        if let image = image {
            themeImage = .init(image: .init(image: image, size: CGSize(width: 60, height: 60), contentMode: .scaleAspectFit))
        }
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: MainFont.medium.with(size: 24), color: titleColor, alignment: .center))
        let description = EKProperty.LabelContent(text: description, style: .init(font: MainFont.light.with(size: 16), color: descriptionColor, alignment: .center))
        let button = EKProperty.ButtonContent(label: .init(text: "Got it!", style: .init(font: MainFont.bold.with(size: 16), color: buttonTitleColor)), backgroundColor: buttonBackgroundColor, highlightedBackgroundColor: buttonTitleColor.withAlphaComponent(0.05))
        let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
            SwiftEntryKit.dismiss()
        }
        
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
