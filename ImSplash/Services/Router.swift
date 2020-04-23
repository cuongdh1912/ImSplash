//
//  Router.swift
//  ImSplash
//
//  Created by Cuong Do Hung on 4/22/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
// Open view controllers
import UIKit
class Router {
    // load viewcontroller from main storyboard by viewcontroller id
    static func getViewControllerWithId(_ viewControllerId: String) -> UIViewController?{
        return UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: viewControllerId)
    }
    static func showAlert(message: String?, parrent: UIViewController?) {
        // show error alert
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        parrent?.present(alert, animated: true)
    }
    // get current(displaying) view controller
    static func getCurrentViewController() ->UIViewController? {
        // get window
        var window: UIWindow? {
            if #available(iOS 13, *) {
                return UIApplication.shared.windows.first { $0.isKeyWindow }
            } else {
                return UIApplication.shared.keyWindow
            }
        }
        // get root view controller
        let rootVC = window?.rootViewController
        if let vc = rootVC?.presentedViewController {
            return vc
        } else {
            return rootVC
        }
    }
}
