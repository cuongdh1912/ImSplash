//
//  PhotoViewController.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit
class PhotoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    @IBAction func closeButtonTouch(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
