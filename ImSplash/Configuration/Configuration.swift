//
//  Configuration.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

struct Configuration {
    static let shared = Configuration()
    // The Unsplash API url.
    let apiURL = "https://api.unsplash.com/photos?"
    // access key
    let accessKey = "Wv0RsMRZcrJpkkSZF7OgadYOCL8xIm3ueUnSlLAlgVA"
    let headers: [String: String] = ["Authorization": "Client-ID Wv0RsMRZcrJpkkSZF7OgadYOCL8xIm3ueUnSlLAlgVA"]
    let pageParameter = "page"
    let perpageParameter = "per_page"
    let maxItemsPerPage = "20"
}
