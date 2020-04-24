//
//  GCGiftDigitalLabel.swift
//  GiftAnimate
//
//  Created by Liubi_Chaos_G on 2020/4/22.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class GCGiftDigitalLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(5)
        context?.setLineJoin(.round)
        context?.setTextDrawingMode(.stroke)
        textColor = UIColor.orange
        super.drawText(in: rect)
        
        context?.setTextDrawingMode(.fill)
        textColor = UIColor.white
        super.drawText(in: rect)
    }
    
    func showDigitAnimation(_ complection: @escaping () -> ()) {
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 3, y: 3)
            }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
        }) { (_) in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [], animations: {
                self.transform = CGAffineTransform.identity
            }) { (_) in
                complection()
            }
        }
        
//        UIView.animate(withDuration: 0.25, animations: {
//            self.transform = CGAffineTransform(scaleX: 3, y: 3)
//        }) { (_) in
//            UIView.animate(withDuration: 0.25, animations: {
//                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//            }) { (_) in
//                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [], animations: {
//                    self.transform = CGAffineTransform.identity
//                }) { (_) in
//
//                }
//            }
//        }
        
    }
}
