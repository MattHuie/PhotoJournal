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
    private var originalImage: UIImage!
    var placeholderText = "Description"
    var photos: PhotoJournal!
    var photoIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
        if let photos = photos {
            imageView.image = UIImage(data:photos.imageData)
            originalImage = imageView.image
            descriptionView.text = photos.description
            descriptionView.textColor = .black
        } else {
            originalImage = imageView.image
            setupUI()
        }
        
    }
    private func setupUI() {
        descriptionView.delegate = self
        descriptionView.text = placeholderText
        descriptionView.textColor = .lightGray
    }
    
    private func setupImage() {
        imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
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
    
    @IBAction func resignKeyboard(_ sender: UIButton) {
        descriptionView.resignFirstResponder()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let index = photoIndex {
            PhotoJournalModel.deletePhotoJournal(index: index)
        }
        guard let photoDescription = descriptionView.text else { fatalError("title or description is nil") }
        let date = Date()
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate,
                                          .withFullTime,
                                          .withInternetDateTime,
                                          .withTimeZone,
                                          .withDashSeparatorInDate]
        let timestamp = isoDateFormatter.string(from: date)
        
        if let imagedata = originalImage?.jpegData(compressionQuality: 0.5) {
            let photoPost = PhotoJournal.init(createdAt: timestamp, imageData: imagedata, description: photoDescription)
            PhotoJournalModel.addPhotoJournal(photoPost: photoPost)
            PhotoJournalModel.savePhotoJournal()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension EditJournalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            originalImage = image
        } else {
            print("original image is nil")
        }
        dismiss(animated: true, completion: nil)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
}
