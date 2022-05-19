//
//  DictionaryExtensions.swift
//  TSKit_Example
//
//  Created by leetangsong on 2022/5/18.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

extension Dictionary: TSKitCompatibleValue{}
extension Dictionary: TSKitClassCompatibleValue{}


extension TSKitWrapper where Base == [AnyHashable: Any]{
    public func allKeys() -> [AnyHashable]{
        var temp:[AnyHashable] = []
        for (key,_) in base {
            temp.append(key)
        }
        return temp
    }
}
