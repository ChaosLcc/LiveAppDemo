//
//  GiftListView.swift
//  XMGTV
//
//  Created by apple on 16/11/13.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import UIKit

private let kGiftCellID = "kGiftCellID"

protocol GiftListViewDelegate : class {
    func giftListView(giftView : GiftListView, giftModel : GiftModel)
}

class GiftListView: UIView, NibLoadable {
    // MARK: 控件属性
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var sendGiftBtn: UIButton!
    
    fileprivate var pageCollectionView : GCPageCollectionView!
    fileprivate var currentIndexPath : IndexPath?
    
    weak var delegate : GiftListViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1.初始化礼物的View
        setupGiftView()
        
        // 2.加载礼物的数据
        loadGiftData()
    }
}

extension GiftListView {
    fileprivate func setupUI() {
        setupGiftView()
    }
    
    fileprivate func setupGiftView() {
        var style = GCPageStyle()
        style.isScrollEnable = false
        style.isShowBottomLine = true
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        
        let layout = GCPageCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.cols = 4
        layout.rows = 2
        
        var pageViewFrame = giftView.bounds
        pageViewFrame.size.width = kScreenW
        pageCollectionView = GCPageCollectionView(frame: pageViewFrame, titles: ["热门", "高级", "豪华", "专属"], style: style, isTitleInTop: true, layout : layout)
        giftView.addSubview(pageCollectionView)
        pageCollectionView.backgroundColor = UIColor.black
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.register(nib: UINib(nibName: "GiftViewCell", bundle: nil), forCellWithReuseIdentifier: kGiftCellID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pageCollectionView.frame = giftView.bounds
    }
}


// MARK:- 加载数据
extension GiftListView {
    fileprivate func loadGiftData() {
        GiftViewModel.shareInstance.loadGiftData {
            self.pageCollectionView.reloadData()
        }
    }
}

// MARK:- 数据设置
extension GiftListView : GCPageCollectionViewDataSource, GCPageCollectionViewDelegate {
    func numberOfSections(in pageCollectionView: GCPageCollectionView) -> Int {
        return GiftViewModel.shareInstance.giftlistData.count
    }
    func pageCollectionView(_ pageCollectionView: GCPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = GiftViewModel.shareInstance.giftlistData[section]
        return package.list.count
    }
    func pageCollectionView(_ pageCollectionView: GCPageCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageCollectionView.dequeueReuseableCell(withReuseIdentifier: kGiftCellID, for: indexPath) as! GiftViewCell
        
        let package = GiftViewModel.shareInstance.giftlistData[indexPath.section]
        cell.giftModel = package.list[indexPath.item]
        
        return cell
    }
    func pageCollectionView(_ pageCollectionView: GCPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndexPath = indexPath
        sendGiftBtn.isEnabled = true
    }
}


// MARK:- 送礼物
extension GiftListView {
    @IBAction func sendGiftBtnClick() {
        let package = GiftViewModel.shareInstance.giftlistData[currentIndexPath!.section]
        let giftModel = package.list[currentIndexPath!.item]
        delegate?.giftListView(giftView: self, giftModel: giftModel)
    }
}
