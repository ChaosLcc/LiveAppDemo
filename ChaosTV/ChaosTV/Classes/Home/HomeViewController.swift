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
        
        printIvars()
        
        setupUI()
    }
         func printIvars() {
    //        利用运行时获取类里面的成员变量
            var outCount: UInt32 = 0
    //        ivars实际上是一个数组
            let ivars = class_copyIvarList(UISearchBar.self, &outCount)
    //        获取里面的每一个元素
            for i in 0 ..< outCount {
    //            ivar是一个结构体的指针
                let ivar = ivars![Int(i)]
    //          获取 成员变量的名称,cName c语言的字符串,首元素地址
                guard let cName = ivar_getName(ivar) else { return }
                let name = String(cString: cName, encoding: String.Encoding.utf8)
                print("name: \(name)")
            }
    //        方法中有copy,create,的都需要释放
            free(ivars)
        }
    
    // 这里设置电池状态栏颜色是没有作用的
    // 原因: 电池状态栏的颜色是由每个页面最顶层的控制器决定的
    // HomeViewController外层还包裹着NavigationController
    // 所以下面的代码应该写到导航控制器中
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
}
// MARK:- 设置UI
extension HomeViewController {
    private func setupUI() {
        setupNavigationBar()
    }
    private func setupNavigationBar() {
        // 1.左侧logoItem
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        // 2.右侧收藏的item
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(followItemClick))
        
        // 3.搜索框
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
        let searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "主播昵称/房间号/链接"
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.textColor = .white
        } else {
            // 在iOS 13很多属性已经不允许KVC访问了, 会导致crash
            let searchField = searchBar.value(forKey: "_searchField") as? UITextField
            searchField?.textColor = .white
        }
        
        searchBar.tintColor = .white
    }
}

// MARK:- 事件监听函数
extension HomeViewController {
    @objc private func followItemClick() {
        print("----")
    }
}
