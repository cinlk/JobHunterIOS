//
//  SearchRecodeViewController.swift
//  internals
//
//  Created by ke.liang on 2017/12/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


protocol SearchResultDelegate: class{
    
    func ShowSearchResults(word:String)
    
}

class SearchRecodeViewController: UIViewController {

    private let userData = localData.shared
    
    var ShowHistoryTable:Bool = true {
        willSet{
            if newValue{
                HistoryTable.isHidden = false
                FilterTable.isHidden = true
            }else{
                HistoryTable.isHidden = true
                FilterTable.isHidden = false
            }
        }
    }
    
    
    
    // 搜索历史
    lazy var HistoryTable:UITableView = {
        
        let HistoryTable = UITableView.init()
        HistoryTable.backgroundColor = UIColor.lightGray
        HistoryTable.isHidden = false
        HistoryTable.tableFooterView = UIView.init()
        HistoryTable.register(HistoryRecordCell.self, forCellReuseIdentifier: HistoryRecordCell.identity())
        //HistoryTable.tableHeaderView =  RecordHeaderView()
        return HistoryTable
    }()
    // 匹配搜索记录
    lazy var FilterTable:UITableView = {
        let FilterTable = UITableView.init()
        FilterTable.isHidden = true
        FilterTable.backgroundColor = UIColor.white
        FilterTable.tableFooterView = UIView.init()
        return FilterTable
    }()
       
    
    
    weak var delegate:UISearchRecordDelegatae?
    
    private var matchRecords:[String] = [""]
    
    
    // delegate
    weak var resultDelegate:SearchResultDelegate?
    
    var AddHistoryItem = false{
        willSet{
            hcount  = newValue ? (userData.getSearchHistories()?.count)! + 1: (userData.getSearchHistories()?.count)! - 1
            self.HistoryTable.reloadData()
        }
    }
    
    private var hcount  = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        userData.appendSearchHistories(value: "测试1")
        userData.appendSearchHistories(value: "测试2")
        hcount  =  1 + (userData.getSearchHistories()?.count)!
        // 加载tags
        let tags = ["咨询","设计","人事","IOS","法律","公关","财务","云计算","创业","python","地产","iphone"]
        let vtag:UIView =  UIView.RecordHeaderView(tags: tags)
        vtag.viewWithTag(1)?.subviews.forEach {  (v) in
        
            if v.isKind(of: UIButton.self){
                (v as! UIButton).addTarget(self, action: #selector(chooseTag), for: .touchUpInside)
            }
        }
        HistoryTable.tableHeaderView = vtag
        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(HistoryTable)
        self.view.addSubview(FilterTable)
        HistoryTable.delegate = self
        HistoryTable.dataSource = self
        FilterTable.delegate = self
        FilterTable.dataSource = self

    }

    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ShowHistoryTable = true
        hcount  =  1 + (userData.getSearchHistories()?.count)!
       
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ShowHistoryTable = true 
        
        
    }
    
    override func viewWillLayoutSubviews() {
        _ = HistoryTable.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        _ = FilterTable.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        
    }

}


extension SearchRecodeViewController{
    
    @objc func chooseTag(_ sender:UIButton){
        // 显示 searchresultView
         self.resultDelegate?.ShowSearchResults(word: (sender.titleLabel?.text)!)
    }
    
    @objc func deleteRecord(_ sender:UIButton){
        self.HistoryTable.beginUpdates()
        let text =  (self.HistoryTable.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as? HistoryRecordCell)?.item.text
        userData.deleteSearcHistories(item: text ?? "")
        hcount -= 1
        self.HistoryTable.deleteRows(at: [IndexPath.init(row: sender.tag, section: 0)], with: .none)
        self.HistoryTable.reloadData()
        self.HistoryTable.endUpdates()
       
        
        
    }
}
extension SearchRecodeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.HistoryTable{
            return hcount
        }
            return matchRecords.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell.init()
        if tableView == self.HistoryTable{
            if  indexPath.row  == hcount - 1{
                cell.textLabel?.text = "清除历史记录"
                cell.textLabel?.textAlignment  = .center
                cell.isHidden =  hcount == 1 ? true:false
                return cell
            }
           guard let  hcell = tableView.dequeueReusableCell(withIdentifier: HistoryRecordCell.identity()) as? HistoryRecordCell else{
                return cell
            }
            hcell.deleteIcon.tag = indexPath.row
            hcell.deleteIcon.addTarget(self, action: #selector(deleteRecord), for: .touchUpInside)
            hcell.item.text = userData.getSearchHistories()?[indexPath.row]
            return hcell
            
        }else{
            cell.textLabel?.text = matchRecords[indexPath.row]
        }
        
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var word = ""
        if tableView == self.HistoryTable{
            if indexPath.row == hcount  - 1 {
                userData.removeAllHistory()
                hcount = 1
                tableView.reloadData()
                return
            }
            let cell = tableView.cellForRow(at: indexPath) as! HistoryRecordCell
            word = cell.item.text ?? ""
            cell.selectionStyle = .none
        }else{
            let cell = tableView.cellForRow(at: indexPath)
            word  = cell?.textLabel?.text ?? ""
        }
        self.resultDelegate?.ShowSearchResults(word: word)
        
    }
    
    
    
}

extension SearchRecodeViewController:UISearchRecordDelegatae{
    
    func showHistory(){
        ShowHistoryTable = true
        AddHistoryItem = true 
        
    }
    func listRecords(word:String){
        ShowHistoryTable = false
        // 过滤匹配
        matchRecords.removeAll()
        matchRecords.append(contentsOf: InitailData.shareInstance.datas.filter { (item) -> Bool in
            
            return item.lowercased().contains(word.lowercased())
        })        
        self.FilterTable.reloadData()
        
        
    }
}
