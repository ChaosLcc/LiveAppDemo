//
//  GCGiftContainerView.swift
//  GiftAnimate
//
//  Created by Liubi_Chaos_G on 2020/4/22.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit
private let kChannelCount: Int = 2
private let kChannelViewH: CGFloat = 40
private let kChannelMargin: CGFloat = 10

class GCGiftContainerView: UIView {
    
    lazy private var channelViews: [GCGiftChannelView] = [GCGiftChannelView]()
    lazy private var cacheGiftModels: [GCGiftModel] = [GCGiftModel]()
    
    // MARK: 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK:- 设置UI界面
extension GCGiftContainerView {
    fileprivate func setupUI() {
        // 1.根据当前的渠道数，创建HYGiftChannelView
        let w : CGFloat = frame.width
        let h : CGFloat = kChannelViewH
        let x : CGFloat = 0
        for i in 0 ..< kChannelCount {
            let y : CGFloat = (h + kChannelMargin) * CGFloat(i)
            
            let channelView = GCGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0.0
            addSubview(channelView)
            channelViews.append(channelView)
        }
    }
}
extension GCGiftContainerView {
    func showGift(_ giftModel: GCGiftModel) {
        // 1.判断正在动画的channelView 需不需要连击
        if let channelView = checkUsingChanelView(giftModel) {
            channelView.addOnceToCache()
        }
        // 2.判断是否有闲置channelView
        if let channelView = checkIdleChanelView(giftModel) {
            channelView.giftModel = giftModel
        }
        // 3.将数据放入缓存
        cacheGiftModels.append(giftModel)
    }
    
    /// 正在使用的channelView
    /// - Parameter giftModel: <#giftModel description#>
    private func checkUsingChanelView(_ giftModel: GCGiftModel) -> GCGiftChannelView? {
        for channelView in channelViews {
            if giftModel.isEqual(channelView.giftModel) && channelView.state != .endAnimating {
                return channelView
            }
        }
        return nil
    }
    
    /// 闲置的channelView
    /// - Parameter giftModel: <#giftModel description#>
    private func checkIdleChanelView(_ giftModel: GCGiftModel) -> GCGiftChannelView? {
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        return nil
    }
}
