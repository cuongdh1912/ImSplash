//
//  PhotoCollectionViewCell.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/22/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// ColectionViewCell of a photo cell
import UIKit
import Kingfisher
class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    // awake from loading nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // round corner
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
    }
    func updateUI(photo: Photo?) {
        // check url is whether correct or not
        if let urlString = photo?.thumbUrl, let url = URL(string: urlString) {
            imageView?.kf.indicatorType = .activity
            // use kingfisher to load image with url
            imageView.kf.setImage(with: url)
        } else { // if url is null
            imageView?.image = UIImage(named: Common.placeHolder)
        }
    }
    
    func updateUIForDownload(photo: Photo?) {
        // check url is whether correct or not
        if let photo = photo, let progress = photo.progress {
            switch progress {
            case 0..<100:
                showPercentage(string: String(progress) + "%")
            case 100: // downloaded
                // display image
                showImage(photo)
            case -1:
                showPercentage(string: Common.downloadFailedText)
            default: do {}
                
            }
        } else { // if url is null
            imageView?.image = UIImage(named: Common.placeHolder)
        }
    }
    func showPercentage(string: String) {
        percentageLabel.text = string
        percentageLabel.isHidden = false
        imageView.isHidden = true
    }
    func showImage(_ photo: Photo) {
        percentageLabel.isHidden = true
        imageView.isHidden = false
        // load image
        updateUI(photo: photo)
    }
    
}
