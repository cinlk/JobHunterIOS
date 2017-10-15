//
//  forumView.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

///  通信测试界面  零时测试
import UIKit

class forumView: UIViewController,UITextFieldDelegate {
    // protobuf struct
    
    var textfield:UITextField?
    var sendButton:UIButton?
    var connectButton:UIButton?
    var disconButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor  = UIColor.white
        textfield  = UITextField.init()
        textfield?.placeholder = ""
        textfield?.borderStyle = .line
        textfield?.delegate = self
        
        sendButton = UIButton.init()
        sendButton?.setTitle("发送", for: .normal)
        sendButton?.backgroundColor = UIColor.lightGray
        sendButton?.setTitleColor(UIColor.black, for: .normal)
        sendButton?.addTarget(self, action: #selector(send), for: .touchUpInside)
        
        connectButton = UIButton.init(type: .custom)
        connectButton?.setTitle("连接", for: .normal)
        connectButton?.backgroundColor = UIColor.lightGray
        connectButton?.setTitleColor(UIColor.black, for: .normal)
        connectButton?.addTarget(self, action: #selector(connect), for: .touchUpInside)

        disconButton = UIButton.init(type: .custom)
        disconButton?.setTitle("断开连接", for: .normal)
        
        disconButton?.backgroundColor = UIColor.lightGray
        disconButton?.setTitleColor(UIColor.black, for: .normal)
        disconButton?.addTarget(self, action: #selector(disconnect), for: .touchUpInside)

        
        
        self.view.addSubview(textfield!)
        self.view.addSubview(sendButton!)
        self.view.addSubview(connectButton!)
        self.view.addSubview(disconButton!)
        
       _ =  textfield?.sd_layout().topSpaceToView(self.view,100)?.centerXEqualToView(self.view)?.widthIs(180)?.heightIs(35)
       _ = sendButton?.sd_layout().topSpaceToView(textfield,20)?.centerXEqualToView(self.view)?.widthIs(120)?.heightIs(20)
        
       _ = connectButton?.sd_layout().topSpaceToView(sendButton,20)?.centerXEqualToView(self.view)?.widthIs(120)?.heightIs(20)
       
       _ = disconButton?.sd_layout().topSpaceToView(connectButton,20)?.centerXEqualToView(self.view)?.widthIs(120)?.heightIs(20)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
//        self.textfield?.becomeFirstResponder()
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textfield?.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension forumView{
    func send(){
        
        if  textfield?.text?.characters.count == 0{
            return
        }
        var mess = SearchRequest()
        
        mess.pageNumber  = 1
        mess.resultPerPage  = 10
        mess.query  =  (textfield?.text)!
        //
        do{
            let json:String = try mess.jsonString()
            let protoData:Data = try mess.serializedData()
            websockDemo.share().sendMsg(mes: protoData)
            
        }catch {
            print(error)
        }
        

    }
    
    func connect(){
        print(websockDemo.share())
        websockDemo.share().connect()
        
    }
    
    func disconnect(){
        print(websockDemo.share())
        websockDemo.share().disConnect()
    }
}
