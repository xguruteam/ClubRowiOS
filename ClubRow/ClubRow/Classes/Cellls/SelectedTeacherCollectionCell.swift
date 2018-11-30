//
//  SelectedTeacherCollectionCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/6/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit


protocol TeacherCollectionCellDelegate  : class {
    func clickedClassBtn(_ sender: SelectedTeacherCollectionCell)
    func clickedSelectBtn(_ sender: SelectedTeacherCollectionCell)
}

class SelectedTeacherCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var classNameLabel: UIButton!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var collectionCellView: UIView!
    
    weak var delegate:TeacherCollectionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowOn(view: self.collectionCellView)
        cornerRadiusOn(view: self.collectionCellView)
    }
    
    
    @IBAction func onClass(_ sender: Any) {
        delegate?.clickedClassBtn(self)
    }
    
    @IBAction func onSelect(_ sender: Any) {
        delegate?.clickedSelectBtn(self)
    }
    
    func cornerRadiusOn(view: UIView) {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 20
    }
    
    func shadowOn(view: UIView) {
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        //        view.layer.shouldRasterize = true
        view.layer.shadowOpacity = 0.16
        view.layer.shadowRadius = 4
        
        //        view.layer.masksToBounds = true
        
        //        view.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //        view.layer.shouldRasterize = true
        //        view.layer.rasterizationScale = UIScreen.main.scale
    }
}
