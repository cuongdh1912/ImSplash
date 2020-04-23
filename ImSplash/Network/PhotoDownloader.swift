//
//  PhotoDownloader.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// Download photo with url link

import RxAlamofire
import Alamofire
import RxSwift
import RxCocoa
import Foundation
class PhotoDownloader {
    // singleton instance to make sure there is a unique instance do all downloading process
    static var shared = PhotoDownloader()
    let disposeBag = DisposeBag() // handle the life of rxswift
    // download a photo to local
    //
    // -Parameter photo: a model Photo which has url for download
     func downloadPhoto(_ photo: Photo) {
        // check data of photo is nil or not
        guard let photoId = photo.photoId, let urlString = photo.originUrl,
            let urlRequest = urlString.toURLRequest() else {
            // when photo data is not sufficent
            return
        }
        // destination place for path of downloading file
        let destination: DownloadRequest.Destination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            // photo id is file name
            let fileURL = documentsURL.appendingPathComponent(photoId)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        // start downloading
        RxAlamofire.download(urlRequest, to: destination)
        .subscribe(onNext: { element in
            element.downloadProgress(closure: { progress in
                let currentProgress = Int(progress.fractionCompleted * (Double)(Common.maxProgress))
                let photoProgress = photo.progress ?? -1
                if currentProgress != photoProgress {
                    photo.progress = currentProgress
                    if let currentVC = Router.getCurrentViewController() as? ProgressDelegate {
                        DispatchQueue.main.async {
                            currentVC.updateProgress(photo: photo)
                        }
                    }
                }
            })
        }, onError: { error in
            if let currentVC = Router.getCurrentViewController() as? ProgressDelegate {
                photo.progress = Common.downloadFailedProgress
                DispatchQueue.main.async {
                    currentVC.downloadingFailed(photo: photo)
                }
            }
        }, onCompleted: {
            photo.progress = Common.maxProgress
            if let currentVC = Router.getCurrentViewController() as? ProgressDelegate {
                DispatchQueue.main.async {
                    currentVC.updateProgress(photo: photo)
                }
            }
        }).disposed(by: self.disposeBag)
    }
}
