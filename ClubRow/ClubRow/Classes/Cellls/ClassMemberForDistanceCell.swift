//
//  ClassMemberForDistanceCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/8/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class ClassMemberForDistanceCell: UITableViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var viewForBackPlayerList: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
