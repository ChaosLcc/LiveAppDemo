//
//  ViewController.swift
//  PlayGif
//
//  Created by Liubi_Chaos_G on 2020/4/24.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.加载Gif图片, 并且转成Data类型
        guard let path = Bundle.main.path(forResource: "demo.gif", ofType: nil) else { return }
        guard let data = NSData(contentsOfFile: path) else { return }
        
        // 2.从data中读取数据: 将data转成CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        let imageCount = CGImageSourceGetCount(imageSource)
        
        // 3.便利所有的图片
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<imageCount {
            // 3.1.取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            if i == 0 {
                imageView.image = image
            }
            images.append(image)
            
            // 3.2.取出持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else { continue }
            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        
        // 4.设置imageView的属性
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
//        imageView.animationRepeatCount = 0
        imageView.animationRepeatCount = 1
        
        // 5.开始播放
         imageView.startAnimating()
    }


}

