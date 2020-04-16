//
//  Kingfisher-Extension.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/16.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit
import Kingfisher
extension UIImageView {
    func setImage(_ URLString : String?, _ placeHolderName : String? = nil) {
        guard let URLString = URLString else {
            return
        }
        
        guard let url = URL(string: URLString) else {
            return
        }
        
        guard let placeHolderName = placeHolderName else {
            kf.setImage(with: url)
            return
        }
        kf.setImage(with: url, placeholder : UIImage(named: placeHolderName))
    }
}
