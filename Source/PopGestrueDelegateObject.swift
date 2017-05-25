//
//  PopGestrueDelegateObject.swift
//  MMNavigationController
//
//  Created by Mango on 2017/4/9.
//  Copyright © 2017年 MangoMade. All rights reserved.
//

import UIKit

// MARK: - NavigationControllerPopGestrueDelegate
internal class PopGestrueDelegateObject: NSObject {
    
    weak var navigationController: UINavigationController?
    
    weak var delegate: UIGestureRecognizerDelegate?
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
        
        return delegate?.gestureRecognizerShouldBegin?(gestureRecognizer) ?? true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return delegate?.gestureRecognizer?(gestureRecognizer, shouldBeRequiredToFailBy:otherGestureRecognizer) ?? false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return delegate?.gestureRecognizer?(gestureRecognizer, shouldRequireFailureOf: otherGestureRecognizer) ?? false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return delegate?.gestureRecognizer?(gestureRecognizer ,shouldRecognizeSimultaneouslyWith: otherGestureRecognizer) ?? false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return delegate?.gestureRecognizer?(gestureRecognizer ,shouldReceive: touch) ?? true
    }
    
    @available(iOS 9.0, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return delegate?.gestureRecognizer?(gestureRecognizer ,shouldReceive: press) ?? true
    }
}
