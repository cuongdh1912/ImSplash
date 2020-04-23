//
//  Common.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import Foundation
class Common {
    static let placeHolder = "placeholder"
    static let photoStoryboardId = "PhotoViewController"
    static let collectionStoryboardId = "CollectionViewController"
    static let maxProgress = 100
    static let downloadFailedProgress = -1
    static let downloadFailedText = "Downloading Failed!"
    // generate NSError object with error code & message
    static func createError(_ message: String?) -> NSError {
        return NSError(domain:"", code: 401, userInfo: [NSLocalizedDescriptionKey: message ?? ""])
    }
    // load image from local
    static func loadLocalImage(photo: Photo) -> Data? {
        var imageData:Data? = nil
        let fileManagerDefault = FileManager.default
        // load image
        let documentsURL = fileManagerDefault.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(photo.photoId)
        // check image is existing
        guard fileManagerDefault.fileExists(atPath: fileURL.path) else {
            return nil
        }
        do {
            imageData = try Data.init(contentsOf: fileURL)
        } catch {
            print(error.localizedDescription)
        }
        return imageData
    }
}
