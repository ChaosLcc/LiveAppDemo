//
//  ClientManager.swift
//  ChatServer
//
//  Created by apple on 16/11/14.
//  Copyright © 2016年 coderwhy. All rights reserved.
//

import Cocoa

class ClientManager: NSObject {
    var tcpClient : TCPClient?
    var username : String = ""
    var isClientRunning = false
    weak var socketServer : ServerSocket?
}

extension ClientManager {
    func startReadMsg() {
        while true{
            if let msg=self.readMsg(){
                print(msg)
                
                // 5.判断是否有姓名，有则保存起来
                if msg["msgType"] as! Int == 0 {
                    username = msg["nickname"] as! String
                }
                
                // 6.服务器处理消息
                socketServer?.processMsg(self, msg)
            }else{
                socketServer?.removeClient(clientMgr: self)
                break
            }
        }
    }
    
    /*
    func sendMsg(_ msgDict : [String : String]) {
        guard let msgData = try? JSONSerialization.data(withJSONObject: msgDict, options: .prettyPrinted) else { return }
        var length = msgData.count
        let data:NSMutableData=NSMutableData(bytes: &length, length: 4)
        _ = self.tcpClient!.send(data: data as Data)
        _ = self.tcpClient!.send(data: msgData)
    }
    */
    
    
    //发送消息
    func sendMsg(_ msg:NSDictionary){
        let jsondata=try? JSONSerialization.data(withJSONObject: msg, options:
            JSONSerialization.WritingOptions.prettyPrinted)
        var len:Int32=Int32(jsondata!.count)
        let data:NSMutableData=NSMutableData(bytes: &len, length: 4)
        _ = self.tcpClient?.send(data: data as Data)
        _ = self.tcpClient?.send(data: jsondata!)
    }
    
    private func readMsg() -> [String : Any]? {
        guard let data = tcpClient?.read(4) else {
            return nil
        }
        guard data.count == 4 else {
            return nil
        }
        
        let hdata = Data(bytes: data, count: data.count)
        
        var length : Int32 = 0
        (hdata as NSData).getBytes(&length, length: data.count)
        
        guard let buff = tcpClient?.read(Int(length)) else {
            return nil
        }
        
        let msgData = Data(bytes: buff, count: buff.count)
        let msgDict = try! JSONSerialization.jsonObject(with: msgData, options: .mutableContainers) as! [String : Any]
        
        return msgDict
    }
}
