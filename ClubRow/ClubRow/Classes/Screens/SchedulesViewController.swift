//
//  SchedulesViewController.swift
//  ClubRow
//
//  Created by gao on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import FSCalendar
//import Presentr
import CRRefresh
import MKProgress
import Alamofire
import SwiftyJSON

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
    
    var classes: [[String: Any]]! = []
    
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
        
        self.tableview.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            MKProgress.show()
            
            // API
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Token token=\(appDelegate.g_token)"
            ]
            
            let url = SERVER_URL + KEY_API_LOAD_NEXT_CLASSES
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    var error = false
                    switch response.result
                    {
                    case .failure( _):
                        error = true
                        
                    case .success( _):
                        
                        guard let raw = response.result.value as? [String: Any] else {
                            error = true
                            break
                        }
                        
                        guard let data = raw["data"] as? [[String: Any]] else {
                            error = true
                            break
                        }
                        
//                        print(data)
                        self?.classes = data
                        
                    }
                    if error == true {
                        
                        self?.classes = []
                        DispatchQueue.main.async(execute: {
                            self?.tableview.reloadData()
                            self?.tableview.cr.endHeaderRefresh()
                            MKProgress.hide()
                            self?.view.makeToast(MSG_INSTRUCTORS_FAILED_LOAD_ALL_INSTRUCTORS)
                        })
                    }
                    else {
                        DispatchQueue.main.async(execute: {
                            self?.tableview.reloadData()
                            self?.tableview.cr.endHeaderRefresh()
                            MKProgress.hide()
                        })
                    }
            }
        }
        
        self.tableview.cr.beginHeaderRefresh()
        
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
        let classItem = self.classes[indexPath.row]
        let instructor = classItem["teacher"] as! [String: Any]
        cell.lblMonth.text = Util.convertUnixTimeToDateString(classItem["starts_at"] as! Int, format: "MMMM")
        cell.lblDate.text = Util.convertUnixTimeToDateString(classItem["starts_at"] as! Int, format: "d")
        cell.lblDay.text = Util.convertUnixTimeToDateString(classItem["starts_at"] as! Int, format: "E")
        cell.lblNameOfClass.text = classItem["name"] as! String
        cell.lblInstructorName.text = instructor["name"] as! String
        cell.lblTime.text = Util.convertUnixTimeToDateString(classItem["starts_at"] as! Int, format: "h:mm a 'EST'")
        if let current_user = classItem["current_user"] as? [String: Any], let subscribed = current_user["subscribed"] as? Bool {
            if subscribed {
                cell.ivSubscriptionStatus.image = UIImage.init(named: "ic_bell_selected")
            }
            else {
                cell.ivSubscriptionStatus.image = UIImage.init(named: "ic_bell_unselected")
            }
            
        }
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func onViewClass(_ cell: ClassCell) {
        let classItem = self.classes[cell.tag]
        let classId = classItem["id"] as! Int
        var subscribed = false
        if let current_user = classItem["current_user"] as? [String: Any] {
            subscribed = current_user["subscribed"] as? Bool ?? false
        }
        
        let alert = UIAlertController(title: "Subscribe", message: "Do you really want to \(subscribed ? "unsubscribe" : "subscribe") this class?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            MKProgress.show()
            
            // API
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Token token=\(appDelegate.g_token)"
            ]
            
            let url = SERVER_URL + KEY_API_SUBSCRIBE_FOR_CLASS + "\(classId)/" + (subscribed ? "unsubscribe" : "subscribe")
            Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    var error = false
                    switch response.result
                    {
                    case .failure( _):
                        error = true
                        
                    case .success( _):
                        
                        guard let raw = response.result.value as? [String: Any] else {
                            error = true
                            break
                        }
                        
                        var data: [String: Any]
                        
                        if let original = raw["data"] as? [String: Any] {
                            data = original
                        }
                        else {
                            data = ["subscribed": (subscribed ? false : true)]
                        }
                        
                        guard let new_subscribed = data["subscribed"] as? Bool else {
                            error = true
                            break
                        }
                        
                        var classItem = self.classes[cell.tag]
                        var current_user = classItem["current_user"] as? [String: Any] ?? [:]
                        current_user.merge(["subscribed": new_subscribed], uniquingKeysWith: { (old, new) -> Any in
                            return new
                        })
                        classItem.merge(["current_user": current_user], uniquingKeysWith: { (old, new) -> Any in
                            new
                        })
                        self.classes[cell.tag] = classItem
                        
                    }
                    if error == true {
                        DispatchQueue.main.async(execute: {
                            MKProgress.hide()
                        })
                    }
                    else {
                        DispatchQueue.main.async(execute: {
                            UIView.performWithoutAnimation {
                                self.tableview.reloadRows(at: [IndexPath.init(row: cell.tag, section: 0)], with: .none)
                            }
                            MKProgress.hide()
                        })
                    }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        /*
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
 */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.getStoryboardWithIdentifier(identifier: "ClassDetailsViewController") as! ClassDetailsViewController
        let classItem = self.classes[indexPath.row] as! [String: Any]
        let instructor = classItem["teacher"] as! [String: Any]
        vc.instructor = instructor
        self.navigationController?.pushViewController(vc, animated: true)
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
