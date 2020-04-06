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
        let frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: 300)
        let titles = ["热门", "经典", "土豪", "小资", "免费"]
        let layout = GCPageCollectionViewLayout()
        var style = GCPageStyle()
        style.isShowScrollLine = true
        let pageCollectionView = GCPageCollectionView(frame: frame, titles: titles, style: style, isTitleInTop: true, layout: layout)
        view.addSubview(pageCollectionView)
    }


}

