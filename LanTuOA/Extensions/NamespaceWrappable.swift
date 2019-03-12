//
//  NamespaceWrappable.swift
//  DanJuanERP
//
//  Created by HYH on 2018/12/25.
//  Copyright © 2018 广西蛋卷科技有限公司. All rights reserved.
//  命名空间

import UIKit

public protocol NamespaceWrappable {
    associatedtype WrapperType
    var taxi: WrapperType { get }
    static var taxi: WrapperType.Type { get }
}

public extension NamespaceWrappable {
    var taxi: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    
    static var taxi: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

public struct NamespaceWrapper<T> {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}
