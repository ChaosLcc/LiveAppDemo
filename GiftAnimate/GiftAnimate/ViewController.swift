//
//  ViewController.swift
//  GiftAnimate
//
//  Created by Liubi_Chaos_G on 2020/4/22.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var giftContainerView: GCGiftContainerView = GCGiftContainerView(frame: CGRect(x: 0, y: 100, width: 250, height: 90))

    @IBOutlet weak var label: GCGiftDigitalLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftContainerView.backgroundColor = UIColor.lightGray
        view.addSubview(giftContainerView)
    }

    
    @IBAction func gift1(_ sender: Any) {
        let model = GCGiftModel(senderName: "Chaos_G", senderURL: "icon1", giftName: "火箭", giftURL: "prop_f")
        giftContainerView.showGift(model)
    }
    @IBAction func gift2(_ sender: Any) {
        let model = GCGiftModel(senderName: "万一第一呢", senderURL: "icon2", giftName: "游艇", giftURL: "prop_g")
        giftContainerView.showGift(model)
    }
    @IBAction func gift3(_ sender: Any) {
        let model = GCGiftModel(senderName: "罗老师,别这样", senderURL: "icon3", giftName: "星巴克中杯", giftURL: "prop_h")
        giftContainerView.showGift(model)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        label.showDigitAnimation {
//            print("结束")
//        }
    }
}

