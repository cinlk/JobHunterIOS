//
//  ReplyToMeVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let navTitle:String = "回复我的"

class ReplyToMeVC: ForumMessageBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func setViews() {
        self.title = navTitle
        
        super.setViews()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    deinit {
        print("deinit reply2MeVC \(String.init(describing: self))")
    }
}




extension ReplyToMeVC {
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = thumbDatas[indexPath.row]
        
        if mode.body?.kind == .post{
            // 显示回帖
            let comment = CommentViewController()
             comment.data = (message:mode, type: .reply)
            self.navigationController?.pushViewController(comment, animated: true)
            //  显示回帖  和指定的部分评论
        }else if mode.body?.kind == .reply{
            let comment = CommentViewController()
            comment.data = (message:mode, type: .subReply)
            self.navigationController?.pushViewController(comment, animated: true)
            
        }else{
            // 显示回帖  和指定的部分评论
            let comment = CommentViewController()
            comment.data = (message:mode, type: .subReply)
            self.navigationController?.pushViewController(comment, animated: true)
        }
    }
}


extension ReplyToMeVC{
    // 获取  我回复的 帖子，回帖 评论
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            
            // 回复帖子
            for _ in 0..<5{
            
                if let data = ForumMessage(JSON: [
                    "postId": Utils.getUUID(),
                    "firstCommentID": Utils.getUUID(),
                    "time":Date().timeIntervalSince1970,
                    "body":
                        ["action":"reply",
                                                                        "senderName":"小小大大","target":"post","title":"帖子标题","replyContent":"我的内容当前为多群无多群当前为多群"]]){
                    self?.thumbDatas.append(data)
                }
            }
            
            
            // 回复回帖
            for _ in 0..<5{
                if let data = ForumMessage(JSON: ["postId":Utils.getUUID(),"firstCommentID":Utils.getUUID(),
                                                  "time":Date().timeIntervalSince1970,"subReplyID":Utils.getUUID(),"body":["action":"reply",
                                                                                              "senderName":"当前的无群","target":"reply","title":"我的回帖内容当前为多群无多当前为多群无多群无多群无当前为多群无多群无多群无当前为多无群多群","replyContent":"我的内容当前为多群无多群当前为多群当前为多群无当前的群无"]]){
                    self?.thumbDatas.append(data)
                }
            }
            
            // 回复评论
            for _ in 0..<5{
                if let data = ForumMessage(JSON: ["postId":Utils.getUUID(),"firstCommentID":Utils.getUUID(),
                                                  "time":Date().timeIntervalSince1970,"subReplyID":Utils.getUUID(),"body":["action":"reply",
                                                                                              "senderName":"当前为多群","target":"subReply","title":"我的回评论","replyContent":"内退热当前为多"]]){
                    self?.thumbDatas.append(data)
                }
            }
            
            
            Thread.sleep(forTimeInterval: 1)
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
    
}




