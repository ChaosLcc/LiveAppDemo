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
    private lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = style.bottomLineColor
        bottomLine.frame.size.height = style.bottomLineH
        bottomLine.frame.origin.y = style.titleHeight - style.bottomLineH
        return bottomLine
    }()
    private lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = 0.7
        return coverView
    }()
    
    weak var delegate: GCTitleViewDelegate?
    
    // MARK: 计算属性
    private lazy var normalColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) =
        self.style.normalColor.getRGB()
    
    private lazy var selectedColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.style.selectedColor.getRGB()
    
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
    private func setupUI() {
        addSubview(scrollView)
        // 添加label
        setupTitleLabels()
        // 设置frame
        setupTitleLabelsFrame()
        // 指示器
        if style.isShowBottomLine {
            setupBottomLine()
        }
    }
    
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.textColor = i == 0 ? style.selectedColor : style.normalColor
            label.font = style.font
            label.tag = i
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleLabelTap(_:))))
            label.isUserInteractionEnabled = true
            scrollView.addSubview(label)
            titleLabels.append(label)
        }
    }
    private func setupTitleLabelsFrame() {
        let count = titles.count
        for (i, label) in titleLabels.enumerated() {
            var w: CGFloat = 0
            let h: CGFloat = bounds.height
            var x: CGFloat = 0
            let y: CGFloat = 0
            
            if style.isScrollEnable { // 可以滚动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil).width
                if i == 0 {
                    x = style.titleMargin * 0.5
                    if style.isShowBottomLine {
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                } else {
                    x = titleLabels[i - 1].frame.maxX + style.titleMargin
                }
            } else { // 不可以滚动, 平分
                w = bounds.width / CGFloat(count)
                x = CGFloat(i) * w
                if i == 0 && style.isShowBottomLine {
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0) : CGSize.zero
    }
    private func setupBottomLine() {
        scrollView.addSubview(bottomLine)
    }
}

// MARK:- 监听事件
extension GCTitleView {
    @objc private func titleLabelTap(_ tap: UITapGestureRecognizer) {
        // 切换文字颜色
        guard let label = tap.view as? UILabel else {
            return
        }
        // 调整title
        adjustTitleLabel(label.tag)
        
        // 调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.3) {
                self.bottomLine.frame.origin.x = label.frame.origin.x
                self.bottomLine.frame.size.width = label.frame.size.width
            }            
        }
        
        // 通知contentView调整
        delegate?.titleView(self, targetIndex: currentIndex)
    }
}
// MARK:- GCContentViewDelegate
extension GCTitleView: GCContentViewDelegate {
    func contentView(_ contentView: GCContentView, scrollTo targetIndex: Int) {
        adjustTitleLabel(targetIndex)
    }
    func contentView(_ contentView: GCContentView, scrollTo targetIndex: Int, progress: CGFloat) {
        print(targetIndex)
        print(progress)
        // 取出label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        // 颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selectedColor, style.normalColor)
        let normalRGB = style.normalColor.getRGB()
        let selectRGB = style.selectedColor.getRGB()
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0 * progress, g: selectRGB.1 - deltaRGB.1 * progress, b: selectRGB.2 - deltaRGB.2 * progress)
        
        // 指示器移动与渐变
        if style.isShowBottomLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.size.width - sourceLabel.frame.size.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.size.width + deltaW * progress
        }
    }
    
    /// 调整lable颜色和位置
    /// - Parameter targetIndex: <#targetIndex description#>
    private func adjustTitleLabel(_ targetIndex: Int) {
        if targetIndex == currentIndex { return }
        // 目标label
        let targetLabel = titleLabels[targetIndex]
        // 原来的label
        let sourceLabel = titleLabels[currentIndex]
        
        // 切换文字颜色
        targetLabel.textColor = style.selectedColor
        sourceLabel.textColor = style.normalColor
        
        // 记录下标值
        currentIndex = targetLabel.tag
        // 调整位置
        if style.isScrollEnable {
            var offsetX = targetLabel.center.x - bounds.width * 0.5
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
// MARK:- 对外暴露的方法
extension GCTitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (selectedColorRGB.0 - normalColorRGB.0, selectedColorRGB.1 - normalColorRGB.1, selectedColorRGB.2 - normalColorRGB.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: selectedColorRGB.0 - colorDelta.0 * progress, g: selectedColorRGB.1 - colorDelta.1 * progress, b: selectedColorRGB.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: normalColorRGB.0 + colorDelta.0 * progress, g: normalColorRGB.1 + colorDelta.1 * progress, b: normalColorRGB.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
        
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - sourceLabel.frame.width
        
        // 5.计算滚动的范围差值
        if style.isShowBottomLine {
            bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
        }
        
        // 6.放大的比例
        if style.isNeedScale {
            let scaleDelta = (style.scaleRange - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleDelta, y: style.scaleRange - scaleDelta)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
        }
        
        // 7.计算cover的滚动
        if style.isShowCover {
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.width + moveTotalW * progress)
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress)
        }
    }
    
    func contentViewDidEndScroll() {
        // 0.如果是不需要滚动,则不需要调整中间位置
        guard style.isScrollEnable else { return }
        
        // 1.获取获取目标的Label
        let targetLabel = titleLabels[currentIndex]
        
        // 2.计算和中间位置的偏移量
        var offSetX = targetLabel.center.x - bounds.width * 0.5
        if offSetX < 0 {
            offSetX = 0
        }
        
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offSetX > maxOffset {
            offSetX = maxOffset
        }
        
        // 3.滚动UIScrollView
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
}

