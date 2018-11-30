//
//  TeacherCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/6/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

protocol TeacherCellDelegate : class {
    func clickedEditBtn(_ sender_id: Int)
}


class TeacherCell: UITableViewCell {

    weak var delegate:TeacherCellDelegate?
    weak var delegateForCollection:NonSelectedTeacherCollectionCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    var teachers = [Teacher]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func onJoinClass(_ sender_id: Int) {
        delegate?.clickedEditBtn(sender_id as Int)
    }
    
    
}

extension TeacherCell: NonSelectedTeacherCollectionCellDelegate {
    func clickedEditBtn(_ sender_id: Int) {
        delegate?.clickedEditBtn(sender_id)
    }
}

extension TeacherCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeacherCollectionViewCell", for: indexPath) as! TeacherCollectionViewCell
        cell.teacherNameLabel.text = "Nate Morris(id=\(teachers[indexPath.row].id))"
        cell.id = teachers[indexPath.row].id
        
        cell.delegate = self
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.teachers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        NSLog("%f", collectionView.bounds.size.width)
        return CGSize(width: collectionView.bounds.size.width, height: 263.0)
    }
}
