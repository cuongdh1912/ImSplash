//
//  NetworkRequest.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// Rest Full API request
import Foundation
import RxSwift
import RxAlamofire
import Alamofire
class NetworkRequest {
    let disposeBag = DisposeBag() // handle the life of rxswift
    // get photos with page
    //
    // -Parameter page: current page number needs request
    // -Returns: observable of Photo list
    func getPhotos(page: Int)  -> Observable<[Photo]?> {
        // generate url with page & per_page values
        var urlString: String = Configuration.shared.apiURL
        urlString += Configuration.shared.pageParameter + "=" + String(page)
        urlString += "&"+Configuration.shared.perpageParameter + "=" + Configuration.shared.maxItemsPerPage
        // generate headers with access key
        let headers: HTTPHeaders = HTTPHeaders(Configuration.shared.headers)
        // call get api with url
        return Observable.create {[unowned self] observer in
            RxAlamofire.requestJSON(.get, urlString, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .subscribe(onNext: {(r, json) in // if something responds
                    let message = "Get photos failded! Please try again"
                    if let jsonPhotos = json as? [[String: Any]] { // data formation is correct
                        let photosList = JSONParsing.shared.createPhotosByJSONArray(jsonArray: jsonPhotos)
                        observer.onNext(photosList)
                    } else { // error happens
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

