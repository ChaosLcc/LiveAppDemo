//
//  NibLoadable.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/6.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
}
extension NibLoadable where Self: UIView {
    static func loadFromNib(_ nibName: String? = nil) -> Self {
        let name = nibName == nil ? "\(self)" : nibName!
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as! Self
    }
}
