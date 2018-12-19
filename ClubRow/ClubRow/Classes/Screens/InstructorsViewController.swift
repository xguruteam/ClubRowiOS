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
