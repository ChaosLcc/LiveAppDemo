//
//  HomeViewController.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/3/27.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 这里设置电池状态栏颜色是没有作用的
    // 原因: 电池状态栏的颜色是由每个页面最顶层的控制器决定的
    // HomeViewController外层还包裹着NavigationController
    // 所以下面的代码应该写到导航控制器中
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
}
