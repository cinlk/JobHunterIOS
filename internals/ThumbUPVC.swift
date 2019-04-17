//
//  ThumbUPVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate var navTitle:String = "赞"


class ThumbUPVC: ForumMessageBaseVC {

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
        print("deinit thunmUpVC \(String.init(describing: self))")
    }
    
}


extension ThumbUPVC{
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = thumbDatas[indexPath.row]
        
        if mode.body?.kind == .post{
            // 显示帖子
            let post = PostContentViewController()
            post.postID = mode.postId
            self.navigationController?.pushViewController(post, animated: true)
            
            //  显示回帖
        }else if mode.body?.kind == .reply{
            let comment = CommentViewController()
            comment.data = (message:mode, type: .reply)
            self.navigationController?.pushViewController(comment, animated: true)
            
        }else{
            // 显示 部分评论
            let comment = CommentViewController()
            comment.data = (message:mode, type: .subReply)
            self.navigationController?.pushViewController(comment, animated: true)
            
        }
        
    }
}

extension ThumbUPVC{
    
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            for _ in 0..<5{
                if let data = ForumMessage(JSON: ["postId":Utils.getUUID(),"firstCommentID":Utils.getUUID(),
                                                  "time":Date().timeIntervalSince1970,"body":["action":"thumbup",
                                                                                              "senderName":"小小大大","target":"post","title":"这是标题内容"]]){
                    self?.thumbDatas.append(data)
                }
            }
            
            
            for _ in 0..<5{
                if let data = ForumMessage(JSON: ["postId":Utils.getUUID(),"firstCommentID":Utils.getUUID(),
                                                  "time":Date().timeIntervalSince1970,"body":["action":"thumbup","senderName":"当前的无群","target":"reply","title":"我的回贴内容AA"]]){
                    self?.thumbDatas.append(data)
                }
            }
            
            for _ in 0..<5{
                if let data = ForumMessage(JSON: ["postId":Utils.getUUID(),"firstCommentID":Utils.getUUID(),
                                                  "time":Date().timeIntervalSince1970,"subReplyID":Utils.getUUID(),"body":["action":"thumbup","senderName":"当前为多群","target":"subReply","title":"老子的评论"]]){
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
