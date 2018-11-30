//
//  SelectedTeacherCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/6/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class SelectedTeacherCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SelectedTeacherCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedTeacherCollectionCell", for: indexPath) as! SelectedTeacherCollectionCell
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = self.getStoryboardWithIdentifier(identifier: "ClassDetailsViewController") as! ClassDetailsViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}

extension SelectedTeacherCell:  TeacherCollectionCellDelegate {
    func clickedClassBtn(_ sender: SelectedTeacherCollectionCell) {
        print("clickedClassBtn")
        // go to Video Class
    }
    
    func clickedSelectBtn(_ sender: SelectedTeacherCollectionCell) {
        print("clickedSelectBtn")
        // selected as a featured
    }
    
    
}


