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
    @IBOutlet weak var viewHeader: UIView!
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onCreate(_ sender: Any) {
        print("onCreate")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView?.backgroundColor = .clear
        tableView?.contentInset = UIEdgeInsets(top: 23, left: 0, bottom: 10, right: 0)
        self.viewHeader.makeBox()
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

extension LobbiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LobbyTableViewCell", for: indexPath) as! LobbyTableViewCell
        cell.lblMembers.text = "\(indexPath.row)"
        if indexPath.row > 5 {
            cell.lblName.text = "Dillon's Lobby"
            cell.lblStatus.text = "Accepting Participants"
        }
        else {
            cell.lblName.text = "Nate's Hip Hop Class"
            cell.lblStatus.text = "Lobby Started"

        }
        cell.btnSelectLobby.tag = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension LobbiesViewController: SelectLobbyDelegate {
    func onSelectLobby(_index: Int) {
        print("\(_index) lobby selected")
    }
}
