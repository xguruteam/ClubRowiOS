//
//  TeacherCollectionViewCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/19/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

protocol ClassLobbyCollectionCellDelegate : class {
    func onJoinClassFromCollection(_ sender_id: Int, _ isExistLobby: Bool)
}

class ClassLobbyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    
    @IBOutlet weak var btnJoinClass: UIButton!
    @IBOutlet weak var teacherView: UIView!
    
    weak var delegate:ClassLobbyCollectionCellDelegate?
    
    var id: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowOn(view: self.teacherView)
        cornerRadiusOn(view: self.teacherView)
    }
    
    @IBAction func onJoinClass(_ sender: UIButton) {
        
        delegate?.onJoinClassFromCollection(self.id, sender.tag != -1)
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


