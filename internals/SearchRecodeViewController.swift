//
//  SearchRecodeViewController.swift
//  internals
//
//  Created by ke.liang on 2017/12/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


protocol SearchResultDelegate {
    
    func ShowSearchResults(word:String)
    
}

class SearchRecodeViewController: UIViewController {

    // recordDefaultData
    let userData = localData.shared
    
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
    
    
    // 第一个tableview 显示catalog和历史记录
    var HistoryTable:UITableView!
    
    var FilterTable:UITableView!
       
    
    
    var delegate:UISearchRecordDelegatae?
    
    
    // 第二个tableview 显示关键字匹配结果
    var keyword = ""{
        willSet{
            ShowHistoryTable = false
            //计算
            
        }
    }
    var matchRecords:[String] = [""]
    
    
    // delegate
    var resultDelegate:SearchResultDelegate?
    
    var AddHistoryItem = false{
        willSet{
            hcount  = newValue ? (userData.getSearchHistories()?.count)! + 1: (userData.getSearchHistories()?.count)! - 1
            self.HistoryTable.reloadData()
        }
    }
    var hcount  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //
        //userData.removeAllHistory()
       
        
        userData.appendSearchHistories(value: "测试1")
        userData.appendSearchHistories(value: "测试2")
        hcount  =  1 + (userData.getSearchHistories()?.count)!

        self.view.backgroundColor = UIColor.lightGray
        
        HistoryTable = UITableView.init()
        HistoryTable.delegate = self
        HistoryTable.dataSource = self
        HistoryTable.backgroundColor = UIColor.lightGray
        HistoryTable.isHidden = false
        HistoryTable.tableFooterView = UIView.init()
        HistoryTable.register(HistoryRecordCell.self, forCellReuseIdentifier: HistoryRecordCell.identity())
        HistoryTable.tableHeaderView =  RecordHeaderView()
        
        
        FilterTable = UITableView.init()
        FilterTable.dataSource = self
        FilterTable.delegate = self
        FilterTable.isHidden = true
        FilterTable.backgroundColor = UIColor.white
        FilterTable.tableFooterView = UIView.init()
        self.view.addSubview(HistoryTable)
        self.view.addSubview(FilterTable)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func RecordHeaderView() -> UIView{
        
        let tags = ["咨询","设计","人事","IOS","法律","公关","财务","云计算","创业","python","地产","iphone"]
        let view = UIView.init()
        view.backgroundColor = UIColor.lightGray
        var height = 0
        let tag = UILabel.init()
        tag.text = "热门搜索"
        tag.textColor = UIColor.gray
        tag.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(tag)
        _  = tag.sd_layout().leftSpaceToView(view,10)?.topSpaceToView(view,10)?.widthIs(100)?.heightIs(30)
        
        let sub = UIView.init()
        view.addSubview(sub)
        _ = sub.sd_layout().topSpaceToView(tag,0)?.leftSpaceToView(view,10)?.rightSpaceToView(view,10)?.bottomSpaceToView(view,10)
        
        let n1 = tags.count / 3
        var res = tags.count % 3
        var row = 0
        height = (n1+res) * 50
        var x = 0
        var y = 0
        for (index, item) in tags.enumerated(){
            
            if (index %  3 == 0  && index != 0) {
                row += 1
            }
            let btn = UIButton.init(type: .custom)
            btn.setTitle(item, for: .normal)
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(UIColor.blue, for: .normal)
            btn.addTarget(self, action: #selector(chooseTag), for: .touchUpInside)
            res = index  % 3
            switch res{
            case 0:
                x = 20
                
            case 1:
                x = 130
               
            case 2:
                x = 240
               
            default:
                break
            }
            y = row*35 + 5
           
            btn.frame = CGRect.init(x: x, y: y, width: 100, height: 30)
           
            sub.addSubview(btn)
        }
      
        view.frame = CGRect.init(x: 0, y: 0, width: Int(self.view.size.width), height:  height + 10)
        return view
        
        
    }
    
    @objc func chooseTag(_ sender:UIButton){
        print(sender)
        // 显示 searchresultView
        self.resultDelegate?.ShowSearchResults(word: (sender.titleLabel?.text)!)
    }
    
    @objc func deleteRecord(_ sender:UIButton){
        print("delete \(sender.tag)")
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
                cell.textLabel?.text = "清楚历史"
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
