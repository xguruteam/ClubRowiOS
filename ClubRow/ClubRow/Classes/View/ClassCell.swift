//
//  CellClass.swift
//  ClubRow
//
//  Created by Luccas on 10/7/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

@objc protocol ClassCellDelegate {
    
    @objc optional func onViewClass(_ cell: ClassCell)
    
}

class ClassCell: UITableViewCell {
    
    var delegate:ClassCellDelegate?
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblNameOfClass: UILabel!
    @IBOutlet weak var lblInstructorName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var ivSubscriptionStatus: UIImageView!
    @IBOutlet weak var btSubscribe: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = 20
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        //        view.layer.shouldRasterize = true
        cardView.layer.shadowOpacity = 0.16
        cardView.layer.shadowRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onViewClass(_ sender: Any) {
        if delegate != nil {
            delegate?.onViewClass!(self)
        }
    }
    
}
