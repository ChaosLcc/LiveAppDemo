//
//  GCContentView.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/3/28.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class GCContentView: UIView {
    private var childVcs: [ViewController]
    private var parentVc: ViewController
    init(frame: CGRect, childVcs: [ViewController], parentVc: ViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
