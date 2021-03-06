//
//  Emitterable.swift
//  ChaosTV
//
//  Created by Liubi_Chaos_G on 2020/4/3.
//  Copyright © 2020 Liubi_Chaos_G. All rights reserved.
//

import UIKit

protocol Emitterable {
    func startEmittering(_ point: CGPoint)
    func stopEnittering()
}
extension Emitterable where Self: UIViewController {
    func startEmittering(_ point: CGPoint) {
        // 1.创建发射器
        let emitter = CAEmitterLayer()
        
        // 2.设置发射器的位置
        emitter.emitterPosition = point
        
        // 3.开启三维效果
        emitter.preservesDepth = true
        
        var cells = [CAEmitterCell]()
        for i in 0 ..< 10 {
            // 4.创建粒子, 并且设置粒子相关的属性
            // 4.1创建粒子cell
            let cell = CAEmitterCell()
            
            // 4.2设置粒子速度
            cell.velocity = 120
            cell.velocityRange = 100
            
            // 4.3设置粒子的大小
            cell.scale = 0.9
            cell.scaleRange = 0.5
            
            // 4.4设置粒子方向
            cell.emissionLongitude = -(CGFloat.pi * 0.5)
            cell.emissionRange = CGFloat.pi / 10
            
            // 4.5设置存活时间
            cell.lifetime = 3.5
            cell.lifetimeRange = 1.8
            
            // 4.6设置粒子旋转
            cell.spin = CGFloat.pi * 2
            cell.spinRange = CGFloat.pi
            
            // 4.7设置粒子每秒弹出个数
            cell.birthRate = Float(arc4random_uniform(3))
            
            // 4.8设置粒子展示的图片
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            cells.append(cell)
        }
        
        
        // 5.将粒子设置到发射器中
        emitter.emitterCells = cells
        
        // 6.将发射器的layer添加到父layer中
        view.layer.addSublayer(emitter)
    }
    func stopEnittering() {
        view.layer.sublayers?.filter({ $0.isKind(of: CAEmitterLayer.self) })
            .first?.removeFromSuperlayer()
    }
}
