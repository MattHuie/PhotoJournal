//
//  EditJournalViewController.swift
//  PhotoJournal
//
//  Created by Matthew Huie on 1/14/19.
//  Copyright © 2019 Matthew Huie. All rights reserved.
//

import UIKit

class EditJournalViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    
    private var imagePickerView: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
        //updateUI()

     
    }
//    private func updateUI() {
//        if let photoJournal = PhotoJournalModel.getPhotoJournal() {
//            let image = UIImage(data: photoJournal.imageData)
//            imageView.image = image
//        } else {
//            print("photo journal does not exist")
//        }
//    }
    
    private func setupImage() {
        imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }
    }
    
    private func savePhotoJournal(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let photoJournal = PhotoJournal.init(createdAt: "date", imageData: imageData, description: "cool wallpaper")
            PhotoJournalModel.savePhotoJournal(photoJournal: photoJournal)
        }
    }
    
    private func showImagePickerController() {
        present(imagePickerView, animated: true, completion: nil)
    }


    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func photoLibraryButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerView.sourceType = .photoLibrary
        showImagePickerController()
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerView.sourceType = .camera
        showImagePickerController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
}

extension EditJournalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            savePhotoJournal(image: image)
        } else {
            print("original image is nil")
        }
        dismiss(animated: true, completion: nil)
    }
}
