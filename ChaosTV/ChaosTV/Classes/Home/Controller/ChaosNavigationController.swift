//
//  ChaosNavigationController.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/3/27.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

class ChaosNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var count: UInt32 = 0
        let ivars = class_copyIvarList(UIGestureRecognizer.self, &count)!
        for i in 0 ..< count {
            let nameP = ivar_getName(ivars[Int(i)])!
            let name = String(cString: nameP)
//            print(name)
        }
        
        // navigation有自己的返回手势 interactivePopGestureRecognizer, 运行时打印手势的targets和action
        
        // 手势直接添加到view上没有作用, 直接获取interactivePopGestureRecognizer的target和action, 重新创建个手势
//        view.addGestureRecognizer(interactivePopGestureRecognizer!)
        
        // 通过打印, targets是集合, 转成自己能用的类型
        guard let targets = interactivePopGestureRecognizer?.value(forKey: "_targets") as? [AnyObject] else { return }
        let targetObjc = targets[0]
        print(targetObjc) // (action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fab12f8a7e0>)
        // 获取target
        let target = targetObjc.value(forKey: "target")
        // 通过KVC获取action会报错, 通过打印的内容 可以自己创建一个action
//        let action = targetObjc.value(forKey: "action") // 会报错
        let action = Selector(("handleNavigationTransition:"))
//        let action = nil
        let pan = UIPanGestureRecognizer(target: target, action: action)
        view.addGestureRecognizer(pan)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
}

