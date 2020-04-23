//
//  NetworkRequestDelegate.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/22/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// List of callback methods are fired after a request completes
import Foundation
protocol NetworkRequestDelegate: class {
    // call if query succeeds
    func loadPhotosSuccess()
    // call if query fails
    func loadPhotosFailed(error: NSError)
}
