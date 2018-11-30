//
//  TeacherCollectionViewCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/19/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

protocol NonSelectedTeacherCollectionCellDelegate : class {
    func clickedEditBtn(_ sender_id: Int)
}

class TeacherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    
    @IBOutlet weak var teacherView: UIView!
    
    weak var delegate:NonSelectedTeacherCollectionCellDelegate?
    
    var id: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowOn(view: self.teacherView)
        cornerRadiusOn(view: self.teacherView)
    }
    
    @IBAction func onJoinClass(_ sender: Any) {
        delegate?.clickedEditBtn(self.id)
    }
    
    func shadowOn(view: UIView) {
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.16
        view.layer.shadowRadius = 4
    }
    
    func cornerRadiusOn(view: UIView) {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 20
    }
}


