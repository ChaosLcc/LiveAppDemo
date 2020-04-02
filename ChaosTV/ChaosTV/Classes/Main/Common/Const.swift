//
//  Const.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/1.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height

/**  根据类名创建控制器
 *  parameter className 控制器名称
 */
func ClassFromString(className: String) -> UIViewController? {
    let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")

    let name = "\(appName!).\(className)"
    if let tmpClass = NSClassFromString(name) as? UIViewController.Type {
        return tmpClass.init()
    }else {
        return nil
    }
}
var IsFullScreen: Bool {
    return UIApplication.shared.statusBarFrame.height == 44
}

func keyWindow() -> UIWindow? {
    var window:UIWindow? = nil
    if #available(iOS 13.0, *) {
        for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
            if windowScene.activationState == .foregroundActive {
                window = windowScene.windows.first
                break
            }
        }
        return window
    } else {
        return UIApplication.shared.keyWindow
    }
}

var kStatusBarHeight: CGFloat {
    return IsFullScreen ? 44 : 20
}

var kNavigationBarHeight: CGFloat {
   return IsFullScreen ? 88 : 64
}
    
var kBottomSafeHeight: CGFloat {
   return IsFullScreen ? 34 : 0
}
var kTabBarHeight: CGFloat {
    return IsFullScreen ? 83 : 49
}

/// 单参数打印函数
///
/// - Parameters:
///   - message:打印
///   - file: 文件名，默认值：#file
///   - line: 第几行，默认值：#line
///   - method: 函数名，默认值：#function
func printLog(_ message: Any,
              file: String = #file,
              line: Int = #line,
              method: String = #function)
{
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}


/// 可变参打印函数
///
/// - Parameters:
///   - items: Zero or more items to print.
///   - separator: A string to print between each item. The default is a single space (`" "`).
///   - terminator: The string to print after all items have been printed. The  default is a newline (`"\n"`).
///   - file: 文件名，默认值：#file
///   - line: 第几行，默认值：#line
///   - method: 函数名，默认值：#function
func printLog(_ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    file: String = #file,
    line: Int = #line,
    method: String = #function)
{
    #if DEBUG
    //如果不怕打印结果有大括号[4, "abc", [1, 2, 3]]，可以直接一句话
    //print("\((file as NSString).lastPathComponent)[\(line)], \(method):", items)
    print("\((file as NSString).lastPathComponent)[\(line)], \(method):", terminator: separator)
    var i = 0
    let j = items.count
    for a in items {
        i += 1
        print(a, terminator:i == j ? terminator: separator)
    }
    #endif
}
