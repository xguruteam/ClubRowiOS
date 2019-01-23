//
//  ClassTableViewController.swift
//  ClubRow
//
//  Created by gao on 10/16/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import XLSlidingContainer
//import Presentr

class ClassTableViewController: SuperViewController, ContainedViewController, UITableViewDataSource, UITableViewDelegate, ClassCellDelegate {

    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellClass") as! ClassCell
        cell.delegate = self
        return cell
    }
    
    func onViewClass(_ cell: ClassCell?) {
//        let controller = self.getStoryboardWithIdentifier(identifier: "DateFilterViewController") as! DateFilterViewController
//
//        let presenter: Presentr = {
//            let width = ModalSize.full
//            let height = ModalSize.fluid(percentage: 0.80)
//            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
//            let customType = PresentationType.custom(width: width, height: height, center: center)
//
//            let customPresenter = Presentr(presentationType: PresentationType.bottomHalf)
//            customPresenter.transitionType = .coverVertical
//            customPresenter.dismissTransitionType = .coverVerticalFromTop
//            customPresenter.roundCorners = false
//            customPresenter.backgroundColor = .clear
//            customPresenter.backgroundOpacity = 0.5
//            customPresenter.dismissOnSwipe = true
//            customPresenter.dismissOnSwipeDirection = .top
//            return customPresenter
//        }()
//
//        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.getStoryboardWithIdentifier(identifier: "ClassDetailsViewController") as! ClassDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func didMinimizeControllerWith(diff: CGFloat) {
        view.alpha = 1
        let currentOffset = tableview!.contentOffset.y
        tableview!
            .setContentOffset(
                CGPoint(
                    x: 0,
                    y: min(
                        diff + currentOffset,
                        max(
                            0,
                            tableview!.contentSize.height - view.frame.size.height
                        )
                )),
                animated: false)
    }
    
    func didMaximizeControllerWith(diff: CGFloat) {
        view.alpha = 1.0
        let currentOffset = tableview!.contentOffset.y
        tableview!
            .setContentOffset(
                CGPoint(
                    x: 0,
                    y: max(0, currentOffset - diff)),
                animated: false
        )
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
