//
//  SummaryViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/11/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import BmoViewPager
import CRRefresh
import MKProgress
import Alamofire
import SwiftyJSON

class SummaryViewController: SuperViewController {

    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var viewPagerSegmentedView: SegmentedView!
    @IBOutlet weak var viewPagerNavigationBar: BmoViewPagerNavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewControllers: [AverageViewController]! = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        
        
        var vc: AverageViewController
        vc = self.getStoryboardWithIdentifier(identifier: "AverageViewController") as! AverageViewController
        vc.type = "day"
        viewControllers.append(vc)
        vc = self.getStoryboardWithIdentifier(identifier: "AverageViewController") as! AverageViewController
        vc.type = "week"
        viewControllers.append(vc)
        vc = self.getStoryboardWithIdentifier(identifier: "AverageViewController") as! AverageViewController
        vc.type = "month"
        viewControllers.append(vc)
        vc = self.getStoryboardWithIdentifier(identifier: "AverageViewController") as! AverageViewController
        vc.type = "year"
        viewControllers.append(vc)

        viewPagerNavigationBar.viewPager = viewPager
        viewPagerNavigationBar.layer.masksToBounds = true
        viewPagerNavigationBar.layer.cornerRadius = viewPagerSegmentedView.layer.cornerRadius
        viewPager.presentedPageIndex = 0
        viewPager.infinitScroll = true
        viewPager.dataSource = self
        
        
        self.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            MKProgress.show()
            
            for vc in (self?.viewControllers)! {
                vc.reloadData()
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                self?.tableView.cr.endHeaderRefresh()
                MKProgress.hide()
            })
            
        }
        
//        MKProgress.show()
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
//            MKProgress.hide()
//        }
        self.tableView.cr.beginHeaderRefresh()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)

    }
    
    @IBAction func onSegmenChange(_ sender: Any) {
//        pagerControl.currentPage = segmentControl.selectedSegmentIndex
    }
    
    @IBAction func onback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

extension SummaryViewController: BmoViewPagerDataSource {
    // Optional
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.foregroundColor : viewPagerSegmentedView.strokeColor
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
    }
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        switch page {
        case 0:
            return "D"
        case 1:
            return "W"
        case 2:
            return "M"
        default:
            return "Y"
        }
    }
    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        return CGSize(width: navigationBar.bounds.width / 4, height: navigationBar.bounds.height)
    }
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = viewPagerSegmentedView.strokeColor
        return view
    }
    
    // Required
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return viewControllers.count
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        return viewControllers[page]
    }
}
