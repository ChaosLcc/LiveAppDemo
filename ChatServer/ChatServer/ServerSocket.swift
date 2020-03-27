//
//  ServerSocket.swift
//  ChatServer
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import Cocoa

class ServerSocket: NSObject {
    
    // MARK: 属性
    fileprivate lazy var serverSocket : TCPServer = TCPServer(addr : "127.0.0.1", port: 7000)
    fileprivate var isServerRunning : Bool = false
    fileprivate var clients : [ClientManager] = [ClientManager]()
}


extension ServerSocket {
    func start() {
        // 启动服务器
        serverSocket.listen()
        isServerRunning = true
        
        // 开启线程，用于接收客户端
        DispatchQueue.global().async {
            while self.isServerRunning {
                let client = self.serverSocket.accept()
                
                if let client = client {
                    DispatchQueue.global().async {
                        self.handleClient(client: client)
                    }
                }
            }
        }
    }
    
    func stop() {
        
    }
}


extension ServerSocket {
    fileprivate func handleClient(client : TCPClient) {
        let clientMgr = ClientManager()
        clientMgr.socketServer = self
        clientMgr.tcpClient = client
        clientMgr.isClientRunning = true
        clients.append(clientMgr)
        clientMgr.startReadMsg()
    }
    
    
    
    func processMsg(_ clientMsg : ClientManager, _ msgDict : [String : Any]) {
        var sendMsg = msgDict
        
        let msgType = sendMsg["msgType"] as! Int
        
        if msgType == 0 {
            print("进入房间")
        } else if msgType == 1 {
            sendMsg["nickname"] = clientMsg.username
        } else if msgType == 2 {
            sendMsg["nickname"] = clientMsg.username
        } else if msgType == 10 {
            sendMsg["nickname"] = clientMsg.username
            let index = clients.index(of: clientMsg)!
            clients.remove(at: index)
        }
        
        for mgr in clients {
            mgr.sendMsg(sendMsg as NSDictionary)
        }
    }
    
    func removeClient(clientMgr : ClientManager) {
        processMsg(clientMgr, ["msgType" : 10, "nickname" : clientMgr.username])
    }
}
