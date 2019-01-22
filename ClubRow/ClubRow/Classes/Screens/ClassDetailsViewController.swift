//
//  ClassDetailsViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/7/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import CRRefresh
import MKProgress
import Alamofire
import SwiftyJSON
import SwiftyAvatar

class ClassDetailsViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource, ClassDetailCellDelegate {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var classDetailTableView: UITableView!
    @IBOutlet weak var lblInstructorName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var avatarView: SwiftyAvatar!
    @IBOutlet weak var titleBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topSafeAreaView: UIView!
    @IBOutlet weak var connectButton: UIButton!
    var instructor: [String: Any]!
    var pastClasses: [[String: Any]]! = []
    var liveClasses: [[String: Any]]! = []
    var nextClasses: [[String: Any]]! = []
    var instrutorDescription: String!
    
    @IBAction func onJoinClass(_ sender: Any) {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        let vc = self.getStoryboardWithIdentifier(identifier: "ClassVideoViewController") as! ClassVideoViewController
//        MainViewController.getInstance().navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func onConnectDevice(_ sender: Any) {
        let vc = self.getStoryboardWithIdentifier(identifier: "DevicesViewController") as! DevicesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func classDetailCell(didSelect indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            print("Join Live Class")
            let classItem = self.liveClasses[indexPath.row]
//            let topic = "lobby:\(classItem["lobby_id"] as! Int)"
//            SocketManager.sharedManager.delegate = self
//            SocketManager.sharedManager.connectChannel(topic: topic)
            let vc = self.getStoryboardWithIdentifier(identifier:"ClassVideoViewController") as! ClassVideoViewController
            vc.lobbyId = classItem["lobby_id"] as! Int
            vc.classData = classItem
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            self.present(vc, animated: false, completion: nil)
        case 2:
            print("Set notify")
            let classItem = self.nextClasses[indexPath.row]
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
                            
                            var classItem = self.nextClasses[indexPath.row]
                            var current_user = classItem["current_user"] as? [String: Any] ?? [:]
                            current_user.merge(["subscribed": new_subscribed], uniquingKeysWith: { (old, new) -> Any in
                                return new
                            })
                            classItem.merge(["current_user": current_user], uniquingKeysWith: { (old, new) -> Any in
                                new
                            })
                            self.nextClasses[indexPath.row] = classItem
                            
                        }
                        if error == true {
                            DispatchQueue.main.async(execute: {
                                MKProgress.hide()
                            })
                        }
                        else {
                            DispatchQueue.main.async(execute: {
                                UIView.performWithoutAnimation {
                                    self.classDetailTableView.reloadRows(at: [indexPath], with: .none)
                                }
                                MKProgress.hide()
                            })
                        }
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            }))
            
            self.present(alert, animated: true, completion: nil)
        case 3:
            print("Goto Lobbies screen")
            let classItem = self.pastClasses[indexPath.row]
            let vc = self.getStoryboardWithIdentifier(identifier: "LobbiesViewController") as! LobbiesViewController
            vc.classData = classItem
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch section {
        case 0:
            numberOfRows = 1
        case 1:
            numberOfRows = self.liveClasses.count
        case 2:
            numberOfRows = self.nextClasses.count
        case 3:
            numberOfRows = self.pastClasses.count
        default:
            numberOfRows = 0
        }
        return numberOfRows;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
           let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionCell
           cell.textView.text = self.instrutorDescription
           cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailCell") as! ClassDetailCell
            let classItem = self.liveClasses[indexPath.row]
            cell.headerLabel.text = classItem["name"] as? String
            cell.lblClassTime.isHidden = true
            cell.joinClassBtn.setTitle("Join Live Class", for: .normal)
            cell.viewDot.backgroundColor = UIColor(red: 0x15, green: 0xEC, blue: 0xC1)
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailCell") as! ClassDetailCell
            let classItem = self.nextClasses[indexPath.row]
            cell.headerLabel.text = classItem["name"] as? String
            cell.lblClassTime.text = Util.convertUnixTimeToDateString(classItem["starts_at"] as! Int, format: "E, MMM d yyyy\nh:mm a 'EST'")
            cell.lblClassTime.isHidden = false
            cell.viewDot.backgroundColor = UIColor(red: 0xED, green: 0xED, blue: 0xED)
            if let current_user = classItem["current_user"] as? [String: Any], let subscribed = current_user["subscribed"] as? Bool {
                if subscribed {
                    cell.joinClassBtn.setTitle("Unsubscribe", for: .normal)
                }
                else {
                    cell.joinClassBtn.setTitle("Subscribe", for: .normal)
                }
                
            }

            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDetailCell") as! ClassDetailCell
            let classItem = self.pastClasses[indexPath.row]
            cell.headerLabel.text = classItem["name"] as? String
            cell.lblClassTime.isHidden = true
            cell.joinClassBtn.setTitle(Util.generateNumberOfLobbiesText(classItem["lobbies_count"] as! Int), for: .normal)
            cell.viewDot.backgroundColor = UIColor(red: 0xF8, green: 0xC7, blue: 0xCD)
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionCell
            
            
            cell.textView.text = self.instrutorDescription
            
            let fixedWidth = tableView.frame.size.width - 28 * 2
            
            cell.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            let newSize = cell.textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            
            var newFrame = cell.textView.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            cell.textView.frame = newFrame
            
            return cell.textView.frame.height + 50
        case 1:
            return 170
        case 2:
            return 250
        default:
            return 170
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.getStoryboardWithIdentifier(identifier: "ClassVideoViewController") as! ClassVideoViewController
//        MainViewController.getInstance().navigationController?.pushViewController(vc, animated: true)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(removeVideoPlayerWindow), name: NSNotification.Name(rawValue: "dismissVideoWindow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // shadow
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleView.layer.shadowOpacity = 0.07
        titleView.layer.shadowRadius = 3
        
