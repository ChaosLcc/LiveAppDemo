//
//  ViewController.swift
//  GiftAnimate
//
//  Created by Liubi_Chaos_G on 2020/4/22.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var giftContainerView: GCGiftContainerView = GCGiftContainerView()

    @IBOutlet weak var label: GCGiftDigitalLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func gift1(_ sender: Any) {
        let model = GCGiftModel(senderName: "Chaos_G", senderURL: "icon_1", giftName: "火箭", giftURL: "gift_1")
        giftContainerView.showGift(model)
    }
    @IBAction func gift2(_ sender: Any) {
        let model = GCGiftModel(senderName: "万一第一呢", senderURL: "icon_2", giftName: "游艇", giftURL: "gift_2")
        giftContainerView.showGift(model)
    }
    @IBAction func gift3(_ sender: Any) {
        let model = GCGiftModel(senderName: "罗老师,别这样", senderURL: "icon_3", giftName: "星巴克中杯", giftURL: "gift_3")
        giftContainerView.showGift(model)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        label.showDigitAnimation {
            print("结束")
        }
    }
}

