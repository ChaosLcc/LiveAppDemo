//
//  GCPageCollectionViewLayout.swift
//  GCPageView
//
//  Created by Liubi_Chaos_G on 2020/4/6.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class GCPageCollectionViewLayout: UICollectionViewFlowLayout {
    var cols: Int = 4
    var rows: Int = 2
    
    private lazy var cellAttrs: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    private lazy var maxWidth: CGFloat = 0
}

// 自定义布局重写三部曲

extension GCPageCollectionViewLayout {
    override func prepare() {
        super.prepare()
        // 计算item宽度&高度
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * minimumLineSpacing) / CGFloat(rows)
        // 获取一共多少组
        let sectionCount = collectionView!.numberOfSections
        var prePageCount: Int = 0 // 前面的页数
        // 获取每组中有多少个item
        for i in 0 ..< sectionCount {
            let itemCount = collectionView!.numberOfItems(inSection: i)
            for j in 0 ..< itemCount {
                // 获取cell对应的indexpath
                let indexPath = IndexPath(item: j, section: i)
                // 根据indexPath创建UICollectionViewAttributes
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // 计算j在改组中第几页
                let page = j / (cols * rows)
                // 计算j在该页中的第几个
                let index = j % (cols * rows)
                
                let itemX = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index % cols)
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index / cols)
                
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                cellAttrs.append(attr)
            }
            prePageCount += (itemCount - 1) / (cols * rows) + 1
        }
        
        // 计算最大Y值
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
    }
    
}
extension GCPageCollectionViewLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}
extension GCPageCollectionViewLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: 0)
    }
}
