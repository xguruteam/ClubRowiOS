//
//  LobbiesViewController.swift
//  ClubRow
//
//  Created by Guru on 12/12/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class LobbiesViewController: SuperViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView?.backgroundColor = .clear
        tableView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
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
