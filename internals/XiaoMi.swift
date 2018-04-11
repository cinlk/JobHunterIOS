//
//  XiaoMi.swift
//  internals
//
//  Created by ke.liang on 2018/1/10.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let titleHeaderH:CGFloat = 45


class XiaoMi: UITableViewController {

    
    private var news:[xiaomiNewsModel] = []
    
    
    private lazy var  errorView:ErrorPageView = {  [unowned self] in
        let eView = ErrorPageView.init(frame: self.view.bounds)
        eView.isHidden = true
        // 再次刷新
        eView.reload = reload
        
        return eView
    
    }()
    
    
    private lazy var hub:MBProgressHUD = { [unowned self] in
        
        let  hub = MBProgressHUD.showAdded(to: self.backHubView, animated: true)
        hub.mode = .indeterminate
        hub.label.text = "加载数据"
        hub.removeFromSuperViewOnHide = false
        hub.margin = 10
        hub.label.textColor = UIColor.black
        return hub
        
    }()
    
    
    // tableview 是第一个view，不能直接使用为hub的背景view
    // 调整高度，不能挡住titleView
    private lazy var backHubView:UIView = { [unowned self] in
        let view = UIView.init(frame: CGRect.init(x: 0, y: titleHeaderH + NavH, width: ScreenW, height: ScreenH - titleHeaderH - NavH ))
        view.backgroundColor = UIColor.white
        self.navigationController?.view.insertSubview(view, at: 1)
        view.isHidden = true
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        loadData()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        backHubView.removeFromSuperview()
        hub.removeFromSuperview()
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
    
    private func setView(){
        
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.separatorStyle = .none
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(xiaomiTableCell.self, forCellReuseIdentifier: xiaomiTableCell.identity())
        
        hub.show(animated: true)
        self.tableView.isHidden = true
        backHubView.isHidden = false
    }
    
    private func didFinishloadData(){
        hub.hide(animated: true)
        backHubView.isHidden = true
        self.tableView.isHidden = false
        errorView.isHidden = true
        hub.removeFromSuperview()
        self.tableView.reloadData()
    }
    
    private func showError(){
        hub.hide(animated: true)
        errorView.isHidden = false
        backHubView.isHidden = false
    }
    
    private func reload(){
        
        hub.show(animated: true)
        backHubView.isHidden = false
        self.errorView.isHidden = true
        self.loadData()
        
    }
}

extension XiaoMi{
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            
            self?.news.append(xiaomiNewsModel(JSON: ["create_time":"2018-03-12","coverPicture":"b3","describetion":"今日头条, 今日头条,今日头条,今日头条,今日头条,今日头条,今日头条 dqwdqwd 达瓦大群无多群无 当前为多群无多 当前为多群多无群 当前为多"])!)
            self?.news.append(xiaomiNewsModel(JSON: ["create_time":"2018-03-12","coverPicture":"xiaomiDefault","describetion":"今日头条, 今日头条,今日头条,今日头条,今日头条,今日头条,今日头条"])!)
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
       
        
        
    }
}
