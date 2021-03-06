//
//  ViewController.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/3/28.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        let titles = ["推荐", "手游玩法大全", "娱乐手", "游戏游戏", "趣玩", "游戏游戏", "趣玩"]
//        let titles = ["推荐", "手游玩法大全", "娱乐手", "游戏游戏"]
        var childVcs = [UIViewController]()
        for _ in 0 ..< titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        var style = GCPageStyle()
        style.isScrollEnable = true
        style.titleViewHeight = 44
        style.isShowScrollLine = true
        let pageView = GCPageView(frame: frame, titles: titles, childVcs: childVcs, parentVc: self, style: style)
        view.addSubview(pageView)
    }


}

