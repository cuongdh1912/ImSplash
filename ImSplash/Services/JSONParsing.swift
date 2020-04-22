//
//  JSONParsing.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// Keys of json data
struct JSONKeys {
    static let photoId = "id"
    static let thumbUrl = "thumb"
    static let originUrl = "raw"
    static let urls = "urls"
    static let width = "width"
    static let height = "height"
}
// Parse json to data model
class JSONParsing {
    // a singleton instance
    static let shared = JSONParsing()
    // convert json array to a list of Photo
    //
    // -Parameter jsonArray: list of json object
    // -Returns: List of Photo
    func createPhotosByJSONArray(jsonArray: [[String: Any?]]) -> [Photo]{
        var photos: [Photo] = []
        for object in jsonArray {
            // get urls object
            if let urls = object[JSONKeys.urls] as? [String: String] {
                let photo = Photo()
                photo.photoId = object[JSONKeys.photoId] as? String
                photo.thumbUrl = urls[JSONKeys.thumbUrl]
                photo.originUrl = urls[JSONKeys.originUrl]
                if let width = object[JSONKeys.width] as? Float, let height = object[JSONKeys.height] as? Float {
                    photo.ratioHeightPerWidth = width / height
                }
                photos.append(photo)
            }
        }
        return photos
    }
}
