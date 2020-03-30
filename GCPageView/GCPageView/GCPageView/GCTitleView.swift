//
//  GCTitleView.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/3/28.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

protocol GCTitleViewDelegate: AnyObject {
    func titleView(_ titleView: GCTitleView, targetIndex: Int)
}

class GCTitleView: UIView {
    private var titles: [String]
    private var style: GCPageStyle
    private var currentIndex: Int = 0
    private lazy var titleLabels: [UILabel] = [UILabel]()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    weak var delegate: GCTitleViewDelegate?
    
    
    init(frame: CGRect, titles: [String], style: GCPageStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension GCTitleView {
    func setupUI() {
        addSubview(scrollView)
        // 添加label
        setupTitleLabels()
        // 设置frame
        setupTitleLabelsFrame()
    }
    
    func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.textColor = i == 0 ? style.selectColor : style.normalColor
            label.font = UIFont.systemFont(ofSize: style.fontSize)
            label.tag = i
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleLabelTap(_:))))
            label.isUserInteractionEnabled = true
            scrollView.addSubview(label)
            titleLabels.append(label)
        }
    }
    func setupTitleLabelsFrame() {
        let count = titles.count
        for (i, label) in titleLabels.enumerated() {
            var w: CGFloat = 0
            let h: CGFloat = bounds.height
            var x: CGFloat = 0
            let y: CGFloat = 0
            
            if style.isScrollEnable { // 可以滚动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil).width
                if i == 0 {
                    x = style.itemMargin * 0.5
                } else {
                    x = titleLabels[i - 1].frame.maxX + style.itemMargin
                }
            } else { // 不可以滚动, 平分
                w = bounds.width / CGFloat(count)
                x = CGFloat(i) * w
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
}

// MARK:- 监听事件
extension GCTitleView {
    @objc private func titleLabelTap(_ tap: UITapGestureRecognizer) {
        // 切换文字颜色
        guard let label = tap.view as? UILabel else {
            return
        }
        label.textColor = style.selectColor
        titleLabels[currentIndex].textColor = style.normalColor
        // 记录下标值
        currentIndex = label.tag
        // 通知contentView调整
        delegate?.titleView(self, targetIndex: currentIndex)
        // 调整位置
        if style.isScrollEnable {
            var offsetX = label.center.x - bounds.width * 0.5
            if offsetX < 0 { // 滚动的最小值
                offsetX = 0
            }
            if offsetX > (scrollView.contentSize.width - scrollView.frame.width) { // 滚动的最大值
                offsetX = scrollView.contentSize.width - scrollView.frame.width
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}
