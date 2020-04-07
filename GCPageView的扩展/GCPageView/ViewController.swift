//
//  ViewController.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/3/28.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

private let kEmoticonCell = "kEmoticonCell"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: 300)
        let titles = ["热门", "经典", "土豪", "小资", "免费"]
        let layout = GCPageCollectionViewLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.cols = 4
        layout.rows = 2
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        var style = GCPageStyle()
        style.isShowBottomLine = true
        let pageCollectionView = GCPageCollectionView(frame: frame, titles: titles, style: style, isTitleInTop: true, layout: layout)
        pageCollectionView.dataSource = self
        pageCollectionView.register(cell: UICollectionViewCell.self, forCellWithReuseIdentifier: kEmoticonCell)
        view.addSubview(pageCollectionView)
    }
}

extension ViewController: GCPageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: GCPageCollectionView) -> Int {
        return 4
    }
    
    func pageCollectionView(_ pageCollectionView: GCPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return section * 10 + 15
    }
    
    func pageCollectionView(_ pageCollectionView: GCPageCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageCollectionView.dequeueReuseableCell(withReuseIdentifier: kEmoticonCell, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    
}

