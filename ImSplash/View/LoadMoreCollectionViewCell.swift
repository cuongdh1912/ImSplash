//
//  LoadMoreCollectionViewCell.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/22/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// handle load more cell
import UIKit
class LoadMoreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // use delegate to trigger method when button load more is touched
    weak var loadMoreDelegate: LoadMoreDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.isHidden = true
    }
    // load more button touched
    @IBAction func loadMoreButtonTouch(_ sender: Any) {
        // call delegate's method
        loadMoreDelegate?.loadMoreButtonTouch()
        // hide load more button
        loadMoreButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
}
// MARK: --ActivityDelegate
extension LoadMoreCollectionViewCell: ActivityDelegate {
    func hideActivityIndicator() {
        // show load more button
        loadMoreButton.isHidden = false
        activityIndicator.isHidden = true
        // stop activity indicator
        activityIndicator.stopAnimating()
    }
}
