//
//  HomeViewController.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/3/27.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
        
        setupContentView()
    }
    private func setupNavigationBar() {
        // 1.左侧logoItem
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        // 2.右侧收藏的item
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(followItemClick))
        
        // 3.搜索框
        let searchFrame = CGRect(x: 0, y: 0, width: 800, height: 32)
        
        let searchBar = UITextField(frame: searchFrame)
        searchBar.textColor = .white
        searchBar.layer.borderColor = UIColor(hex: "#999999")?.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = 5
        searchBar.layer.masksToBounds = true
        searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchBar.leftViewMode = .always
        searchBar.attributedPlaceholder = NSAttributedString(string: "主播昵称/房间号/链接", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#999999")!, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        navigationItem.titleView = searchBar
        
        searchBar.tintColor = .white
    }
    
    private func setupContentView() {
        // 获取数据
        let homeTypes = loadTypeData()
        
        // 创建主题内容
        var style = GCPageStyle()
        style.isScrollEnable = true
        print(kNavigationBarHeight + kTabBarHeight)
        let pageFrame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kNavigationBarHeight - kTabBarHeight)
        let titles = homeTypes.map({ $0.title })
        var childVcs = [AnchorViewController]()
        for type in homeTypes {
            let anchorVc = AnchorViewController()
            anchorVc.homeType = type
            childVcs.append(anchorVc)
        }
        let pageView = GCPageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style: style)
        view.addSubview(pageView)
    }
    
    private func loadTypeData() -> [HomeType] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String: Any]]
        var tempArray = [HomeType]()
        for dict in dataArray {
            tempArray.append(HomeType(dict: dict))
        }
        return tempArray
    }
}

// MARK:- 事件监听函数
extension HomeViewController {
    @objc private func followItemClick() {
        print("----")
    }
}
