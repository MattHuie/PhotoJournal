//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Matthew Huie on 1/14/19.
//  Copyright © 2019 Matthew Huie. All rights reserved.
//

import UIKit

class PhotoJournalViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photoJournal = PhotoJournalModel.getPhotoJournal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(DataPersistenceManager.documentsDirectory())
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photoCollectionView.reloadData()
        photoJournal = PhotoJournalModel.getPhotoJournal()
    }


}

extension PhotoJournalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoJournal.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoJournalCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        let photoToSet = photoJournal[indexPath.row]
        cell.photoImage.image = UIImage(data: photoToSet.imageData)
        cell.titleLabel.text = photoToSet.description
        cell.timestampLabel.text = photoToSet.dateFormattedString
        
        return cell
    }
    
    
}

extension PhotoJournalViewController: UICollectionViewDelegateFlowLayout {
    
}
