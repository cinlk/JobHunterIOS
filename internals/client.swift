//
//  client.swift
//  internals
//
//  Created by ke.liang on 2017/10/7.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import SocketRocket



enum DisconnectType:Int {
    case disConnectByServer = 1001,
    disConnectByUser
}

//SocketRocket

class websockDemo:NSObject, SRWebSocketDelegate{
    
    var host = "10.211.55.8"
    var port = 8088
    var websockt:SRWebSocket?
    var heartBeat:Timer?
    var reConnect:TimeInterval?
    
   
    
    private static var demo:websockDemo?
    
    static func share()->websockDemo{
        if demo == nil{
            demo = websockDemo.init()
        }
        return demo!
    }
    
    func initSocket(){
        
        if  websockt != nil{
            return
        }
        
        websockt = SRWebSocket.init(url: URL.init(string: String.init(format: "ws://%@:%d", host,port)), protocols: nil, allowsUntrustedSSLCertificates: false)
        
        websockt?.delegate = self
        
        // 代理线程
        let queue:OperationQueue = OperationQueue.init()
        
        queue.maxConcurrentOperationCount = 4
        websockt?.setDelegateOperationQueue(queue)
        //连接
        websockt?.open()
        
    }
    
    
    // 初始化心跳
    func intialHeartBeat(){
        
        
            print("start hb")
            self.destroyHeatBeat()
        DispatchQueue.global().async {
            
            self.heartBeat = Timer.scheduledTimer(withTimeInterval: 1*60, repeats: true, block: {
                _ in
                print("heart")
                
                self.sendMsg(mes: "heart".data(using: String.Encoding.utf8)!)
                
            })
            
            print("aha \(self.heartBeat)")
            RunLoop.current.add(self.heartBeat!, forMode: .commonModes)

        }
        
        
        
        
    }
    
    
    func destroyHeatBeat(){
        DispatchQueue.main.async(execute: {
            
            if  self.heartBeat != nil{
                self.heartBeat?.invalidate()
                self.heartBeat = nil
            }
            
        
        
        })
    }
    
    func connect(){
        self.initSocket()
        
        self.reConnect = 0
        
    }
    
    // 1002 是用户关闭
    func disConnect(){
        if websockt != nil{
            websockt?.close(withCode: DisconnectType.disConnectByUser.rawValue, reason: "用户主动断开")
            websockt = nil
        }
    }
    
    func reConnects(){
        self.disConnect()
        if reConnect! > 64{
            return
        }
        

        let time = DispatchTime.now() + self.reConnect! * Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time){
            self.websockt = nil
            self.initSocket()
        }
        
        
        if reConnect == 0 {
            reConnect = 2
        }else{
            reConnect! *= 2
        }
        
    }
    
    
    func sendMsg(mes:Any){
        
        self.websockt?.send(mes)
    }
    
    
    func ping(){
        if websockt != nil{
            self.websockt?.sendPing(nil)
        }
    }
    
    
    
}

extension websockDemo{
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        
        print("连接成功")
        self.intialHeartBeat()
    }

    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        if websockt?.readyState == .OPEN{
            do{
                if let mess = message as? Data{
                    let mess = try SearchRequest(serializedData: mess)
                    print("收到消息 \(mess)")
                }

            }catch{
                print(error)
            }
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print("连接失败")
        self.reConnects()
        
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        print("收到pong\( String.init(data: pongPayload, encoding: String.Encoding.utf8))")
        
    }
    // 意外中断
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {

        if code == DisconnectType.disConnectByUser.rawValue{
            print("用户关闭")
            self.disConnect()
        }else{
            print("其他原因关闭，重连接")
            self.reConnects()
        }
        
        self.destroyHeatBeat()

    }
    //消息格式转换
    func webSocketShouldConvertTextFrame(toString webSocket: SRWebSocket!) -> Bool {
        return true
    }
}
