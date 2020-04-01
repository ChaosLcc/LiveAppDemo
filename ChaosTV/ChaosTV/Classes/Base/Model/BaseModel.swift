//
//  BaseModel.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/1.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit
@objcMembers
class BaseModel: NSObject {
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
