//
//  TwoColumnsLayoutDelegate.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/22/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// delegate of TwoColumnsLayout class
import Foundation
protocol TwoColumnsLayoutDelegate: class {
    // call to get ratio height per width of photo 
    func getPhotoRatioHeightPerWidth(indexPath: IndexPath) -> Float?
}
