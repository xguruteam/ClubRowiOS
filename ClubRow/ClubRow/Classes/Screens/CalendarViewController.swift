//
//  CalendarViewController.swift
//  ClubRow
//
//  Created by gao on 10/15/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftEntryKit
import XLSlidingContainer

class CalendarViewController: SuperViewController, FSCalendarDelegate, ContainedViewController {

    @IBOutlet var viewCalendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setRoundView(radius: 10.0, view: viewCalendar)
        viewCalendar.delegate = self
        
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        SwiftEntryKit.dismiss()
    }

    func didMinimizeControllerWith(diff: CGFloat) {
        view.alpha = 0.2
    }

    func didMaximizeControllerWith(diff: CGFloat) {
        view.alpha = 1.0
    }
    
    /*
    // MARK: - Navigation
     viewContainer

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
