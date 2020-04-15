//
//  EmoticonViewModel.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/15.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class EmoticonViewModel: NSObject {
    static let shareInstance : EmoticonViewModel = EmoticonViewModel()
    lazy var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    override init() {
        super.init()
        packages.append(EmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }
}
