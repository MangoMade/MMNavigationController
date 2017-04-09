//
//  ViewControllerInjectBlockWrapper.swift
//  MMNavigationController
//
//  Created by Mango on 2017/4/9.
//  Copyright © 2017年 MangoMade. All rights reserved.
//

import UIKit

class ViewControllerInjectBlockWrapper {
    
    var block: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?
    
    init(block: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?) {
        self.block = block
    }
}
