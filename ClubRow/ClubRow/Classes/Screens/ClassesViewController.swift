//
//  ClassesViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/2/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import Presentr
import Device

class ClassesViewController: SuperViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var classesTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassesCell") as! ClassesCell
        cell.delegate = self
        return cell;
    }
    
    @IBAction func onFilter(_ sender: Any) {
        let controller = self.getStoryboardWithIdentifier(identifier: "SortFilterViewController") as! SortFilterViewController
        
        let presenter: Presentr = {
            let width = ModalSize.full
            let height = ModalSize.fluid(percentage: 0.80)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
            _ = PresentationType.custom(width: width, height: height, center: center)
            
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
    
    @IBOutlet var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // shadow
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleView.layer.shadowOpacity = 0.07
        titleView.layer.shadowRadius = 3
        
        classesTableView.delegate = self
        classesTableView.dataSource = self
        

        // Do any additional setup after loading the view.
        
//        let string = UIDevice().modelName
//        let start = String.Index(encodedOffset: 6)
//        let end = String.Index(encodedOffset: 8)
//        let substring = String(string[start..<end])
//        print(substring)
//
//        if substring == "10" {
//            top.constant = 44
//        } else {
//            top.constant = 0
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func resizeTopView() {
        switch "\(Device.version())" {
        case "simulator":
            let string = UIDevice().modelName
            let start = String.Index(encodedOffset: 6)
            let end = String.Index(encodedOffset: 8)
            let substring = String(string[start..<end])
            print(substring)
            
            if substring == "10" {
                top.constant = 44
            } else {
                top.constant = 0
            }
        case "iPhoneX":
            top.constant = 44
        case "iPhoneXS":
            top.constant = 44        case "iPhoneXS_Max":
            top.constant = 44
        case "iPhoneXR":
            top.constant = 44
        default:
            top.constant = 0
            print("unkown")
        }
    }
}

extension ClassesViewController: ClassesCellDelegate {
    func clickedViewClassesBtn(_ sender: ClassesCell) {
        let vc = self.getStoryboardWithIdentifier(identifier: "ClassDetailsViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


