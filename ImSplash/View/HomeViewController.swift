//
//  ViewController.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// Display home view
import UIKit
import AVFoundation
class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView?
    let collectionCellId = "CollectionCellId"
    let loadMoreCellId = "LoadMoreCellId"
    var homeViewModel: HomeViewModel?
    weak var activityDelegate: ActivityDelegate?
    // initialize HomeViewModel then call loadPhotos func
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel = HomeViewModel(delegate: self)
        homeViewModel?.loadPhotos()
        if let twoColumnLayout = collectionView?.collectionViewLayout as? TwoColumnsLayout {
            twoColumnLayout.delegate = self
        }
    }
    // Show collection screen
    @IBAction func downloadButtonTouch(_ sender: Any) {
        // get collection view controller
        if let vc = Router.getViewControllerWithId(Common.collectionStoryboardId) as? CollectionViewController {
            // get downloaded/downloading photos
            vc.downloadPhotos = homeViewModel?.getDownloadPhotos()
            present(vc, animated: false, completion: nil)
        }
    }
}
// MARK: --NetworkRequestDelegate
// implement all protocol methods of NetworkRequestDelegate
extension HomeViewController: NetworkRequestDelegate {
    // refresh collection view
    func refreshCollectionView() {
        // refresh collection view
        collectionView?.reloadData()
        activityDelegate?.hideActivityIndicator()
    }
    // if load Photos succeeds
    func loadPhotosSuccess() {
        refreshCollectionView()
    }
    
    // if load Photos fails
    func loadPhotosFailed(error: NSError) {
        DispatchQueue.main.async { [weak self] in
            self?.activityDelegate?.hideActivityIndicator()
            Router.showAlert(message: error.localizedDescription, parrent: self)
        }
    }
}
// MARK: --CollectionView Datasrouce
extension HomeViewController: UICollectionViewDataSource {
    // return total number of section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let num = homeViewModel?.numberOfSection() ?? 0
        return num
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return homeViewModel?.numberOfPhotos() ?? 0
        } else if section == 1 {
            if let _ = homeViewModel?.numberOfPhotos() {
                return 1
            } else {
                return 0
            }
        }
        return 0
    }
    // generate cell for row at index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellId, for: indexPath as IndexPath) as? PhotoCollectionViewCell {
                cell.updateUI(photo: homeViewModel?.getPhoto(index: indexPath.row))
                return cell
            }
        }
        else if indexPath.section == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loadMoreCellId, for: indexPath as IndexPath) as? LoadMoreCollectionViewCell {
                cell.loadMoreDelegate = self
                self.activityDelegate = cell
                return cell
            }
        }
        return UICollectionViewCell()
    }
}
// MARK: --CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // open photo view
            if let vc = Router.getViewControllerWithId(Common.photoStoryboardId) as? PhotoViewController {
                vc.photo = homeViewModel?.getPhoto(index: indexPath.row)
                present(vc, animated: false, completion: nil)
            }
        }
    }
}
// MARK: --TwoColumnsLayoutDelegate
extension HomeViewController: TwoColumnsLayoutDelegate {
    // call to get ratio height per width of photo
    func getPhotoRatioHeightPerWidth(indexPath: IndexPath) -> Float? {
        return homeViewModel?.getPhotoRatioHeightPerWidth(index: indexPath.row)
    }
}
// MARK: --LoadMoreDelegate
extension HomeViewController: LoadMoreDelegate {
    func loadMoreButtonTouch() {
        homeViewModel?.loadPhotos()
    }
}
// MARK: --ProgressDelegate
extension HomeViewController: ProgressDelegate {
    func findPhotoInList(_ photo: Photo) -> Photo? {
        // find photo in photos list
        if let photos = homeViewModel?.photos {
            if let downloadedPhoto = photos.first(where: { $0.photoId == photo.photoId}) {
                return downloadedPhoto
            }
        }
        return nil
    }
    // update progress status
    func updateProgress(photo: Photo) {
        // find photo in photos list
        if let downloadedPhoto = findPhotoInList(photo) {
            downloadedPhoto.progress = photo.progress
        }
    }
    func downloadingFailed(photo: Photo) {
        // hide download button, show progress view
        updateProgress(photo: photo)
    }
}
