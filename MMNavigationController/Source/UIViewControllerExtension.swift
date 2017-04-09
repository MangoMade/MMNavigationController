//
//  UIViewControllerExtension.swift
//  MMNavigationController
//
//  Created by Mango on 2017/4/9.
//  Copyright © 2017年 MangoMade. All rights reserved.
//

import UIKit

extension UIViewController: NamespaceWrappable { }

private extension TypeWrapper {
    var viewController: T {
        return wrapperObject
    }
}

fileprivate struct AssociatedKey {
    static var viewWillAppearInjectBlock = 0
    static var navigationBarHidden = 0
    static var popGestrueEnable = 0
    static var navigationBarBackgroundColor = 0
    static var popGestrueEnableWidth = 0
    static var navigationBarTitleColor = 0
}

public extension TypeWrapper where T: UIViewController {
    
    /// 在AppDelegate中调用此方法
    public static func load() {
        UIViewController.methodsSwizzling
    }
    
    /// navigationBar 是否隐藏
    public var navigationBarHidden: Bool {
        get {
            var hidden = objc_getAssociatedObject(self.viewController, &AssociatedKey.navigationBarHidden) as? NSNumber
            if hidden == nil {
                hidden = NSNumber(booleanLiteral: false)
                objc_setAssociatedObject(self.viewController,
                                         &AssociatedKey.navigationBarHidden,
                                         hidden,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return hidden!.boolValue
        }
        set {
            objc_setAssociatedObject(self.viewController,
                                     &AssociatedKey.navigationBarHidden,
                                     NSNumber(booleanLiteral: newValue),
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// pop 手势是否可用
    public var popGestrueEnable: Bool {
        get {
            var enable = objc_getAssociatedObject(self.viewController, &AssociatedKey.popGestrueEnable) as? NSNumber
            if enable == nil {
                enable = NSNumber(booleanLiteral: true)
                objc_setAssociatedObject(self.viewController,
                                         &AssociatedKey.popGestrueEnable,
                                         enable,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return enable!.boolValue
        }
        set {
            objc_setAssociatedObject(self.viewController,
                                     &AssociatedKey.popGestrueEnable,
                                     NSNumber(booleanLiteral: newValue),
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// pop手势可用宽度，从左开始计算
    public var popGestrueEnableWidth: CGFloat {
        get {
            var width = objc_getAssociatedObject(self.viewController, &AssociatedKey.popGestrueEnableWidth) as? NSNumber
            if width == nil {
                width = NSNumber(floatLiteral: 0)
                objc_setAssociatedObject(self.viewController,
                                         &AssociatedKey.popGestrueEnableWidth,
                                         width,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return CGFloat(width!.floatValue)
        }
        set {
            objc_setAssociatedObject(self.viewController,
                                     &AssociatedKey.popGestrueEnableWidth,
                                     NSNumber(floatLiteral: Double(newValue)),
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// navigationBar 背景颜色
    public var navigationBarBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self.viewController, &AssociatedKey.navigationBarBackgroundColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self.viewController, &AssociatedKey.navigationBarBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// navigationBar 标题字体颜色
    public var navigationBarTitleColor: UIColor? {
        get {
            return objc_getAssociatedObject(self.viewController, &AssociatedKey.navigationBarTitleColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self.viewController, &AssociatedKey.navigationBarTitleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var viewWillAppearInjectBlock: ViewControllerInjectBlockWrapper? {
        get {
            return objc_getAssociatedObject(self.viewController, &AssociatedKey.viewWillAppearInjectBlock) as? ViewControllerInjectBlockWrapper
        }
        set {
            objc_setAssociatedObject(self.viewController, &AssociatedKey.viewWillAppearInjectBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController {
    
    fileprivate static let methodsSwizzling: () = {
        let originalViewWillAppearSelector = class_getInstanceMethod(UIViewController.self, #selector(viewWillAppear(_:)))
        let swizzledViewWillAppearSelector = class_getInstanceMethod(UIViewController.self, #selector(mm_viewWillAppear(_:)))
        method_exchangeImplementations(originalViewWillAppearSelector, swizzledViewWillAppearSelector)
    }()
    
    // MARK - private methods
    @objc fileprivate func mm_viewWillAppear(_ animated: Bool) {
        mm_viewWillAppear(animated)
        mm.viewWillAppearInjectBlock?.block?(self, animated)
    }
    
}
