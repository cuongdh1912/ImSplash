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
    let disposeBag = DisposeBag() // handle the life of rxswift
    // download a photo to local
    //
    // -Parameter photo: a model Photo which has url for download
    // -Returns: progress in range 1...100 of downloading process
    func downloadPhoto(_ photo: Photo) -> Observable<Int> {
        // check data of photo is nil or not
        guard let photoId = photo.photoId, let urlString = photo.originUrl,
            let urlRequest = urlString.toURLRequest() else {
            // when photo data is not sufficent
            return Observable.create {observer in
                let error = Common.createError("Cannot download! Photo has not id or original link")
                observer.onError(error)
                return Disposables.create()
            }
        }
        // destination place for path of downloading file
        let destination: DownloadRequest.Destination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(photoId)                 
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let i: BehaviorRelay<Int> = BehaviorRelay<Int>.init(value: 2)        
        return Observable.create {[unowned self] observer in
            download(urlRequest, to: destination)
                 .map{request in
                     Observable<Int>.create{observer in
                         request.downloadProgress(closure: { (progress) in
                             observer.onNext(Int(progress.fractionCompleted * 100))
                             print(Float(progress.fractionCompleted))
                             if progress.isFinished{
                                 print("completed")
                                 observer.onCompleted()
                             }
                         })
                         return Disposables.create()
                     }
                 }
                .flatMap{$0}
                .bind(to: i)
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
}
