//
//  ViewController.swift
//  ChatServer
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    fileprivate lazy var serverSocket : ServerSocket = ServerSocket()
    @IBOutlet weak var statusLabel: NSTextField!
    
    // MARK: 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startRunning(_ sender: NSButton) {
        serverSocket.start()
        
        statusLabel.stringValue = "服务器运行中ing"
    }
    
    @IBAction func stopRunning(_ sender: NSButton) {
        serverSocket.stop()
        
        statusLabel.stringValue = "服务器停止运行"
    }
}

