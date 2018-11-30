//
//  DescriptionCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/15/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

protocol DescriptionCellDelegate: class {
    func didChangeDescription(_  sender: DescriptionCell)
}
//protocol TeacherCellDelegate : class {
//    func clickedEditBtn(_ sender: TeacherCell)
//}

class DescriptionCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    var delegate: DescriptionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        delegate?.didChangeDescription(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
