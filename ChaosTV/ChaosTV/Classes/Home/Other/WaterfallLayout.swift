//
//  WaterfallLayout.swift
//  waterFallLayout
//
//  Created by Liubi_Chaos_G on 2020/3/31.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

protocol WaterfallLayoutDataSource: AnyObject {
    func waterfallLayout(_ layout: WaterfallLayout, indexPath: IndexPath) -> CGFloat
    // 可选的协议方法, 可以在协议扩展里面给一个默认实现, 如下
    func numberOfColsInWaterfallLayout(_ layout: WaterfallLayout) -> Int
}
extension WaterfallLayoutDataSource {
    func numberOfColsInWaterfallLayout(_ layout: WaterfallLayout) -> Int {
        return 2
    }
}
class WaterfallLayout: UICollectionViewFlowLayout {
    weak var dataSource: WaterfallLayoutDataSource?
    
    private lazy var attrsArray: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    private var totalHeight: CGFloat = 0
    private lazy var colHeights: [CGFloat] = {
        let cols = self.dataSource?.numberOfColsInWaterfallLayout(self) ?? 2
        var colHeights = Array(repeating: self.sectionInset.top, count: cols)
        return colHeights
    }()
    private var maxH: CGFloat = 0
    private var startIndex = 0
}
extension WaterfallLayout {
    override func prepare() {
        super.prepare()
        // 获取item的个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        // 获取列数
        let cols = dataSource?.numberOfColsInWaterfallLayout(self) ?? 2
        // 计算Item的宽度
        let itemW = (collectionView!.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing) / CGFloat(cols)
        // 计算所有的item的属性
        for i in startIndex ..< itemCount {
            // 1.设置每一个item位置相关的属性
            let indexPath = IndexPath(item: i, section: 0)
            // 2.根据位置创建Attributes属性
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // 3.设置高度
            guard let height = dataSource?.waterfallLayout(self, indexPath: indexPath) else {
                fatalError("请设置数据源,并且实现对应的数据源方法")
            }
            // 4.取出最小列的位置
            var minH = colHeights.min()!
            let index = colHeights.firstIndex(of: minH)!
            minH = minH + height + minimumLineSpacing
            colHeights[index] = minH
            // 5.设置item的属性
            attrs.frame = CGRect(x: self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index), y: minH - height - self.minimumLineSpacing, width: itemW, height: height)
            attrsArray.append(attrs)
        }
        // 记录最大值
        maxH = colHeights.max()!
        // 给startIndex重新赋值
        startIndex = itemCount
    }
}
extension WaterfallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing)
    }
}
