//
//  ViewController.swift
//  GiftAnimate
//
//  Created by Liubi_Chaos_G on 2020/4/22.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: GCGiftDigitalLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func gift1(_ sender: Any) {
    }
    @IBAction func gift2(_ sender: Any) {
    }
    @IBAction func gift3(_ sender: Any) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        label.showDigitAnimation {
            print("结束")
        }
    }
}

