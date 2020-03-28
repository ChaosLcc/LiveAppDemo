//
//  GCTitleView.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/3/28.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class GCTitleView: UIView {
    private var titles: [String]
    
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
