//
//  EditCell.swift
//  socket_client
//
//  Created by Lucass Beck on 11/3/18.
//  Copyright © 2018 Lucass Beck. All rights reserved.
//

import UIKit

protocol EditCellDelegate : class {
    func clickedEditBtn(_ sender: EditCell)
}

class EditCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var editBtn: UIButton!
    
    weak var delegate: EditCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onConnectToSocket(_ sender: UIButton) {
        delegate?.clickedEditBtn(self)
   }
}
