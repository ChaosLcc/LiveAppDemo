//
//  GCGiftModel.swift
//  GiftAnimate
//
//  Created by Liubi_Chaos_G on 2020/4/23.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class GCGiftModel: NSObject {
    var senderName : String = ""
    var senderURL : String = ""
    var giftName : String = ""
    var giftURL : String = ""
    
    init(senderName : String, senderURL : String, giftName : String, giftURL : String) {
        self.senderName = senderName
        self.senderURL = senderURL
        self.giftName = giftName
        self.giftURL = giftURL
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let obj = object as? GCGiftModel else {
            return false
        }
        guard obj.giftName == giftName && obj.senderName == senderName else {
            return false
        }
        return true
    }
}
