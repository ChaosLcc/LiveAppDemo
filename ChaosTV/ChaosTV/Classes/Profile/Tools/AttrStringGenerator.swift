//
//  AttrStringGenerator.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/21.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit
import Kingfisher
class AttrStringGenerator {
    
}
extension AttrStringGenerator {
    class func generateJoinLeaveRoom(_ username: String, _ isJoin: Bool) -> NSAttributedString {
        let roomString = "\(username) " + (isJoin ? "进入房间" : "离开房间")
        let roomMAttr = NSMutableAttributedString(string: roomString)
        roomMAttr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], range: NSRange(location: 0, length: username.count))
        return roomMAttr
    }
    
    class func generateTextMessage(_ username: String, _ message: String) -> NSAttributedString {
        let chatMessage = "\(username): \(message)"
        let chatMsgMattr = NSMutableAttributedString(string: chatMessage)
        chatMsgMattr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], range: NSRange(location: 0, length: username.count))
        
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return chatMsgMattr
        }
        let results = regex.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.count))
        for i in (0 ..< results.count).reversed() {
            let result = results[i]
            let emoticonName = (chatMessage as NSString).substring(with: result.range)
            guard let image = UIImage(named: emoticonName) else { continue }
            
            let attachment = NSTextAttachment()
            attachment.image = image
            let font = UIFont.systemFont(ofSize: 15)
            attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            let imageAttrStr = NSAttributedString(attachment: attachment)
            
            chatMsgMattr.replaceCharacters(in: result.range, with: imageAttrStr)
        }
        return chatMsgMattr
    }
    class func generateGiftMessage(_ giftName: String, _ giftURL: String, _ username: String) -> NSAttributedString {
        let sendGiftMsg = "\(username) 赠送 \(giftName)"
        
        let sendGiftMAttrMsg = NSMutableAttributedString(string: sendGiftMsg)
        
        sendGiftMAttrMsg.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], range: NSRange(location: 0, length: username.count))
        
        let range = (sendGiftMsg as NSString).range(of: giftName)
        sendGiftMAttrMsg.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], range: range)
        
        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: giftURL) else { return sendGiftMAttrMsg }
//        let attachment = NSTextAttachment()
//        attachment.image = image
//        let font = UIFont.systemFont(ofSize: 15)
//        attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
//        let imageAttrStr = NSAttributedString(attachment: attachment)
//        
//        chatMsgMattr.replaceCharacters(in: result.range, with: imageAttrStr)
    }
}
