//
//  GCPageStyle.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/3/28.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

struct GCPageStyle {
    var titleViewHeight: CGFloat = 44.0
    var normalColor: UIColor = UIColor(r: 0, g: 0, b: 0)
    var selectColor: UIColor = UIColor(r: 255, g: 0, b: 0)
    var fontSize: CGFloat = 15.0
    
    var isScrollEnable: Bool = false
    var itemMargin: CGFloat = 30.0
    
    var isShowScrollLine: Bool = false
    var scrollLineHeight: CGFloat = 2
    var scrollLineColor: UIColor = .red
}
