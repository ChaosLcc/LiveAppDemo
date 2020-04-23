//
//  GCGiftChannelView.swift
//  GiftAnimate
//
//  Created by Liubi_Chaos_G on 2020/4/22.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

enum GCGiftChannelState {
    case idle // 闲置状态
    case animating // 显示并动画中
    case willEnd // 将要结束,等待消失
    case endAnimating // 消失的动画结束
}

class GCGiftChannelView: UIView {
    
    // MARK: 控件属性
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var digitLabel: GCGiftDigitalLabel!
    
    /// 礼物连击数
    var currentNum: Int = 0
    /// channel的状态, 默认是闲置状态
    var state: GCGiftChannelState = .idle
    /// 缓存的数量
    private var cacheNumber: Int = 0
    
    var giftModel: GCGiftModel? {
        didSet {
            // 1.对模型进行校验
            guard let giftModel = self.giftModel else { return }
            // 2.给控件设置信息
            iconImageView.image = UIImage(named: giftModel.senderURL)
            senderLabel.text = giftModel.senderName
            giftDescLabel.text = "送出礼物：【\(giftModel.giftName)】"
            giftImageView.image = UIImage(named: giftModel.giftURL)
            
            // 3.将channelView弹出
            state = .animating
            performAnimation()
        }
    }
    class func loadFromNib() -> GCGiftChannelView {
        return Bundle.main.loadNibNamed("GCGiftChannelView", owner: nil, options: nil)?.first as! GCGiftChannelView
    }
}

extension GCGiftChannelView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.green.cgColor
    }
}
// MARK:- 对外提供的函数
extension GCGiftChannelView {
    func addOnceToCache() {
        if state == .willEnd { // 正在展示中 而且还没有执行消失动画 直接执行连击动画
            performDigitAnimation()
            // 取消上次执行动画的selector, 因为selector有delay, 不取消的话 随着时间流逝, 会出现闪现等的问题
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        } else {
            cacheNumber += 1
        }
    }
}

// MARK:- 执行动画代码
extension GCGiftChannelView {
    private func performAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.frame.origin.x = 0
        }) { (_) in
            // 数字动画
            self.performDigitAnimation()
        }
    }
    private func performDigitAnimation() {
        currentNum += 1
        digitLabel.text = "x\(currentNum)"
        digitLabel.showDigitAnimation {
            if self.cacheNumber > 0 {
                self.cacheNumber -= 1
                performDigitAnimation()
            } else {
                self.state = .willEnd
                // 停留3s
                self.perform(#selector(performEndAnimation), with: nil, afterDelay: 3)
            }
        }
    }
    @objc private func performEndAnimation() {
        state = .endAnimating
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
        }) { (_) in
            self.giftModel = nil // 一定要把模型设置为nil, 之后的操作还需要用channelView的model来进行某些判断
            self.frame.origin.x = -self.frame.width
            self.state = .idle
        }
    }
}