//        viewBottom.constant = 300
        
        if let name = self.instructor["name"] as? String {
            self.lblInstructorName.text = name
            self.lblTitle.text = name
        }
        else {
            self.lblInstructorName.text = "Unknown"
            self.lblTitle.text = "Unknown"
        }
        
        if let avatarURL = instructor["image_url"] as? String {
            let imageUrl:URL = URL(string: avatarURL)!
            
            // Start background thread so that image loading does not make app unresponsive
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let imageData:NSData = NSData(contentsOf: imageUrl) {
                
                // When from background thread, UI needs to be updated on main_queue
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    self.avatarView.image = image
                }
                }
            }
        }
        else {
            
        }
        
        if let des = instructor["description"] as? String {
            self.instrutorDescription = des
        }
        else {
            self.instrutorDescription = "               "
        }
        
        self.classDetailTableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            

            guard let teacherId = self?.instructor["user_id"] as? Int else {
                self?.view.makeToast(MSG_INSTRUCTOR_INVAILD_ID)
                // empty tableview
                self?.pastClasses = []
                self?.liveClasses = []
                self?.nextClasses = []
                self?.classDetailTableView.reloadData()
                return
            }
            
            MKProgress.show()
            
            // API
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Token token=\(appDelegate.g_token)"
            ]
            
            let url = SERVER_URL + KEY_API_LOAD_CLASSES_FOR_INSTRUCTOR + "teacher_user_id=\(teacherId)"
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

                        self?.pastClasses = []
                        self?.liveClasses = []
                        self?.nextClasses = []
                        for classItem in data {
                            guard let classType = classItem["type"] as? String else {
                                continue
                            }
                            switch classType {
                            case "archived":
                                self?.pastClasses.append(classItem)
                            case "live":
                                self?.liveClasses.append(classItem)
                            case "next":
                                self?.nextClasses.append(classItem)
                            default:
                                continue
                            }
                        }
                    }
                    if error == true {
                        
                        self?.pastClasses = []
                        self?.liveClasses = []
                        self?.nextClasses = []
                        
                        DispatchQueue.main.async(execute: {
                            self?.classDetailTableView.reloadData()
                            self?.classDetailTableView.cr.endHeaderRefresh()
                            MKProgress.hide()
                            self?.view.makeToast(MSG_INSTRUCTORS_FAILED_LOAD_CLASSES)
                        })
                    }
                    else {
                        DispatchQueue.main.async(execute: {
                            self?.classDetailTableView.reloadData()
                            self?.classDetailTableView.cr.endHeaderRefresh()
                            MKProgress.hide()
                        })
                    }
            }
        }
        
        self.classDetailTableView.cr.beginHeaderRefresh()

    }

    @objc func removeVideoPlayerWindow() {
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }
    
    @objc func orientationChanged() {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        titleBarBottomConstraint.constant = C2ScanningManager.shared.isConnected ? -66 : -106
        connectButton.isHidden = C2ScanningManager.shared.isConnected ? true : false
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            
            let topSafeAreaHeight = topPadding ?? 44
            if topSafeAreaHeight < 44 {
                titleLabelTopConstraint.constant = 43
                backButtonTopConstraint.constant = 44
            }

        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

extension ClassDetailsViewController: DescriptionCellDelegate {
    func didChangeDescription(_ sender: DescriptionCell) {
        print("=======changed")
    }
}
