//
//  Common.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import Foundation

class Common {
    // generate NSError object with error code & message
    static func createError(_ message: String?) -> NSError {
        return NSError(domain:"", code: 401, userInfo: [NSLocalizedDescriptionKey: message ?? ""])
    }
}
