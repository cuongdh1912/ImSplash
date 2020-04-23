//
//  PhotoViewModel.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/23/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// ViewModel of PhotoViewController
import Foundation
class PhotoViewModel {
    // download photo in background thread
    func downloadPhoto(photo: Photo?) {
        guard let photo = photo else { return }
        DispatchQueue.global(qos: .background).async {
            PhotoDownloader.shared.downloadPhoto(photo);
        }
    }
}
