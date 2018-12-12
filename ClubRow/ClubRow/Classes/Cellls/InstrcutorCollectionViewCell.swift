//
//  InstrcutorCollectionViewCell.swift
//  ClubRow
//
//  Created by Guru on 12/11/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class InstrcutorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblNumOfClasses: UILabel!
    @IBOutlet weak var lblInstructorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.16
        self.layer.shadowRadius = 4

        self.layer.cornerRadius = 20
        self.layer.masksToBounds = false
        
    }
}
