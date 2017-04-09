//
//  PopGestrueDelegateObject.swift
//  MMNavigationController
//
//  Created by Mango on 2017/4/9.
//  Copyright © 2017年 MangoMade. All rights reserved.
//

import UIKit

// MARK: - NavigationControllerPopGestrueDelegate
class PopGestrueDelegateObject: NSObject {
    
    weak var navigationController: UINavigationController?
    
}

// MARK: - UIGestureRecognizerDelegate
extension PopGestrueDelegateObject: UIGestureRecognizerDelegate {
    
    
    /// 这里主要参考了 FDFullscreenPopGesture
    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let navigationController = navigationController,
            let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
                return false
        }
        
        if navigationController.viewControllers.count <= 1 {
            return false
        }
        
        let topViewController = navigationController.viewControllers.last
        if topViewController?.mm.popGestrueEnable == false {
            return false
        }
        
        let startLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        let enableWidth = topViewController?.mm.popGestrueEnableWidth ?? 0
        if enableWidth > 0 && startLocation.x > enableWidth {
            return false
        }
        
        if navigationController.value(forKey: "_isTransitioning") as? Bool == true {
            return false
        }
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        if translation.x <= 0 {
            return false
        }
        
        return true
    }
    
}
