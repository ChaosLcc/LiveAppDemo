//
//  GCPageCollectionView.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/4/6.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class GCPageCollectionView: UIView {
    private var titles: [String]
    private var style: GCPageStyle
    private var isTitleInTop: Bool
    private var layout: UICollectionViewFlowLayout
    
    init(frame: CGRect, titles: [String], style: GCPageStyle, isTitleInTop: Bool, layout: UICollectionViewFlowLayout) {
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
    func setupUI() {
        // titleView
        let titleViewY = isTitleInTop ? 0 : bounds.height - style.titleViewHeight
        let titleFrame = CGRect(x: 0, y: titleViewY, width: bounds.width, height: style.titleViewHeight)
        let titleView = GCTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        addSubview(titleView)
        
        // UIPageControl
        let pageControlH: CGFloat = 20.0
        let pageControlY = isTitleInTop ? (bounds.height - pageControlH) : (bounds.height - pageControlH - style.titleViewHeight)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlH)
        let pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        pageControl.backgroundColor = UIColor.randomColor()
        addSubview(pageControl)
        // collectionView
        let collectionViewY: CGFloat = isTitleInTop ? style.titleViewHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleViewHeight - pageControlH)
        let collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.randomColor()
        addSubview(collectionView)
    }
}
