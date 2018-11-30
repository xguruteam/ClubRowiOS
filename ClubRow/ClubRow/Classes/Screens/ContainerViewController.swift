//
//  ContainerViewController.swift
//  ClubRow
//
//  Created by gao on 10/16/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import XLSlidingContainer

class ContainerViewController: SlidingContainerViewController, SlidingContainerDelegate, SlidingContainerPresenter {
    override func viewDidLoad() {
        presenter = self
        delegate = self
        dragView = Bundle.main.loadNibNamed("DragView", owner: self, options: nil)?.first as? UIView
        
        super.viewDidLoad()
    }
    
    let movementType: MovementType = .push
    
    func lowerController(
        for slidingContainer: SlidingContainerViewController
        ) -> ContainedViewController {
//        let collectionViewLayout = UICollectionViewFlowLayout()
//        collectionViewLayout.itemSize = CGSize(width: 90, height: 60)
//        collectionViewLayout.scrollDirection = .vertical
//        collectionViewLayout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
//        collectionViewLayout.minimumLineSpacing = 15
//        let controller = CollectionViewController(collectionViewLayout:collectionViewLayout)
//        return controller as ContainedViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ClassTableViewController")
        return controller as! ContainedViewController
    }
    
    func upperController(
        for slidingContainer: SlidingContainerViewController
        ) -> ContainedViewController {
//        let viewController = ScrollViewController()
//        return viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CalendarViewController")
        return controller as! ContainedViewController
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellClass") as! ClassCell
//        cell.delegate = self
//        return cell
//    }
    
    
    @IBOutlet var tableview: UITableView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
