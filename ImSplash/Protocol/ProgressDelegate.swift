//
//  ProgressDelegate.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/23/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// Define method for downloading progress's callback
protocol ProgressDelegate {
    func updateProgress(photo: Photo)
    func downloadingFailed(photo: Photo)
}

