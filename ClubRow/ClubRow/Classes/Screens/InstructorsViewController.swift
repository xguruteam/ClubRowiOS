//
//  InstructorsViewController.swift
//  ClubRow
//
//  Created by Guru on 12/11/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import CRRefresh
import MKProgress
import Alamofire
import SwiftyJSON


class InstructorsViewController: SuperViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabelContraint: NSLayoutConstraint!
    @IBOutlet weak var topBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var connectButton: UIButton!
    
    var instructors: [[String: Any]]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        
        self.collectionView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            MKProgress.show()
            
            // API
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Token token=\(appDelegate.g_token)"
            ]
            let url = SERVER_URL + KEY_API_LOAD_ALL_INSTRUCTORS
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
                        
                        
                        self?.instructors = data
//                            .map({ (original) in
//                            original.merging(
//                                ["image_url": "http://clubrow.appspot.com/static/instructors/natemorris.png",
//                                 "description": "Our hardware is in the prototyping stage (2nd iteration) and is developed by an experienced design studio. The software drivers for the core hardware components are present and thus the functionality of the hardware is checked, with the sole exception of the microphone.The first task is to work on the microphone of the device, implementing recording to the present SD card. In a second step, the audio should be streamed using Wifi and the speaker of the device and the speaker will enable to use the device as a walkie-talkie. This will happen in conjunction with our app and backend developer. Later on, the LED needs to be controlled using the tactile switches of device as well as NFC tags. An event queuing for light effects and parallel audio playback should be implemented allowing triggering from NFC, tactile switches or commands send via radio. Alarm functionality should allow users to set alarms and timers for specific times to trigger sound and/or light enable ‘time-to-get-out-of-bed’.Next, gesture control by utilizing the accelerometer/gyroscope sensor. While the SPI connection is already working, implementing single and double tap gestures as well as a shake gesture.We are also looking for a full-stack app developer to build a straightforward multi-user (+admin) GPS/IP based subscription app (Android and iOS) that allows members to utilize a home, enabling them to check in/out of a house securely via smart/IoT enabled locking mechanisms. The mobile app will have 4 key pages (incl. functionality) as follows:" ],
//                                uniquingKeysWith: { (old, new) in
//                                new
//                            })
//                        })

                    }
                    if error == true {
                        self?.instructors = []
                        
                        DispatchQueue.main.async(execute: {
                            self?.collectionView.reloadData()
                            self?.collectionView.cr.endHeaderRefresh()
                            MKProgress.hide()
                            self?.view.makeToast(MSG_INSTRUCTORS_FAILED_LOAD_ALL_INSTRUCTORS)
                        })
                    }
                    else {
                        DispatchQueue.main.async(execute: {
                            self?.collectionView.reloadData()
                            self?.collectionView.cr.endHeaderRefresh()
                            MKProgress.hide()
                        })
                    }
            }
        }
        
        self.collectionView.cr.beginHeaderRefresh()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        topBarConstraint.constant = C2ScanningManager.shared.isConnected ? -66 : -106
        connectButton.isHidden = C2ScanningManager.shared.isConnected ? true : false
        titleLabelContraint.constant = C2ScanningManager.shared.isConnected ? 22 : 62
    }
    
    @IBAction func onConnect(_ sender: Any) {
        let vc = self.getStoryboardWithIdentifier(identifier: "DevicesViewController") as! DevicesViewController
        self.navigationController?.pushViewController(vc, animated: true)
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

extension InstructorsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.instructors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstrcutorCollectionViewCell", for: indexPath as IndexPath) as! InstrcutorCollectionViewCell
        
        let instructor = self.instructors[indexPath.row]
        
        cell.lblNumOfClasses.text = Util.generateNumberOfClassesText(instructor["classes_count"] as! Int)
        
        if let name = instructor["name"] as? String {
            cell.lblInstructorName.text = name
        }
        else {
            cell.lblInstructorName.text = "Unknown"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let instructor = self.instructors[indexPath.row]
        print("\(instructor) item clicked")
        let vc = self.getStoryboardWithIdentifier(identifier: "ClassDetailsViewController") as! ClassDetailsViewController
        vc.instructor = instructor
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
