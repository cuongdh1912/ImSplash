//
//  NetworkRequest.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
import Foundation
import RxSwift
import RxAlamofire
import Alamofire
class NetworkRequest {
    let disposeBag = DisposeBag() // handle the life of rxswift
    // get photos with page
    func getPhotos(page: Int)  -> Observable<[Photo]> {
        let urlString: String = Configuration.shared.apiURL
        let parameters: [String: Any] = [Configuration.shared.pageParameter: page]
        return doQuerying(urlString: urlString, parameters: parameters)
    }
    // query api to get all news with urlString & parameters
    func doQuerying(urlString: String, parameters: [String: Any]) -> Observable<[Photo]> {
        // call get api with url
        let headers: HTTPHeaders = HTTPHeaders(Configuration.shared.headers)
        return Observable.create {[unowned self] observer in
            RxAlamofire.requestJSON(.get, urlString, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .subscribe(onNext: {(r, json) in // if smt responds
                    let message = "Get photos failded! Please try again"
                    if let jsonPhotos = json as? [[String: Any]] {
                        let photosList = JSONParsing.shared.createPhotosByJSONArray(jsonArray: jsonPhotos)
                        observer.onNext(photosList)
                    } else if let _ = json as? String { // over limitation
                        observer.onNext([])
                    } else {
                        let error = Common.createError(message)
                        observer.onError(error)
                    }
                }, onError: { error in // if error
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

