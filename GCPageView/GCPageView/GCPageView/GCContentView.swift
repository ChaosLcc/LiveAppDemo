//
//  GCContentView.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/3/28.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

protocol GCContentViewDelegate: AnyObject {
    func contentView(_ contentView: GCContentView, scrollTo targetIndex: Int)
    func contentView(_ contentView: GCContentView, scrollTo targetIndex: Int, progress: CGFloat)
}

private let kContentViewCellID = "kContentViewCellID"

class GCContentView: UIView {
    private var childVcs: [UIViewController]
    private var parentVc: UIViewController
    private var startOffsetX: CGFloat = 0.0
    
    /// 是否禁止滑动, 默认不禁止
    private var isForbidScroll: Bool = false
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.bounds.size
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentViewCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false // 控制点击状态栏回顶部, 多个scrollview会失效
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.randomColor()
        
        return collectionView
    }()
    
    weak var delegate: GCContentViewDelegate?
    
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GCContentView {
    func setupUI() {
        addSubview(collectionView)
        for vc in childVcs {
            parentVc.addChild(vc)
        }
    }
}

extension GCContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentViewCellID, for: indexPath)
        // 移除cell里面所有内容,重新添加, 防止出现问题
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension GCContentView: UICollectionViewDelegate {
    /// 监听停止减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentViewEndScroll()
        scrollView.isScrollEnabled = true // 解决连续滑动出现的bug
    }
    /// 监听停止手势拖动
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { // 没有减速 = 停止了
            contentViewEndScroll()
        } else { // 解决连续滑动出现的bug
            scrollView.isScrollEnabled = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 合并到下面的代码 一起判断
//        guard !isForbidScroll else { return }
        // 判断和开始时的偏移量是否一致
        guard startOffsetX != scrollView.contentOffset.x, !isForbidScroll else {
            return
        }
        
        // 定义targetIndex/progress
        var targetIndex = 0
        var progress: CGFloat = 0.0
        // 赋值targetIndex/progress
        let currentIndex = Int(startOffsetX / collectionView.bounds.width)
        if startOffsetX < collectionView.contentOffset.x { // 手势左滑动
            targetIndex = (currentIndex + 1) > (childVcs.count - 1) ? (childVcs.count - 1) : (currentIndex + 1)
            progress = (collectionView.contentOffset.x - startOffsetX) / bounds.width
        } else { // 手势右滑动
            targetIndex = (currentIndex - 1) < 0 ? 0 : (currentIndex - 1)
            progress = (startOffsetX - collectionView.contentOffset.x) / bounds.width
        }
        
        delegate?.contentView(self, scrollTo: targetIndex, progress: progress)
    }
    
    private func contentViewEndScroll() {
        guard !isForbidScroll else { return }
        // 获取滚动到的位置
        let targetIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
//        print(targetIndex)
        
        // 通知代理做事情
        delegate?.contentView(self, scrollTo: targetIndex)
    }
}

// MARK:- GCTitleViewDelegate
extension GCContentView: GCTitleViewDelegate {
    func titleView(_ pageView: GCTitleView, targetIndex: Int) {
        isForbidScroll = true
        collectionView.setContentOffset(CGPoint(x: bounds.width * CGFloat(targetIndex), y: 0), animated: false)
    }
}
