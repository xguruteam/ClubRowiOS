//
//  SummaryViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/11/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class SummaryViewController: SuperViewController {

    @IBOutlet weak var pagerControl: UIPageControl!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)

    }
    
    @IBAction func onSegmenChange(_ sender: Any) {
        pagerControl.currentPage = segmentControl.selectedSegmentIndex
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
