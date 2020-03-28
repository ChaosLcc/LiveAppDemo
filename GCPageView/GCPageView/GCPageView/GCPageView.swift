//
//  GCPageView.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/3/28.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class GCPageView: UIView {
    private var titles: [String]
    private var childVcs: [ViewController]
    private var parentVc: ViewController
    private var style: GCPageStyle
    private var titleView: GCTitleView!
    
    
    init(frame: CGRect, titles: [String], childVcs: [ViewController], parentVc: ViewController, style: GCPageStyle) {
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GCPageView {
    private func setupUI() {
        setupTitleView()
        setupContentView()
    }
    private func setupTitleView() {
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleViewHeight)
        let titleView = GCTitleView(frame: frame, titles: titles)
        addSubview(titleView)
    }
    private func setupContentView() {
        let frame = CGRect(x: 0, y: style.titleViewHeight, width: bounds.width, height: bounds.height - style.titleViewHeight)
        let contentView = GCContentView(frame: frame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)
    }
}
