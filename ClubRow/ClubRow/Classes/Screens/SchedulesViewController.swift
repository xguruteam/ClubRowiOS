//
//  SchedulesViewController.swift
//  ClubRow
//
//  Created by gao on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftEntryKit
import Presentr

class SchedulesViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource, ClassCellDelegate {
    
    @IBOutlet weak var conTblTop: NSLayoutConstraint!
    @IBOutlet weak var conHandlerTop: NSLayoutConstraint!
    @IBOutlet var rootView: UIView!
    
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var btnCalendar: UIButton!
    
    @IBOutlet weak var handlerForCalendar: UIView!
    var viewCalendar: FSCalendar!
    var isShowedCalendar:Bool!
    
    var calendar:FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isShowedCalendar = false
        calendar = FSCalendar(frame: CGRect())
        calendar.appearance.weekdayTextColor = UIColor.white
        calendar.appearance.titleSelectionColor = UIColor.white
        calendar.appearance.subtitlePlaceholderColor = UIColor.white
        calendar.appearance.headerTitleColor = UIColor.white
        calendar.appearance.titleDefaultColor = UIColor.white
        calendar.appearance.titlePlaceholderColor = UIColor.lightGray
        calendar.backgroundColor = UIColor.black
        
        view.insertSubview(calendar, belowSubview: titleView)
        
        self.viewCalendar = calendar

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleCalenderGesture(gesture:)))
        swipeUp.direction = .up
        self.viewCalendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.onShowCalendar(gesture:)))
        swipeDown.direction = .down
        
        self.handlerForCalendar.addGestureRecognizer(swipeDown)
        self.handlerForCalendar.addGestureRecognizer(swipeUp)
        
        // Do any additional setup after loading the view.
        self.setRoundView(radius: 10.0, view: viewCalendar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let titleHeight = self.titleView.bounds.height
        let rect = UIScreen.main.bounds.size
        
        let width = rect.width - 60
        let height = width // * 250/320
        if isShowedCalendar {
            self.viewCalendar.frame = CGRect(x: 30, y: titleHeight + 10, width: width, height: height)
        } else {
            self.viewCalendar.frame = CGRect(x: 30, y: titleHeight - height, width: width, height: height)
        }
        
//        let calendar = FSCalendar(frame: CGRect(x: 30, y: titleHeight - height, width: width, height: height))
        //calendar.dataSource = self
        //calendar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onShowCalendar(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            let titleHeight = self.titleView.bounds.height
            let calendarFrame = self.viewCalendar.frame
            let actualHeight = calendarFrame.size.height
            let width = calendarFrame.size.width
            if isShowedCalendar == false {
                //initially set height to zero and in animation block we need to set its actual height.
                self.conHandlerTop.constant = actualHeight - 10
                self.conTblTop.constant = -15
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    
                    //setting the actual height with animation
                    self.viewCalendar.frame = CGRect(x: 30, y: titleHeight + 10, width: width, height: actualHeight)
                    self.isShowedCalendar  = true
                    self.view.layoutIfNeeded()
                    
                }) { (isCompleted) in
                    
                }
                
            } else {
                self.conHandlerTop.constant = -20
                self.conTblTop.constant = -15
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.viewCalendar.frame = CGRect(x: 30, y: titleHeight-actualHeight, width: width, height: actualHeight)
                    self.isShowedCalendar  = false
                    self.view.layoutIfNeeded()
                }) { (isCompleted) in
                    
                }
            }
        }
    }
    
    
    @objc func handleCalenderGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            let calendarFrame = self.viewCalendar.frame
            let actualHeight = calendarFrame.size.height
            let width = calendarFrame.size.width
            let titleHeight = self.titleView.bounds.height
            self.conHandlerTop.constant = -20
            self.conTblTop.constant = -15
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.viewCalendar.frame = CGRect(x: 30, y: titleHeight - actualHeight, width: width, height: actualHeight)
                self.isShowedCalendar  = false
                self.view.layoutIfNeeded()
            }) { (isCompleted) in
                
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellClass") as! ClassCell
        cell.delegate = self
        return cell
    }
    
    func onViewClass(_ cell: ClassCell?) {
        let controller = self.getStoryboardWithIdentifier(identifier: "DateFilterViewController") as! DateFilterViewController
        
        let presenter: Presentr = {
            let width = ModalSize.full
            let height = ModalSize.fluid(percentage: 0.80)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: PresentationType.bottomHalf)
            customPresenter.transitionType = .coverVertical
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.getStoryboardWithIdentifier(identifier: "ClassDetailsViewController") as! ClassDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 3, 2
    private func showLightAwesomePopupMessage(attributes: EKAttributes) {
        let image = UIImage(named: "ic_done_all_light_48pt")!
        let title = "Awesome!"
        let description = "You are using SwiftEntryKit, and this is a pop up with important content"
        showPopupMessage(attributes: attributes, title: title, titleColor: .white, description: description, descriptionColor: .white, buttonTitleColor: EKColor.Gray.mid, buttonBackgroundColor: .white, image: image)
    }
    
    // 0, 0
    private func showNotificationMessage(attributes: EKAttributes, title: String, desc: String, textColor: UIColor, imageName: String? = nil) {
        let title = EKProperty.LabelContent(text: title, style: .init(font: MainFont.medium.with(size: 16), color: textColor))
        let description = EKProperty.LabelContent(text: desc, style: .init(font: MainFont.light.with(size: 14), color: textColor))
        var image: EKProperty.ImageContent?
        if let imageName = imageName {
            image = .init(image: UIImage(named: imageName)!, size: CGSize(width: 35, height: 35))
        }
        
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    // 5, 1
    private func showCustomViewController(attributes: EKAttributes) {
        let viewController = DateViewController(with: NibDateView())
        SwiftEntryKit.display(entry: viewController, using: attributes)
    }
    
    private func showPopupMessage(attributes: EKAttributes, title: String, titleColor: UIColor, description: String, descriptionColor: UIColor, buttonTitleColor: UIColor, buttonBackgroundColor: UIColor, image: UIImage? = nil) {
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
