//
//  TeacherCell.swift
//  ClubRow
//
//  Created by Lucass Beck on 11/6/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

protocol ClassLobbyCellDelegate : class {
    func onJoinClass(_ sender_id: Int, _ isExistLobby: Bool)
}


class ClassLobbyCell: UITableViewCell {

    weak var delegate:ClassLobbyCellDelegate?
    weak var delegateForCollection:ClassLobbyCollectionCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    var liveClasses = [LiveClass]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ClassLobbyCell: ClassLobbyCollectionCellDelegate {
    func onJoinClassFromCollection(_ sender_id: Int, _ isExistLobby: Bool) {
        delegate?.onJoinClass(sender_id, isExistLobby)
    }
}

extension ClassLobbyCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassLobbyCollectionViewCell", for: indexPath) as! ClassLobbyCollectionViewCell
        
        let teacherInfo: NSDictionary = liveClasses[indexPath.row].teacher
        
        cell.teacherNameLabel.text = (teacherInfo.object(forKey: "name") as! String)
        cell.id = liveClasses[indexPath.row].id
        cell.classNameLabel.text = liveClasses[indexPath.row].name
        let start_at_origin: String = liveClasses[indexPath.row].start_at
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        let date = dateFormatter.date(from: start_at_origin)
        
        let targetDateFormatter = DateFormatter()
        targetDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let targetDate: String! = targetDateFormatter.string(from: date!)
        cell.timeLabel.text = targetDate
        cell.delegate = self
        if liveClasses[indexPath.row].lobby_id == -1 {
            cell.btnJoinClass.tag = -1
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.liveClasses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        NSLog("%f", collectionView.bounds.size.width)
        return CGSize(width: collectionView.bounds.size.width, height: 263.0)
    }
}
