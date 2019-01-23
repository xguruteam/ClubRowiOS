//
//  DeviceCell.swift
//  ClubRow
//
//  Created by Guru on 1/22/19.
//

import UIKit

class DeviceCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    var action: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerView.makeBox()
    }

    @IBAction func onConnect(_ sender: Any) {
        guard let _ = self.action else {
            return
        }
        
        self.action!(self.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
