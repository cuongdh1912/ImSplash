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
    // generate NSError object with error code & message
    static func createError(_ message: String?) -> NSError {
        return NSError(domain:"", code: 401, userInfo: [NSLocalizedDescriptionKey: message ?? ""])
    }
}
