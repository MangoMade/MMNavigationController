//
//  WeakReferenceWrapper.swift
//  StaticCellKit
//
//  Created by Mango on 2017/4/5.
//  Copyright © 2017年 MangoMade. All rights reserved.
//



internal class WeakReferenceWrapper<WrappedType: AnyObject> {
    
    weak var instance: WrappedType?
    
}
