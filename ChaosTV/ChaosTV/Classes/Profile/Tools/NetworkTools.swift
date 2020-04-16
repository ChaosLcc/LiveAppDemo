//
//  NetworkTools.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/1.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit
import Alamofire
enum MethodType {
    case get
    case post
}

class NetworkTools {
    class func requestData(_ type: MethodType, URLString: String, parameters: [String: Any]? = nil, finishedCallback: @escaping (_ result: Any) -> ()) {
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        AF.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.value else {
                return
            }
            finishedCallback(result)
        }
        
    }
}
