//
//  GCPageCollectionView.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/4/6.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

protocol GCPageCollectionViewDataSource: AnyObject {
    func numberOfSections(in pageCollectionView: GCPageCollectionView) -> Int
    func pageCollectionView(_ pageCollectionView: GCPageCollectionView, numberOfItemsInSection section: Int) -> Int
    
    func pageCollectionView(_ pageCollectionView: GCPageCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class GCPageCollectionView: UIView {
    private var titles: [String]
    private var style: GCPageStyle
    private var isTitleInTop: Bool
    private var layout: GCPageCollectionViewLayout
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var titleView: GCTitleView!
    private var sourceIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    weak var dataSource: GCPageCollectionViewDataSource?
    
    init(frame: CGRect, titles: [String], style: GCPageStyle, isTitleInTop: Bool, layout: GCPageCollectionViewLayout) {
        self.titles = titles
        self.style = style
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GCPageCollectionView {
    func register(cell: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    func register(nib: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReuseableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}

extension GCPageCollectionView {
    func setupUI() {
        // titleView
        let titleViewY = isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleViewY, width: bounds.width, height: style.titleHeight)
        titleView = GCTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        titleView.delegate = self
        addSubview(titleView)
        
        // UIPageControl
        let pageControlH: CGFloat = 20.0
        let pageControlY = isTitleInTop ? (bounds.height - pageControlH) : (bounds.height - pageControlH - style.titleHeight)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlH)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        pageControl.backgroundColor = UIColor.randomColor()
        addSubview(pageControl)
        // collectionView
        let collectionViewY: CGFloat = isTitleInTop ? style.titleHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleHeight - pageControlH)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.randomColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
    }
}
extension GCPageCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 这里dataSource可以强制解包, 能走到这里 数据源一定有值
        return dataSource!.pageCollectionView(self, cellForItemAt: indexPath)
    }
}

extension GCPageCollectionView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    
    fileprivate func scrollViewEndScroll() {
        // 1.取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        // 2.判断分组是否有发生改变
        if sourceIndexPath.section != indexPath.section {
            // 3.1.修改pageControl的个数
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            // 3.2.设置titleView位置
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            
            // 3.3.记录最新indexPath
            sourceIndexPath = indexPath
        }
        
        // 3.根据indexPath设置pageControl
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
}

extension GCPageCollectionView: GCTitleViewDelegate {
    func titleView(_ titleView: GCTitleView, targetIndex: Int) {
        let indexPath = IndexPath(item: 0, section: targetIndex)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        scrollViewEndScroll()
    }
}
