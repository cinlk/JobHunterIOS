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


fileprivate let HeadeTitle:String = "热门搜索"
fileprivate let searchHistory:String = "搜索历史"


class SearchRecodeViewController: UIViewController {
    
  
    
    // 搜索数据库 数据
    private let searchTable = DBFactory.shared.getSearchDB()
    // 主界面职位搜索记录
    private  var searchItems:[String]  = []
    
    // 论坛搜索记录  MARK
    //private lazy var articlItems:[String]  = searchTable.getSearches()
    
    // 控制table的显示
    private var ShowHistoryTable:Bool = true {
        willSet{
            
            searchItems = searchTable.getSearches(type: searchType)

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
        HistoryTable.backgroundColor = UIColor.white
        HistoryTable.tableFooterView = UIView.init()
        //HistoryTable.tableHeaderView =  RecordHeaderView()
        HistoryTable.delegate = self
        HistoryTable.dataSource = self
        return HistoryTable
    }()
    // 匹配搜索记录
   private lazy var FilterTable:UITableView = {  [unowned self] in
        let FilterTable = UITableView.init()
        FilterTable.backgroundColor = UIColor.white
        FilterTable.tableFooterView = UIView.init()
        FilterTable.delegate = self
        FilterTable.dataSource = self
        return FilterTable
    }()
       
    // 热门搜索headerview
    fileprivate lazy var searchHederView:TableViewHeader = { [unowned self] in
            let h = TableViewHeader.init(frame: CGRect.zero)
            h.backgroundColor = UIColor.white
        
            h.chooseItem = { (word) in
                self.resultDelegate?.ShowSearchResults(word: word)
            
            }
            return h
    }()
    
    private lazy var clearAllLabel:UIView = {
        
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 40))
        v.backgroundColor = UIColor.clear
        v.isUserInteractionEnabled = true
        
        let  label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.text = "清除历史记录"
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(deleteAll))
        label.addGestureRecognizer(gesture)
        
        v.addSubview(label)
        _ = label.sd_layout().centerYEqualToView(v)?.centerXEqualToView(v)?.autoHeightRatio(0)
        return v
        
    }()
    
    
    //
    private var matchRecords:[String] = [""]
    
    internal var searchType:String = ""{
        didSet{
            
            searchItems = searchTable.getSearches(type: searchType)
            HistoryTable.reloadData()
            
        }
    }
    
    // 热门搜索数据
    internal var hotItem:[String] = []{
        didSet{
            searchHederView.mode = hotItem
            searchHederView.layoutSubviews()
            HistoryTable.tableHeaderView = searchHederView
        }
    }
    
    // delegate
    weak var resultDelegate:SearchResultDelegate?
    

    
    //private var hcount  = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        
        //isForum = false
        HistoryTable.tableFooterView = clearAllLabel
    
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

    
}
extension SearchRecodeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
       
        tableView.tableFooterView?.isHidden =  searchItems.count == 0 ? true : false
        
        return tableView == self.HistoryTable ? (searchItems.count  == 0 ? 0 : searchItems.count + 1) : matchRecords.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell()
        if tableView == self.HistoryTable{
            // 标题
            if indexPath.row == 0 && searchItems.count > 0 {
                
                let cell = UITableViewCell.init()
                cell.selectionStyle = .none
                cell.textLabel?.text =  "搜索记录"
                cell.backgroundColor = UIColor.clear
                cell.layer.borderWidth = 0
                
                cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0)
                return cell
                
            }
          
            let rowCell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            rowCell.backgroundColor = UIColor.clear
            rowCell.textLabel?.text = searchItems[indexPath.row - 1]
            rowCell.textLabel?.textAlignment = .left
            rowCell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
            btn.setImage(UIImage.init(named: "cancel")?.changesize(size: CGSize.init(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .normal)
            
            btn.tag = indexPath.row - 1
            btn.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
            rowCell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0)
            rowCell.accessoryView = btn
            
            return rowCell
            
        }else{
            cell.textLabel?.text = matchRecords[indexPath.row]
        }
        
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if tableView == self.HistoryTable && indexPath.row == 0{
            return 60
        }
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var word = ""
        
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == self.HistoryTable && indexPath.row == 0{
                return
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        word  = cell?.textLabel?.text ?? ""
        
        self.resultDelegate?.ShowSearchResults(word: word)
        
    }
    
    
    
}

extension SearchRecodeViewController{
    
    // 根据输入框调整 recordVC 显示view
    func showHistory(){
        ShowHistoryTable = true
        //AddHistoryItem = true
        
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



extension SearchRecodeViewController{
    
    @objc  private func removeItem(_ sender:UIButton){
    
        guard  searchItems.count > sender.tag else {
            return
        }
    
    
        searchTable.deleteSearch(type: searchType,name: searchItems[sender.tag])
        searchItems.remove(at: sender.tag)
        HistoryTable.reloadData()
    }
    
    @objc private func deleteAll(){
        searchItems.removeAll()
        searchTable.removeAllSearchItem(type:searchType)
        HistoryTable.reloadData()
    }
}



// 头部
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
        layout.minimumInteritemSpacing = 5
        // 每行3个元素
        layout.itemSize = CGSize.init(width: (ScreenW - 60) / 4 , height: 20)
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        // collection view  初始高度
        let coll = UICollectionView.init(frame: CGRect.init(x: 0, y: 25, width: ScreenW - 40, height: ScreenH), collectionViewLayout: layout)
        coll.backgroundColor = UIColor.clear
        coll.dataSource = self
        coll.delegate = self
        coll.isScrollEnabled  = false
        coll.showsVerticalScrollIndicator = false
        coll.register(labelCollectionCell.self, forCellWithReuseIdentifier: "cell")
        return coll
    }()
    
    
    
    var chooseItem:((_ word:String)->Void)?
    
    var mode:[String]?{
        didSet{
            
            self.collectionView.reloadData()
            // 布局后的高度
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height + 5

            _ = self.collectionView.sd_layout().heightIs(height)
            print(self.collectionView)
            self.setupAutoHeight(withBottomView: collectionView, bottomMargin: 5)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.viewBackColor()
        self.addSubview(label)
        self.addSubview(collectionView)
        
        _ = label.sd_layout().leftSpaceToView(self,20)?.topSpaceToView(self,20)?.autoHeightRatio(0)
        _ = collectionView.sd_layout().leftEqualToView(label)?.rightSpaceToView(self,20)?.topSpaceToView(label,5)?.heightIs(0)
        
       
        
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
        l.font = UIFont.systemFont(ofSize: 12)
        l.textAlignment = .center
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 1
        l.textColor = UIColor.blue
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(label)
        _ = label.sd_layout().centerXEqualToView(self.contentView)?.centerYEqualToView(self.contentView)?.widthIs(self.contentView.width)?.heightIs(self.contentView.height)
        
    }
    
}
