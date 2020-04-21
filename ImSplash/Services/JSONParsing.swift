//
//  JSONParsing.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

struct JSONKeys {
    static let photoId = "id"
    static let thumbUrl = "thumb"
    static let originUrl = "raw"
    static let urls = "urls"
}
class JSONParsing {
    static let shared = JSONParsing()
    func createPhotosByJSONArray(jsonArray: [[String: Any?]]) -> [Photo]{
        var photos: [Photo] = []
        for object in jsonArray {
            if let urls = object[JSONKeys.urls] as? [String: String] {
                let photo = Photo()
                photo.photoId = object[JSONKeys.photoId] as? String
                photo.thumbUrl = urls[JSONKeys.thumbUrl]
                photo.originUrl = urls[JSONKeys.originUrl]
                photos.append(photo)
            }
        }
        return photos
    }
}
