//
//  HomeViewModel.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/22/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

// A viewmodel for HomeViewController
import Foundation
import RxSwift
class HomeViewModel {
    // run callback methods after loadPhotos func completes
    weak var networkRequestDelegate: NetworkRequestDelegate?
    // the page number needs to be loaded more
    var currentPage: Int = 1
    let networkRequest: NetworkRequest
    // list of photos getting from calling api request
    var photos: [Photo] = []
    // handle life of reactivex
    let disposeBag = DisposeBag()
    // initial self HomeViewModel
    //
    // -parameter delegate: the parrent(viewcontroller) which implement NetworkRequestDelegate
    init(delegate: NetworkRequestDelegate?) {
        networkRequestDelegate = delegate
        networkRequest = NetworkRequest()
    }
    //call api request to get list of next page of photos
    func loadPhotos() {
        // query api request in other thread
        DispatchQueue.global(qos: .utility).async {[unowned self] in
            self.networkRequest.getPhotos(page: self.currentPage)
                .subscribe({[weak self] event in
                    switch event {
                    case .next(let list): // if success
                        if self != nil {
                            if let items = list {
                                self!.photos += items
                            } else {
                                // no more photos
                                // update table view in main thread (UI)
                                DispatchQueue.main.async { [weak self] in
                                  self?.networkRequestDelegate?.noMorePhotos()
                                }
                            }
                            // update table view in main thread (UI)
                            DispatchQueue.main.async { [weak self] in
                              self?.networkRequestDelegate?.loadPhotosSuccess()
                            }
                        }
                    case .error(let error): // if failed
                        // show error alert in main thread
                        DispatchQueue.main.async { [weak self] in
                            self?.networkRequestDelegate?.loadPhotosFailed(error: error as NSError)
                        }
                    default:
                        break
                    }
                })
                .disposed(by: self.disposeBag)
        }
    }
}
