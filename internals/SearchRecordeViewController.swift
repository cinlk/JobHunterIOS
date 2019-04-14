//
//  SearchRecodeViewController.swift
//  internals
//
//  Created by ke.liang on 2017/12/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


protocol SearchResultDelegate: class{
    func ShowSearchResults(word:String)
}


fileprivate let headeTitle:String = "热门搜索"
fileprivate let searchHistory:String = "搜索历史"
fileprivate let cellIdentity:String = "cell"
fileprivate let clearTitle:String = "清除历史记录"


final class clearAllView:UIView {
    
    
//    let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 40))
//    v.backgroundColor = UIColor.clear
//    v.isUserInteractionEnabled = true
//
//    let  label = UILabel()
//    label.font = UIFont.systemFont(ofSize: 16)
//    label.textColor = UIColor.lightGray
//    label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
//    label.text = "清除历史记录"
//    label.textAlignment = .center
//    label.backgroundColor = UIColor.clear
//    label.isUserInteractionEnabled = true
//    let gesture = UITapGestureRecognizer()
//    gesture.addTarget(self, action: #selector(deleteAll))
//    label.addGestureRecognizer(gesture)
//
//    v.addSubview(label)
//    _ = label.sd_layout().centerYEqualToView(v)?.centerXEqualToView(v)?.autoHeightRatio(0)
//    return v
    

    private weak  var vc:SearchRecordeViewController?
    
    private lazy var lb:UILabel = { [unowned self] in
        let lb = UILabel.init(frame: CGRect.zero)
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = UIColor.lightGray
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        lb.text = clearTitle
        lb.textAlignment = .center
        lb.isUserInteractionEnabled = true
        
        
        if  let vc = self.vc  {
            let ges = UITapGestureRecognizer()
            ges.addTarget(vc, action: #selector(self.vc?.deleteAll))
            lb.addGestureRecognizer(ges)
        }
        
       
        return lb
    }()
    
//    private lazy var gesture:UITapGestureRecognizer = { [unowned self] in
//
//        return ges
//    }()
    
    convenience init(frame: CGRect, vc:SearchRecordeViewController){
        self.init(frame: frame)
        self.vc = vc
        //lb.addGestureRecognizer(self.gesture)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        self.addSubview(lb)
        _ = lb.sd_layout().centerYEqualToView(self)?.centerXEqualToView(self)?.autoHeightRatio(0)
        
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SearchRecordeViewController: UIViewController {
    
    // 搜索数据库表
    private let searchTable = DBFactory.shared.getSearchDB()
    
    // 控制table的显示
    internal var showHistoryTable:Bool = true {
        
        willSet{
           
            searchItems.onNext(searchTable.getSearches(type: searchType))
            historyTable.isHidden = !newValue
            filterTable.isHidden = newValue
        }
    }
    
    
    
    // 搜索历史
    private lazy var historyTable:UITableView = {  [unowned self] in
        
        let historyTable = UITableView.init()
        historyTable.backgroundColor = UIColor.white
        historyTable.tableFooterView = self.clearAllLabel
        historyTable.rx.setDelegate(self).disposed(by: dispose)
        //historyTable.rx.setDelegate(self).disposed(by: dispose)
        historyTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        historyTable.keyboardDismissMode = .onDrag
        
        return historyTable
    }()
    // 匹配搜索记录
   internal lazy var filterTable:UITableView = {  [unowned self] in
    
        let filterTable = UITableView.init()
        filterTable.backgroundColor = UIColor.white
        filterTable.tableFooterView = UIView.init()
        filterTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        filterTable.rx.setDelegate(self).disposed(by: dispose)
        filterTable.keyboardDismissMode = .onDrag

        return filterTable
    }()
       
    // 热门搜索headerview
    private lazy var searchHederView:TableViewHeader = { [unowned self] in
            let h = TableViewHeader.init(frame: CGRect.zero)
            h.backgroundColor = UIColor.white
            h.label.text = headeTitle
            h.chooseItem = { [weak self] (word) in
                self?.resultDelegate?.ShowSearchResults(word: word)
            }
            return h
    }()
    
    private lazy var clearAllLabel: clearAllView = { [unowned self] in
            let v = clearAllView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 40), vc: self)
            return v
    }()
//    private lazy var clearAllLabel:UIView = {
//
//        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 40))
//        v.backgroundColor = UIColor.clear
//        v.isUserInteractionEnabled = true
//
//        let  label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.textColor = UIColor.lightGray
//        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
//        label.text = "清除历史记录"
//        label.textAlignment = .center
//        label.backgroundColor = UIColor.clear
//        label.isUserInteractionEnabled = true
//        let gesture = UITapGestureRecognizer()
//        gesture.addTarget(self, action: #selector(deleteAll))
//        label.addGestureRecognizer(gesture)
//
//        v.addSubview(label)
//        _ = label.sd_layout().centerYEqualToView(v)?.centerXEqualToView(v)?.autoHeightRatio(0)
//        return v
//
//    }()
    
    private var searchType:String = ""{
        didSet{
            print("show history")
            //searchItems.onNext(searchTable.getSearches(type: searchType))
        }
    }
    
    // 热门搜索数据
    private var hotItem:[String] = []{
        didSet{
            searchHederView.mode = hotItem
            searchHederView.layoutSubviews()
            historyTable.tableHeaderView = searchHederView
        }
    }
    
    // delegate
    weak var resultDelegate:SearchResultDelegate?
    

    //rxSwift
    let dispose = DisposeBag()
    private var searchItems:PublishSubject<[String]> = PublishSubject<[String]>()
    private lazy var searchVM:SearchViewModel = SearchViewModel.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(historyTable)
        self.view.addSubview(filterTable)
        //
        setViewModel()
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showHistoryTable = true
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = historyTable.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        _ = filterTable.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        
    }
    
