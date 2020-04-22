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
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // display photo
        if let urlString = photo?.thumbUrl {
            imageView.kf.setImage(with: urlString.toURL())
        }
        containerView.layer.cornerRadius = 10
        // smaller container view
        let startWidth = view.frame.size.width * 2 / 3
        self.containerWidthConstraint.constant = startWidth
        self.imageHeightConstraint.constant = startWidth * (CGFloat)(self.photo?.ratioHeightPerWidth ?? 1)
        self.containerView.alpha = 0.8
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let endWidth: CGFloat = view.frame.size.width
        // do animation
        UIView.animate(withDuration: 1.0, animations: {[unowned self] in
            // maximize container's size
            self.containerWidthConstraint.constant = endWidth
            self.imageHeightConstraint.constant = endWidth * (CGFloat)(self.photo?.ratioHeightPerWidth ?? 1)
            self.containerView.layoutIfNeeded()
            self.containerView.alpha = 1
        })
    }
    
    @IBAction func closeButtonTouch(_ sender: Any) {
        // do animation
        let endWidth:CGFloat = 10
        UIView.animate(withDuration: 1.0, animations: {[unowned self] in
            // maximize container's size
            self.containerWidthConstraint.constant = endWidth
            self.imageHeightConstraint.constant = endWidth * (CGFloat)(self.photo?.ratioHeightPerWidth ?? 1)
            self.containerView.layoutIfNeeded()
            self.containerView.alpha = 0.2
            }, completion: {completed in
                self.dismiss(animated: false, completion: nil)
        })
        
    }
}
