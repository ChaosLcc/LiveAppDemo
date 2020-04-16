//
//  EmoticonView.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/15.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

private let kEmoticonViewCell = "kEmoticonViewCell"

class EmoticonView: UIView {
    
    var emoticonClickCallback: ((_ emoticon: Emoticon) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        var style = GCPageStyle()
        style.isShowBottomLine = true
        let layout = GCPageCollectionViewLayout()
        layout.cols = 7
        layout.rows = 3
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let pageCollectionView = GCPageCollectionView(frame: bounds, titles: ["普通", "粉丝专属"], style: style, isTitleInTop: false, layout: layout)
        
        addSubview(pageCollectionView)
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.register(nib: UINib(nibName: "EmoticonViewCell", bundle: nil), forCellWithReuseIdentifier: kEmoticonViewCell)
    }
}
extension EmoticonView: GCPageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: GCPageCollectionView) -> Int {
        return EmoticonViewModel.shareInstance.packages.count
    }
    
    func pageCollectionView(_ pageCollectionView: GCPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmoticonViewModel.shareInstance.packages[section].emoticons.count
    }
    
    func pageCollectionView(_ pageCollectionView: GCPageCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageCollectionView.dequeueReuseableCell(withReuseIdentifier: kEmoticonViewCell, for: indexPath) as! EmoticonViewCell
//        cell.backgroundColor = UIColor.randomColor()
        cell.emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
}

extension EmoticonView: GCPageCollectionViewDelegate {
    func pageCollectionView(_ pageCollectionView: GCPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        
        if let callback = emoticonClickCallback {
            callback(emoticon)
        }
    }
}
