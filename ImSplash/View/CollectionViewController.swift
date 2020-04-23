//
//  CollectionViewController.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit
class CollectionViewController: UIViewController {
    // link to collection view
    @IBOutlet weak var collectionView: UICollectionView!
    // reused id of collection view cell
    let collectionCellId = "DownloadCellId"
    // list of downloaded/downloading photos
    var downloadPhotos: [Photo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // asign delegate for collectionView?.collectionViewLayout
        if let twoColumnLayout = collectionView?.collectionViewLayout as? TwoColumnsLayout {
            twoColumnLayout.delegate = self
        }
        // display photo on collection view
        collectionView.reloadData()
    }
    // dismiss self
    @IBAction func xButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: --CollectionView Datasrouce
extension CollectionViewController: UICollectionViewDataSource {
    // number of item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadPhotos?.count ?? 0
    }
    // generate cell for row at index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellId, for: indexPath as IndexPath) as? PhotoCollectionViewCell {
                // upade ui of cell
                cell.updateUIForDownload(photo: downloadPhotos?[indexPath.row])
                return cell
            }
        }
        return UICollectionViewCell()
    }
}
// MARK: --CollectionView Delegate
extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // open photo view
            if let vc = Router.getViewControllerWithId(Common.photoStoryboardId) as? PhotoViewController {
                vc.photo = downloadPhotos?[indexPath.row]
                present(vc, animated: false, completion: nil)
            }
        }
    }
}
// MARK: --TwoColumnsLayoutDelegate
extension CollectionViewController: TwoColumnsLayoutDelegate {
    // call to get ratio height per width of photo
    func getPhotoRatioHeightPerWidth(indexPath: IndexPath) -> Float? {
        // open if photo was downloaded completely
        if let downloadPhotos = downloadPhotos, indexPath.row < downloadPhotos.count,
            let progress = downloadPhotos[indexPath.row].progress, progress >= Common.maxProgress
        {
            return downloadPhotos[indexPath.row].ratioHeightPerWidth
        }
        return 1
    }
}
// MARK: --ProgressDelegate
extension CollectionViewController: ProgressDelegate {
    // get index paths of visible cells
    func getVisibleCell() -> [IndexPath]? {
        return collectionView.indexPathsForVisibleItems
    }
    func findVisibleIndexPath(has photo: Photo) -> IndexPath? {
        // get index paths of visible cells
        if let visibleIndexPath = getVisibleCell() {
            // find visible cell which displays photo
            for indexPath in visibleIndexPath {
                if let photoId = downloadPhotos?[indexPath.row].photoId, photoId == photo.photoId {
                    // update progress
                    return indexPath
                }
            }
        }
        return nil
    }
    // update progress status on cell
    func updateProgress(photo: Photo) {
        if let indexPath = findVisibleIndexPath(has: photo) {
            // update progress
            collectionView.reloadItems(at: [indexPath])
            downloadPhotos![indexPath.row].progress = photo.progress
        }
    }
    // when downloading a photo is failed
    func downloadingFailed(photo: Photo) {
        // update failed status
        updateProgress(photo: photo)
    }
}
