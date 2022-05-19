//
//  BundleExtensions.swift
//  TSKit_Example
//
//  Created by leetangsong on 2022/5/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

extension Bundle: TSKitCompatible{}
extension Bundle: TSKitClassCompatible{ }


extension TSKitWrapper where Base == Bundle{
    
}


extension TSKitClassWrapper where Base == Bundle{
    public static func bundle(with cls: AnyClass, name: String) -> Bundle?{
        var bundle:Bundle? = Bundle.init(for: cls)
        if let url = bundle?.url(forResource: name, withExtension: "bundle"){
            bundle = Bundle.init(url: url)
        }
        return bundle
    }
}
