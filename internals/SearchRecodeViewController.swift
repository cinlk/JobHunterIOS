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


fileprivate let headerViewH:CGFloat = 200
fileprivate let HeadeTitle:String = "热门搜索"

class SearchRecodeViewController: UIViewController {

    //private let userData = localData.shared
    // 搜索数据库 数据
    private let searchTable = DBFactory.shared.getSearchDB()
    private lazy var searchItems:[String]  = searchTable.getSearches()
    
    
    // 控制table的显示
    var ShowHistoryTable:Bool = true {
        willSet{
            if newValue{
                HistoryTable.isHidden = false
                FilterTable.isHidden = true
                HistoryTable.reloadData()
            }else{
                HistoryTable.isHidden = true
                FilterTable.isHidden = false
                FilterTable.reloadData()
            }
        }
    }
    
    
    
    // 搜索历史
    private lazy var HistoryTable:UITableView = {  [unowned self] in
        
        let HistoryTable = UITableView.init()
        HistoryTable.backgroundColor = UIColor.viewBackColor()
        HistoryTable.tableFooterView = UIView.init()
        HistoryTable.register(HistoryRecordCell.self, forCellReuseIdentifier: HistoryRecordCell.identity())
        //HistoryTable.tableHeaderView =  RecordHeaderView()
        HistoryTable.delegate = self
        HistoryTable.dataSource = self
        return HistoryTable
    }()
    // 匹配搜索记录
   private lazy var FilterTable:UITableView = {  [unowned self] in
        let FilterTable = UITableView.init()
        FilterTable.backgroundColor = UIColor.viewBackColor()
        FilterTable.tableFooterView = UIView.init()
        FilterTable.delegate = self
        FilterTable.dataSource = self
        return FilterTable
    }()
       
    // 热门搜索headerview
    fileprivate lazy var searchHederView:TableViewHeader = { [unowned self] in
            let h = TableViewHeader.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: headerViewH))
            h.chooseItem = { (word) in
                self.resultDelegate?.ShowSearchResults(word: word)
            
            }
            return h
    }()
    
    
    private var matchRecords:[String] = [""]
    
    private var hotItem:[String] = []
    
    // delegate
    weak var resultDelegate:SearchResultDelegate?
    
    // 添加值
    var AddHistoryItem = false{
        willSet{
            searchItems = searchTable.getSearches()
            self.HistoryTable.reloadData()
        }
    }
    
    //private var hcount  = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        //hcount  =  1 +  SqliteManager.shared.getSearches().count
        // 加载tags
       
        HistoryTable.tableHeaderView = searchHederView
        loadItemData()
        self.view.backgroundColor = UIColor.lightGray
        
        self.view.addSubview(HistoryTable)
        self.view.addSubview(FilterTable)
    }

    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ShowHistoryTable = true
        
       
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //ShowHistoryTable = true
        
        
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

    private func loadItemData(){
         hotItem = ["测试1", "测试2","测试带我当前为多群无多群去的", "测大豆纤维2", "测试2", "测试2", "测试2",
        "测试2","测试2","测试2","测试大青蛙2","当前为多"]
         searchHederView.mode = hotItem
    }
}
extension SearchRecodeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tableView == self.HistoryTable{
            return 1 +  searchItems.count
        }
            return matchRecords.count
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell.init()
        if tableView == self.HistoryTable{
            // 删除cell
            if  indexPath.row  == searchItems.count{
                cell.textLabel?.text = "清除历史记录"
                cell.textLabel?.textAlignment  = .center
                // 只有一个cell  影藏当前cell
                cell.isHidden =  searchItems.count == 0 ? true:false
                return cell
            }
           guard let  hcell = tableView.dequeueReusableCell(withIdentifier: HistoryRecordCell.identity()) as? HistoryRecordCell else{
                return cell
            }
           
            hcell.mode = searchItems[indexPath.row]
            hcell.deleteRow = { [weak self] (name) in
                
                self?.HistoryTable.beginUpdates()
                self?.searchTable.deleteSearch(name: name)
                self?.searchItems = (self?.searchTable.getSearches())!
                // 删除某个row，其他row值会改变，通过刷新reloadData 来更新row值
                self?.HistoryTable.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .none)
                self?.HistoryTable.reloadData()
                self?.HistoryTable.endUpdates()
            }
            hcell.useCellFrameCache(with: indexPath, tableView: tableView)
            return hcell
            
        }else{
            cell.textLabel?.text = matchRecords[indexPath.row]
        }
        
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if tableView == self.HistoryTable && (searchItems.count != indexPath.row){
            let mode = searchItems[indexPath.row]
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: HistoryRecordCell.self, contentViewWidth: ScreenW)
            
        }else{
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var word = ""
        if tableView == self.HistoryTable{
            if indexPath.row == searchItems.count  {
                //userData.removeAllHistory()
                searchItems.removeAll()
                searchTable.removeAllSearchItem()
                tableView.reloadData()
                return
            }
            let cell = tableView.cellForRow(at: indexPath) as! HistoryRecordCell
            word = cell.mode!
        }else{
            let cell = tableView.cellForRow(at: indexPath)
            word  = cell?.textLabel?.text ?? ""
        }
        self.resultDelegate?.ShowSearchResults(word: word)
        
    }
    
    
    
}

extension SearchRecodeViewController{
    
    // 根据输入框调整 recordVC 显示view
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




fileprivate class TableViewHeader:UIView{
    
    
    private lazy var label:UILabel = {
        let title = UILabel.init(frame: CGRect.zero)
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 17)
        title.textAlignment = .left
        title.text = HeadeTitle
        title.lineBreakMode = .byWordWrapping
        return title
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing =  10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize.init(width: (ScreenW - 60) / 3 , height: 25)
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
    
        let coll = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        coll.backgroundColor = UIColor.clear
        coll.dataSource = self
        coll.delegate = self
        coll.isScrollEnabled  = true
        coll.showsVerticalScrollIndicator = false
        coll.register(labelCollectionCell.self, forCellWithReuseIdentifier: "cell")
        return coll
    }()
    
    
    
    var chooseItem:((_ word:String)->Void)?
    
    var mode:[String]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.viewBackColor()
        self.addSubview(label)
        self.addSubview(collectionView)
        
        _ = label.sd_layout().leftSpaceToView(self,20)?.topSpaceToView(self,20)?.autoHeightRatio(0)
        _ = collectionView.sd_layout().leftEqualToView(label)?.rightSpaceToView(self,20)?.topSpaceToView(label,5)?.bottomEqualToView(self)
        
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

extension TableViewHeader:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! labelCollectionCell
        if let mode = mode{
            cell.label.text = mode[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let word = mode?[indexPath.row]{
            self.chooseItem?(word)
        }
    }
    
    
    
    
}


private class labelCollectionCell:UICollectionViewCell{
    
    fileprivate lazy var label:UILabel = {
        let l = UILabel.init(frame: CGRect.zero)
        l.font = UIFont.systemFont(ofSize: 16)
        l.textAlignment = .center
        l.setSingleLineAutoResizeWithMaxWidth((ScreenW - 60) / 3)
        l.textColor = UIColor.blue
        
        
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(label)
        _ = label.sd_layout().centerXEqualToView(self.contentView)?.centerYEqualToView(self.contentView)?.heightIs(25)
        label.setMaxNumberOfLinesToShow(1)
    }
    
}
