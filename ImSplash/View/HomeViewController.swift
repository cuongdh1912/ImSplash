//
//  ViewController.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// Display home view
import UIKit
class HomeViewController: UIViewController {
    var homeViewModel: HomeViewModel?
    // initialize HomeViewModel then call loadPhotos func
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel = HomeViewModel(delegate: self)
        homeViewModel?.loadPhotos()
    }
}
// MARK: -- NetworkRequestDelegate
// implement all protocol methods of NetworkRequestDelegate
extension HomeViewController: NetworkRequestDelegate {
    // if load Photos succeeds
    func loadPhotosSuccess() {
        // refresh collection view
    }
    
    func noMorePhotos() {
        
    }
    // if load Photos fails
    func loadPhotosFailed(error: NSError) {
        
    }
}
