//
//  ArrayExtensions.swift
//  TSKit_Example
//
//  Created by leetangsong on 2022/5/18.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

extension Array: TSKitGenericityCompatibleValue{
    public typealias ItemType = Element
}
extension Array: TSKitClassGenericityCompatibleValue{}

extension TSKitGenericityWrapper where Base == Array<T>{
    public subscript(index:Int) -> T?{
        if index<base.count {
            return base[index]
        }
        return nil
    }
}

extension TSKitGenericityWrapper where Base == Array<T>, T: Equatable{
    public mutating func remove(_ object: T){
        if let index = base.firstIndex(of: object){
            base.remove(at: index)
        }
    }
}

