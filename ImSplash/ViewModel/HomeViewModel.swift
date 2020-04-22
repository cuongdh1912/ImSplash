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
    var needLoadMore = true
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
                .subscribe({[unowned self] event in
                    switch event {
                    case .next(let list): // if success
                        if let items = list { // if there are some photos
                            self.photos += items
                            // increase page
                            self.currentPage += 1
                            // update table view in main thread (UI)
                            DispatchQueue.main.async { [weak self] in
                              self?.networkRequestDelegate?.loadPhotosSuccess()
                            }
                        } else { // no more photos
                            self.needLoadMore = false
                            // update table view in main thread (UI)
                            DispatchQueue.main.async { [weak self] in
                              self?.networkRequestDelegate?.noMorePhotos()
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
// MARK: --UICollectionView delegate
extension HomeViewModel {
    // get number of section
    func numberOfSection() ->Int {
        if photos.count > 0 {
            return needLoadMore ? 2 : 1
        } else { // if there is no photo
            return 1
        }
    }
    // get number of photos
    func numberOfPhotos() -> Int {
        return photos.count
    }
    // get photo at index
    func getPhoto(index: Int) -> Photo? {
        if index < photos.count { // if in photos's range
            return photos[index]
        } else { // if out of index range
            return nil
        }
    }
    // Get ratioHeightPerWidth of photos[index]
    //
    // -Parameter index: index of photos
    func getPhotoRatioHeightPerWidth(index: Int) -> Float? {
        if index < photos.count { // if in photos's range
            return photos[index].ratioHeightPerWidth
        } else { // if out of index range
            return nil
        }
    }
}
