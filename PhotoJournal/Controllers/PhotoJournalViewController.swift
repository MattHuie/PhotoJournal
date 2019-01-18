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
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photoJournal = PhotoJournalModel.getPhotoJournal()
        photoCollectionView.reloadData()
    }
    
    func reload() {
        photoJournal = PhotoJournalModel.getPhotoJournal()
        photoCollectionView.reloadData()
    }
    
    
    @IBAction func actionSheet(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            PhotoJournalModel.deletePhotoJournal(index: sender.tag)
            self.reload()
        }
        let editAction = UIAlertAction(title: "Edit", style: .default) { _ in
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "EditJournalVC") as? EditJournalViewController else { return }
            destinationViewController.modalPresentationStyle = .currentContext
            destinationViewController.photos = self.photoJournal[sender.tag]
            destinationViewController.photoIndex = sender.tag
            
            self.present(destinationViewController, animated: true, completion: nil)

        }
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            if let imageToShare = UIImage(data: self.photoJournal[sender.tag].imageData) {
                let shareText = self.photoJournal[sender.tag].description
                
                let activityViewController = UIActivityViewController(activityItems: [imageToShare,shareText], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(editAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
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
        cell.moreOptionsButton.tag = indexPath.row
        cell.photoImage.layer.cornerRadius = 8
        cell.photoImage.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        return cell
    }
    
    
}

extension PhotoJournalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 300, height: 400)
    }
}
