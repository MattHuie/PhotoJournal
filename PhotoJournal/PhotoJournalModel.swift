//
//  PhotoJournalModel.swift
//  PhotoJournal
//
//  Created by Matthew Huie on 1/14/19.
//  Copyright © 2019 Matthew Huie. All rights reserved.
//

import Foundation

final class PhotoJournalModel {
    static let filename = "PhotoList.plist"
    private static var photoJournal = [PhotoJournal]()
    
    private init() {}
    
    static func savePhotoJournal() {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(photoJournal)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("property list encoding error")
        }
    }
    
    static func getPhotoJournal() -> [PhotoJournal] {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    photoJournal = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
                } catch {
                    print("getPhotoJournal - property list decoding error")
                }
            } else {
                print("getPhotoJournal - data is nil")
            }
        } else {
            print("getPhotoJournal - \(filename) does not exist")
        }
        photoJournal = photoJournal.sorted {$0.date > $1.date}
        return photoJournal
    }
    
    static func addPhotoJournal(photoPost: PhotoJournal) {
        photoJournal.append(photoPost)
        savePhotoJournal()
    }
    
}
