//
//  XiaoMi.swift
//  internals
//
//  Created by ke.liang on 2018/1/10.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class XiaoMi: UITableViewController {

    
    var news:[xiaomiNewsModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.separatorStyle = .none
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(xiaomiTableCell.self, forCellReuseIdentifier: xiaomiTableCell.identity())
     
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: xiaomiTableCell.identity(), for: indexPath) as! xiaomiTableCell
        cell.mode = news[indexPath.row]
        return cell
      
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = news[indexPath.row]
       
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: xiaomiTableCell.self, contentViewWidth: ScreenW)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let webView = baseWebViewController()
        // 只能是https 不能是http
        webView.mode = "http://www.jianshu.com/users/040395b7230c/latest_articles"
        self.navigationController?.pushViewController(webView, animated: true)
        
    }

}

extension XiaoMi{
    private func loadData(){
        
        news.append(xiaomiNewsModel(JSON: ["create_time":"2018-03-12","coverPicture":"b3","describetion":"今日头条, 今日头条,今日头条,今日头条,今日头条,今日头条,今日头条 dqwdqwd 达瓦大群无多群无 当前为多群无多 当前为多群多无群 当前为多"])!)
        news.append(xiaomiNewsModel(JSON: ["create_time":"2018-03-12","coverPicture":"xiaomiDefault","describetion":"今日头条, 今日头条,今日头条,今日头条,今日头条,今日头条,今日头条"])!)
        self.tableView.reloadData()
        
    }
}
