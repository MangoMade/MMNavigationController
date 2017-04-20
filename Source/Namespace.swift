//
//  Namespace.swift
//  StaticCellKit
//
//  Created by Mango on 2017/4/5.
//  Copyright © 2017年 MangoMade. All rights reserved.
//

import UIKit

public protocol NamespaceWrappable: class {
    
    associatedtype WrapperType
    
    var mm: WrapperType { get set }
    
    static var mm: WrapperType.Type { get }
}

public extension NamespaceWrappable {

    var mm: TypeWrapper<Self> {
        get {
            return TypeWrapper(self)
        }
        set { }
    }
    
    static var mm: TypeWrapper<Self>.Type {
        return TypeWrapper.self
    }
}

public protocol TypeWrapperProtocol {
    
    associatedtype WrapperObject
    
    var wrapperObject: WrapperObject { get }
    
    init(_ wrapperObject: WrapperObject)
    
}

public struct TypeWrapper<T>: TypeWrapperProtocol {
    
    public let wrapperObject: T
    
    public init(_ wrapperObject: T) {
        self.wrapperObject = wrapperObject
    }
}


