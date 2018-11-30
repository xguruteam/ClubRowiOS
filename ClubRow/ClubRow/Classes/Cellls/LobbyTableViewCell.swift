//
//  LobbyTableViewCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/25/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

protocol SelectLobbyDelegate : class {
    func onSelectLobby(_index: Int)
}

class LobbyTableViewCell: UITableViewCell {

    weak var delegate:SelectLobbyDelegate?
    
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStartedAt: UILabel!
    @IBOutlet weak var btnSelectLobby: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onSelectLobby(_ sender: UIButton) {
        delegate?.onSelectLobby(_index: sender.tag)
    }
}
