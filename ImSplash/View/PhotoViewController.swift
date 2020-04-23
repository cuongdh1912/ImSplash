//
//  PhotoViewController.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit
import Kingfisher
class PhotoViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var downloadButton: UIButton!
    var photo: Photo?
    lazy var photoViewModel: PhotoViewModel? = PhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // round corner of containerView
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        // smaller container view
        changeContainerSize(width: view.frame.size.width * 2 / 3)
        self.containerView.alpha = 0.8
        // hide downloadButton if file is downloaded
        if let photo = photo, let progress = photo.progress, progress >= Common.maxProgress {
            downloadButton.isHidden = true
            // display downloaded image
            if let imageData = Common.loadLocalImage(photo: photo) {
                imageView.image = UIImage(data: imageData)
            }
        } else {
            // display thumbnail image
            if let urlString = photo?.thumbUrl {
                imageView.kf.setImage(with: urlString.toURL())
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let endWidth: CGFloat = view.frame.size.width - 50
        // do animation
        UIView.animate(withDuration: 0.6, animations: {[weak self] in
            // maximize container's size
            self?.changeContainerSize(width: endWidth)
            self?.containerView.alpha = 1
        })
    }
    // change size of container
    func changeContainerSize(width: CGFloat) {
        containerWidthConstraint.constant = width
        imageHeightConstraint.constant = width * (CGFloat)(photo?.ratioHeightPerWidth ?? 1)
        self.containerView.layoutIfNeeded()
    }
    // dismiss self
    @IBAction func closeButtonTouch(_ sender: Any) {
        // do animation
        let endWidth:CGFloat = view.frame.size.width * 2 / 3
        UIView.animate(withDuration: 0.3, animations: {[unowned self] in
            // maximize container's size
            self.changeContainerSize(width: endWidth)
            self.containerView.alpha = 0.2
            }, completion: {completed in
                self.dismiss(animated: false, completion: nil)
        })
    }
    // download button touched
    @IBAction func downloadButtonTouch(_ sender: Any) {
        // hide download button, show progress view
        downloadButton.isHidden = true
        progressView.isHidden = false
        // call downloading process
        photoViewModel?.downloadPhoto(photo: photo)
    }
    @IBAction func favoriteButtonTouch(_ sender: Any) {
    }
}
// MARK: --ProgressDelegate
extension PhotoViewController: ProgressDelegate {
    // update progress status
    func updateProgress(photo: Photo) {
        // compare with self's photo
        if let photoId = self.photo?.photoId, photoId == photo.photoId, let progress = photo.progress {
            // update progress
            if progress < Common.maxProgress {
                progressView.progress = (Float)(progress) / (Float)(Common.maxProgress)
            } else if progress == Common.maxProgress {
                progressView.isHidden = true
            }
            // update photo
            updatePhoto(photo)
        }
    }
    func downloadingFailed(photo: Photo) {
        // hide download button, show progress view
        downloadButton.isHidden = false
        progressView.isHidden = true
        updatePhoto(photo)
    }
    
    func updatePhoto(_ photo: Photo) {
        if let _ = self.photo {
            self.photo!.progress = photo.progress
        }
    }
}
