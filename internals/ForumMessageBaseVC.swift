//
//  ForumMessageBaseVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit




class ForumMessageBaseVC: BaseViewController {

    // 赞文章  和  回帖 或 评论
    
    private lazy var table:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.tableFooterView = UIView()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.register(ForumMesageCell.self, forCellReuseIdentifier: ForumMesageCell.identity())
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return tb
    }()
    
    
    
    internal lazy var thumbDatas:[ForumMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func setViews() {
        
        self.view.addSubview(table)
        _ = table.sd_layout().topEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        
        self.hiddenViews.append(table)
        super.setViews()
        
    }
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()
    }
    
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        print("deinit forumMessageBaseVC \(String.init(describing: self))")
    }
    
}


extension ForumMessageBaseVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thumbDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ForumMesageCell.identity(), for: indexPath) as? ForumMesageCell{
            cell.mode = thumbDatas[indexPath.row]
            return cell
        }
        return UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = thumbDatas[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ForumMesageCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
   
    
    
    
}