    deinit {
        print("deinit searchRecord \(String.init(describing: self))")
    }

}




//extension SearchRecordeViewController{
//
//    @objc func chooseTag(_ sender:UIButton){
//
//        if let text = sender.titleLabel?.text{
//            self.resultDelegate?.ShowSearchResults(word: text)
//        }
//    }
//
//}

extension SearchRecordeViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if tableView == self.historyTable && indexPath.row == 0{
            return 60
        }
        return 45
    }
}



extension SearchRecordeViewController{
    
//    @objc  private func removeItem(_ sender:UIButton){
//
//        if let text = sender.titleLabel?.text{
//               searchTable.deleteSearch(type: searchType,name: text)
//               searchItems.onNext(searchTable.getSearches(type: searchType))
//
//        }
//
//    }
    
    @objc public func deleteAll(){
        
        searchTable.removeAllSearchItem(type:searchType)
        searchItems.onNext(searchTable.getSearches(type: searchType))
    }
}


extension SearchRecordeViewController{
    
    private func setViewModel(){
    
        NotificationCenter.default.rx.notification(NotificationName.searchType).subscribe(onNext: {  [weak self] (notify) in
            guard let `self` = self else {
                return
            }
            
            if let searchType = notify.userInfo?["searchType"] as? searchItem{
                // 搜索热门关键词
                //searchType.getHotestWords()
                // TODO 缓存失效时间
                //self.hotItem = ["测试1", "测试2", "测试3"]
                self.searchVM.searchLatestHotRecord(type: searchType.searchType).debug().subscribe(onNext: { [weak self] (obj) in
                    if let code = obj.code, HttpCodeRange.filterSuccessResponse(target: code), let body = obj.body{
                        var tmp:[String] = []
                        for  (_, item) in  body.enumerated(){
                            if let name = item.name{
                                    tmp.append(name)
                            }
                            
                        }
                        self?.hotItem = tmp
                    }
                }).disposed(by: self.dispose)
                
                // 搜索热门历史记录
                 self.searchItems.onNext(self.searchTable.getSearches(type: searchType.searchType))
                
                // 当前类型
                self.searchType = searchType.searchType
                
                
            }
        }).disposed(by: self.dispose)
        
        // 选择某个词
        filterTable.rx.modelSelected(String.self).subscribe(onNext: { [weak self] (str) in
             self?.resultDelegate?.ShowSearchResults(word: str)
        }).disposed(by: dispose)
        
        historyTable.rx.modelSelected(String.self).subscribe(onNext: {  [weak self] (str) in
            if str == GlobalConfig.searchTopWord{
                return
            }
            self?.resultDelegate?.ShowSearchResults(word: str)
        }).disposed(by: dispose)
        
        
        searchItems.share().asDriver(onErrorJustReturn: []).drive(onNext: { [weak self]  items in
             self?.historyTable.tableFooterView?.isHidden =  items.count == 0
        
            }).disposed(by: dispose)
        
        
        
        // 加上 weak self 释放 ！！
        searchItems.share().debug().observeOn(MainScheduler.instance).bind(to: self.historyTable.rx.items(cellIdentifier: cellIdentity, cellType: UITableViewCell.self)){ [weak self] (row, element, cell) in
            guard let `self` = self else {
                return
            }
            if row == 0 {
                cell.selectionStyle = .none
                cell.textLabel?.text =  element
                cell.backgroundColor = UIColor.clear
                cell.layer.borderWidth = 0
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
                cell.accessoryView = nil 
                return
            }
            
           
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.text = element
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
            btn.setImage(UIImage.init(named: "cancel")?.changesize(size: CGSize.init(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .normal)
            
            //btn.tag = row
            btn.setTitle(element, for: .normal)
            //btn.tag = cIdx.row - 1
            
            //btn.addTarget(self, action: #selector(self.removeItem), for: .touchUpInside)
             btn.rx.tap.subscribe(onNext: {  [weak self] _ in
                guard let `self` = self else {
                    return
                }
                
                self.searchTable.deleteSearch(type: self.searchType,name: element)
                self.searchItems.onNext(self.searchTable.getSearches(type: self.searchType))

            }).disposed(by: self.dispose)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            cell.accessoryView = btn
        }.disposed(by: dispose)
        
    }
}

