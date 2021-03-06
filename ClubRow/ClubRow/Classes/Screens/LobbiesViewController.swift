//
//  LobbiesViewController.swift
//  ClubRow
//
//  Created by Guru on 12/12/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import CRRefresh
import MKProgress
import Alamofire
import SwiftyJSON


class LobbiesViewController: SuperViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblInstructorName: UILabel!
    @IBOutlet weak var lblClassName: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButtonBottomConstraint: NSLayoutConstraint!
    var classData: [String: Any]!
    var lobbies: [[String: Any]]! = []
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onConnectDevice(_ sender: Any) {
        let vc = self.getStoryboardWithIdentifier(identifier: "DevicesViewController") as! DevicesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onCreate(_ sender: Any) {
        print("onCreate")
        
        MKProgress.show()
        
        let classId = self.classData["id"] as! Int
        
        // API
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\(appDelegate.g_token)"
        ]
        
        let url = SERVER_URL + KEY_API_CREATE_LOBBY_FOR_CLASS + "/\(classId)/lobbies"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                var error = false
                var newLobbyId = 0
                switch response.result
                {
                case .failure( _):
                    error = true
                    
                case .success( _):
                    
                    guard let raw = response.result.value as? [String: Any] else {
                        error = true
                        break
                    }
                    
                    guard let data = raw["data"] as? [String: Any] else {
                        error = true
                        break
                    }
                    
                    newLobbyId = data["id"] as! Int
                    
                }
                if error == true {
                    
                    DispatchQueue.main.async(execute: {
                        MKProgress.hide()
                        self.view.makeToast(MSG_LOBBIES_FAILED_CREATE)
                    })
                }
                else {
                    DispatchQueue.main.async(execute: {
                        MKProgress.hide(false)
                        // enter leaderboard
                        print("enter lobby \(newLobbyId)")
                        let vc = self.getStoryboardWithIdentifier(identifier:"ClassVideoViewController") as! ClassVideoViewController
                        vc.lobbyId = newLobbyId
                        vc.classData = self.classData
                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                        self.present(vc, animated: false, completion: nil)
                    })
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(removeVideoPlayerWindow), name: NSNotification.Name(rawValue: "dismissVideoWindow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        tableView?.backgroundColor = .clear
        tableView?.contentInset = UIEdgeInsets(top: 23, left: 0, bottom: 10, right: 0)
        self.viewHeader.makeBox()
        
        self.lblClassName.text = classData["name"] as? String
        
        if let instructor = classData["teacher"] as? [String: Any] {
            self.lblInstructorName.text = instructor["name"] as? String
        }
        else {
            self.lblInstructorName.text = "unknown"
        }
        
        self.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            MKProgress.show()
            
            let classId = self?.classData["id"] as! Int
            
            // API
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Token token=\(appDelegate.g_token)"
            ]
            
            let url = SERVER_URL + KEY_API_LOAD_LOBBIES_FOR_CLASS + "/\(classId)/lobbies"
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
                        
                        self?.lobbies = data.filter({ (lobby) -> Bool in
                            if let status = lobby["status"] as? String {
                                switch status {
                                case "accepting_participants":
                                    return true
//                                case "workout_finished":
//                                case "workout_in_progress":
                                default:
                                    return false
                                }
                            }
                            else {
                                return false
                            }

                        })
                    }
                    if error == true {
                        
                        self?.lobbies = []
                        
                        DispatchQueue.main.async(execute: {
                            self?.tableView.reloadData()
                            self?.tableView.cr.endHeaderRefresh()
                            MKProgress.hide()
                            self?.view.makeToast(MSG_INSTRUCTORS_FAILED_LOAD_ALL_INSTRUCTORS)
                        })
                    }
                    else {
                        DispatchQueue.main.async(execute: {
                            self?.tableView.reloadData()
                            self?.tableView.cr.endHeaderRefresh()
                            MKProgress.hide()
                        })
                    }
            }
        }
        
        self.tableView.cr.beginHeaderRefresh()
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
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        topBarBottomConstraint.constant = C2ScanningManager.shared.isConnected ? -66 : -106
        connectButton.isHidden = C2ScanningManager.shared.isConnected ? true : false
        titleLabelBottomConstraint.constant = C2ScanningManager.shared.isConnected ? 22 : 62
        backButtonBottomConstraint.constant = C2ScanningManager.shared.isConnected ? 10 : 50

    }
  
    override var shouldAutorotate: Bool {
        return true
    }
    
    
//
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return .portrait
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LobbiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lobbies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LobbyTableViewCell", for: indexPath) as! LobbyTableViewCell
        
        let lobby = self.lobbies[indexPath.row]
        cell.lblMembers.text = "\(lobby["participants_count"] as! Int)"
        cell.lblName.text = "\(lobby["user_name"] as! String)'s Lobby"
        
        if let status = lobby["status"] as? String {
            switch status {
            case "accepting_participants":
                cell.lblStatus.text = "Accepting Participants"
            case "workout_finished":
                cell.lblStatus.text = "Workout Finished"
            case "workout_in_progress":
                cell.lblStatus.text = "Workout in Progress"
            default:
                cell.lblStatus.text = "Unknown"
            }
        }
        else {
            cell.lblStatus.text = "Unknown"
        }
        cell.btnSelectLobby.tag = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension LobbiesViewController: SelectLobbyDelegate {
    func onSelectLobby(_index: Int) {
        let lobby = self.lobbies[_index]
        print("\(lobby["id"] as! Int) lobby selected")
        let vc = self.getStoryboardWithIdentifier(identifier:"ClassVideoViewController") as! ClassVideoViewController
        vc.lobbyId = lobby["id"] as! Int
        vc.classData = classData
        
        UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeRight.rawValue), forKey: "orientation")
        
        self.present(vc, animated: false, completion: nil)
    }
}
