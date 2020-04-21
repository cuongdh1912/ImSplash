//
//  String+ToURLRequest.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/21/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import Foundation
extension String {
    func toURLRequest() -> URLRequest? {
        if let url = URL(string: self) {
            return URLRequest(url: url)
        }
        // if converting fails
        return nil
    }
}
