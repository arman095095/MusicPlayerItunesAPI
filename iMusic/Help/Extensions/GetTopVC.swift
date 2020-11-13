//
//  UIApplicationTOPWINDOWGET.swift
//  diffibleData
//
//  Created by Arman Davidoff on 27.02.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController() -> UIViewController? {
        var topVC = shared.keyWindow!.rootViewController
        while true {
            if let presented = topVC?.presentedViewController {
                topVC = presented
            } else if let nav = topVC as? UINavigationController {
                topVC = nav.visibleViewController
            } else if let tab = topVC as? UITabBarController {
                topVC = tab.selectedViewController
            } else {
                break
            }
        }
        return topVC
    }
    
    class func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    }
    
    
}
