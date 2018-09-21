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


fileprivate let HeadeTitle:String = "热门搜索"
fileprivate let searchHistory:String = "搜索历史"


class SearchRecodeViewController: UIViewController {
    
    // 搜索数据库 数据
    private let searchTable = DBFactory.shared.getSearchDB()
    
    // 控制table的显示
    internal var ShowHistoryTable:Bool = true {
        willSet{
           
            searchItems.onNext(searchTable.getSearches(type: searchType))
            HistoryTable.isHidden = !newValue
            FilterTable.isHidden = newValue
        }
    }
    
    
    
    // 搜索历史
    private lazy var HistoryTable:UITableView = {  [unowned self] in
        
        let historyTable = UITableView.init()
        historyTable.backgroundColor = UIColor.white
        historyTable.tableFooterView = self.clearAllLabel
        historyTable.rx.setDelegate(self).disposed(by: dispose)
        //historyTable.rx.setDelegate(self).disposed(by: dispose)
        historyTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        historyTable.keyboardDismissMode = .onDrag
        
        return historyTable
    }()
    // 匹配搜索记录
   internal lazy var FilterTable:UITableView = {  [unowned self] in
    
        let filterTable = UITableView.init()
        filterTable.backgroundColor = UIColor.white
        filterTable.tableFooterView = UIView.init()
        filterTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //filterTable.rx.setDelegate(self).disposed(by: dispose)
        filterTable.keyboardDismissMode = .onDrag

        return filterTable
    }()
       
    // 热门搜索headerview
    private lazy var searchHederView:TableViewHeader = { [unowned self] in
            let h = TableViewHeader.init(frame: CGRect.zero)
            h.backgroundColor = UIColor.white
            h.label.text = HeadeTitle
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
    
    internal var searchType:String = ""{
        didSet{
            print("show history")
            searchItems.onNext(searchTable.getSearches(type: searchType))
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
    

    //rxSwift
    let dispose = DisposeBag()
    private var searchItems:PublishSubject<[String]> = PublishSubject<[String]>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(HistoryTable)
        self.view.addSubview(FilterTable)
        //
        setViewModel()
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ShowHistoryTable = true
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = HistoryTable.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        _ = FilterTable.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        
    }

}




extension SearchRecodeViewController{
    
    @objc func chooseTag(_ sender:UIButton){
    
        if let text = sender.titleLabel?.text{
            self.resultDelegate?.ShowSearchResults(word: text)
        }
    }

}

extension SearchRecodeViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if tableView == self.HistoryTable && indexPath.row == 0{
            return 60
        }
        return 45
    }
}



extension SearchRecodeViewController{
    
    @objc  private func removeItem(_ sender:UIButton){
    
        if let text = sender.titleLabel?.text{
               searchTable.deleteSearch(type: searchType,name: text)
               searchItems.onNext(searchTable.getSearches(type: searchType))
            
        }
        
    }
    
    @objc private func deleteAll(){
        
        searchTable.removeAllSearchItem(type:searchType)
        searchItems.onNext(searchTable.getSearches(type: searchType))
    }
}


extension SearchRecodeViewController{
    
    private func setViewModel(){
        
        
        FilterTable.rx.modelSelected(String.self).subscribe(onNext: { (str) in
             self.resultDelegate?.ShowSearchResults(word: str)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        HistoryTable.rx.modelSelected(String.self).subscribe(onNext: { (str) in
            if str == "搜索记录"{
                return
            }
            self.resultDelegate?.ShowSearchResults(word: str)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        
        searchItems.share().asDriver(onErrorJustReturn: []).drive(onNext: { items in
             self.HistoryTable.tableFooterView?.isHidden =  items.count == 0
            
            }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        
        searchItems.share().debug().observeOn(MainScheduler.instance).bind(to: self.HistoryTable.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){ (row, element, cell) in
            
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
            
            btn.tag = row
            btn.setTitle(element, for: .normal)
            //btn.tag = cIdx.row - 1
            btn.addTarget(self, action: #selector(self.removeItem), for: .touchUpInside)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            cell.accessoryView = btn
        }.disposed(by: dispose)
        
    }
}

