//
//  ViewController.swift
//  waterFallLayout
//
//  Created by Liubi_Chaos_G on 2020/3/31.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WaterfallLayoutDataSource, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let waterfall = WaterfallLayout()
        waterfall.dataSource = self
        waterfall.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: waterfall)
        collectionView.dataSource = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        
        view.addSubview(collectionView)
    }
    func numberOfColsInWaterfallLayout(_ layout: WaterfallLayout) -> Int {
        return 3
    }
    func waterfallLayout(_ layout: WaterfallLayout, indexPath: IndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(150) + 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
}
