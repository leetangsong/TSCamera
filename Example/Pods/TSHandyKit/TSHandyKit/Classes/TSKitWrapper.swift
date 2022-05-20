//
//  TSKitWrapper.swift
//  TSKit
//
//  Created by leetangsong on 2022/5/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

public struct TSKitWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol TSKitCompatible: AnyObject { }

public protocol TSKitCompatibleValue {}


extension TSKitCompatible {
    public var ts: TSKitWrapper<Self> {
        get{
            return TSKitWrapper(self)
        }
        set{
            
        }
    }
}

extension TSKitCompatibleValue {
    public var ts: TSKitWrapper<Self> {
        get{
            return TSKitWrapper(self)
        }
        set{
            
        }
    }
}




public struct TSKitClassWrapper<Base> {
    public static var base: Base.Type{
        return Base.self
    }
}
public protocol TSKitClassCompatible: AnyObject { }
public protocol TSKitClassCompatibleValue {}

extension TSKitClassCompatible {
    public static var ts: TSKitClassWrapper<Self>.Type{
        get{
            return  TSKitClassWrapper<Self>.self
        }
        set{
            
        }
    }
}
extension TSKitClassCompatibleValue {
    public static var ts: TSKitClassWrapper<Self>.Type{
        get{
            return  TSKitClassWrapper<Self>.self
        }
        set{
            
        }
    }
}





public struct TSKitGenericityWrapper<Base, T> {
    public var base: Base
    public init(_ base: Base) {
        self.base = base
    }
}
public protocol TSKitGenericityCompatible: AnyObject {
    associatedtype ItemType
}

public protocol TSKitGenericityCompatibleValue {
    associatedtype ItemType
}

extension TSKitGenericityCompatible {
    public var ts: TSKitGenericityWrapper<Self, ItemType> {
        get{
            return TSKitGenericityWrapper(self)
        }
        set{
            
        }
    }
}

extension TSKitGenericityCompatibleValue {
    public var ts: TSKitGenericityWrapper<Self, ItemType> {
        get{
            return TSKitGenericityWrapper(self)
        }
        set{
            
        }
    }
}



public struct TSKitClassGenericityWrapper<Base, T> {
    public static var base: Base.Type{
        return Base.self
    }
}
public protocol TSKitClassGenericityCompatible: AnyObject {
    associatedtype ItemType
}
public protocol TSKitClassGenericityCompatibleValue {
    associatedtype ItemType
}

extension TSKitClassGenericityCompatible {
    public static var ts: TSKitClassGenericityWrapper<Self, ItemType>.Type{
        get{
            return  TSKitClassGenericityWrapper<Self, ItemType>.self
        }
        set{
            
        }
    }
}
extension TSKitClassGenericityCompatibleValue {
    public static var ts: TSKitClassGenericityWrapper<Self, ItemType>.Type{
        get{
            return  TSKitClassGenericityWrapper<Self, ItemType>.self
        }
        set{
            
        }
    }
}
