//
//  BasePostItemsViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class BasePostItemsViewController: BaseViewController {

    
    private var modes:[PostArticleModel] = []
    
    // 帖子主题类型
    internal var type:forumType?
    
   
    
    private lazy var table:UITableView = { [unowned self] in
        let table = UITableView()
        table.tableFooterView = UIView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.viewBackColor()
        table.register(listPostItemCell.self, forCellReuseIdentifier: listPostItemCell.identity())
        return table
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        

    }
    
   
    
    
    override func setViews() {
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        self.handleViews.append(table)
        super.setViews()
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }


}


extension BasePostItemsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: listPostItemCell.identity(), for: indexPath) as? listPostItemCell{
            cell.mode = modes[indexPath.row]
            return cell 
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = modes[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: listPostItemCell.self, contentViewWidth: ScreenW)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let post = PostContentViewController()
        post.postID = "ddqw-dwqdq"
        post.hidesBottomBarWhenPushed = true 
        self.navigationController?.pushViewController(post, animated: true)
        
    }
    
    
}

extension BasePostItemsViewController{
    
    private func loadData(){
        
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            
            for _ in 0..<10{
                self?.modes.append(PostArticleModel(JSON: ["id":"dqwd-dqwdqwd","title":"标题题","authorID":"dqwddqwdd","authorName":"我的名字","authorIcon":"chicken","createTime":Date().timeIntervalSince1970,"kind":"jobs","thumbUP":2303,"reply":101])!)
            }
            
            DispatchQueue.main.async {
                self?.didFinishloadData()
            }
            
            
        }
        
        
       
        
    }
}
