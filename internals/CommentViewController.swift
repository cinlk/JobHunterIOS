//
//  commentViewController.swift
//  internals
//
//  Created by ke.liang on 2018/7/3.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let viewTitle:String = "回帖"



class CommentViewController: SingleReplyViewController {

    
    // 第一次加载 才显示动画效果
    private var firstLoad:Bool = true
    
    internal var data:(message:ForumMessage, type:postKind)?{
        didSet{
            self.getComment()
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func setViews() {
        //progressView.isHidden = true
        super.setViews()
    }
    
    
    override func didFinishloadData() {

        super.didFinishloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "more").changesize(size: CGSize.init(width: 25, height: 20)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(more))
    }
    
    deinit {
        print("deinit commnetVC \(String.init(describing: self))")
    }
}


extension CommentViewController{
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: contentCell.identity(), for: indexPath) as? contentCell{
//            let mode = allSubReplys[indexPath.row]
//            cell.mode = mode
//            if mode.subreplyID == self.data?.message.subReplyID && firstLoad && self.data?.type == .subReply{
//                cell.isHighlighted = true
//            }
//            
//            return cell
//        }
//        
//        return UITableViewCell()
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let mode = allSubReplys[indexPath.row]
//        if mode.subreplyID == self.data?.message.subReplyID && firstLoad && self.data?.type == .subReply{
//            tableView.scrollToRow(at: indexPath, at: .none, animated: false)
//            firstLoad = !firstLoad
//
//
//        }
//    }
    
}

extension CommentViewController{
    @objc private func more(){
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let show = UIAlertAction.init(title: "查看原帖", style: .default) { [weak self] action in
            guard let `self` = self else{
                return
            }
            // 显示原帖
//            if  let id = self.mode?.replyID{
//                let post = PostContentViewController()
//                post.postID = id
//                self.navigationController?.pushViewController(post, animated: true)
//            }
          
        }
        alert.addAction(show)
//        if mycomment {
//            let delete = UIAlertAction.init(title: "删除", style: .destructive) {  [weak self] action in
//                // 服务器删除
//                // 返回，不删除跳转原来记录（海需要关联删除很多记录）
//                self?.navigationController?.popvc(animated: true)
//
//             }
//            alert.addAction(delete)
//        }
        
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}




extension CommentViewController{
    internal  func getComment() {
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            Thread.sleep(forTimeInterval: 1)
            
            // 获取回帖
            let data  = FirstReplyModel(JSON: ["id":"dqwd-dqwdqwd","replyID":Utils.getUUID(),"title":"标题题","replyContent":"当前为多群多低级趣味的精品区\n 当前为多      \t     dqwdqwdqwd   当前为多群\n 当前为多群 dqdqw","authorID":"123456","authorName":"我的名字当前为多群无多群dqwddqwd 当前为多群无多群无当前的群","authorIcon":"chicken","colleage":"北京大学","createTime":Date().timeIntervalSince1970,"kind":"jobs","isLike":false,"thumbUP":2303,"reply":101])!
            
//            DispatchQueue.main.async(execute: {
//                if self?.data?.type == .subReply{
//                    self?.subReplyID = self?.data?.message.subReplyID
//                }
//
//                self?.mode = data
//
//            })
        }
        
    }
}


