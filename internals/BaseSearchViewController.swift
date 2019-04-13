//
//  baseSearchViewController.swift
//  internals
//
//  Created by ke.liang on 2017/9/23.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu
import MJRefresh
import RxSwift
import RxCocoa

//fileprivate let leftDistance:CGFloat = 40
//fileprivate let dropViewH:CGFloat = 40
fileprivate let SearchPlaceholder:String = "搜索公司/职位/宣讲会"


internal final class chooseBtn:UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // btn的元素排列
        self.semanticContentAttribute = .forceRightToLeft
        self.setTitleColor(UIColor.blue, for: .normal)
        self.backgroundColor = UIColor.clear
        //btn.addTarget(self, action: #selector(showItems(_:)), for: .touchUpInside)
        //self.isHidden = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
  
}




class BaseSearchViewController: UISearchController{

    
    // 搜索类型 决定 搜索记录界面显示数据 MARK
    internal var searchType:searchItem = .none{
        
        didSet{
            // searchVM observeron(value)
            NotificationCenter.default.post(name: NotificationName.searchType, object: nil, userInfo: ["searchType": searchType])
            
            // 热门关键词
//            searchVM.searchLatestHotRecord(type: searchType.type).asDriver().drive(onNext: { words in
//                self.serchRecordVC.hotItem = words
//            }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
//
            
            self.currentMenuType = searchType == .forum ? .forum : .onlineApply
            
            //self.currentMenuType = searchItem(rawValue: searchType.type) ?? .none
            // 搜索历史记录
//            switch searchType {
//            case .forum:
//                self.serchRecordVC.searchType = "forum"
//                self.currentMenuType = .forum
//
//            case .company, .intern, .meeting, .graduate, .onlineApply:
//                //默认值
//                self.serchRecordVC.searchType = "jobs"
//                self.currentMenuType = .onlineApply
//                self.popMenuView.datas = [.onlineApply, .graduate, .intern, .meeting, .company]
//
//            default:
//                break
//            }
            
        }
    }
    
    internal var searchField:UITextField!
    
    // 搜索结果显示控制组件
    private  weak var searchShowVC:SearchResultController?
    
    private  var currentMenuType:searchItem = .none{
        didSet{
            self.chooseTypeBtn.setTitle(self.currentMenuType.describe, for: .normal)
        }
    }

    
    // 设置搜索bar 高度 并影藏textfield 背景img
    var height:CGFloat = 0 {
        willSet{
//            self.searchBar.setSearchFieldBackgroundImage(UIImage.drawNormalImage(frame: CGRect.init(x: 0, y: 0, width: 1, height: newValue), color: UIColor.red), for: .normal)
        }
    }
    
    
    // 类型选择btn
    internal lazy var chooseTypeBtn:chooseBtn = { [unowned self] in
        
        let btn = chooseBtn.init(frame: CGRect.init(x: 5, y: 4.5, width: 60, height: 20))
        btn.setImage(#imageLiteral(resourceName: "arrow_nor").changesize(size: CGSize.init(width: 10, height: 10)), for: .normal)
        btn.addTarget(self, action: #selector(showItems(_:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
        
    }()
    
    // 下拉菜单tableview
    private lazy var popMenuView:SearchTypeMenuView = { [unowned self] in
        // 计算 btn 相对windows 的位置 ???
        //let absolute =  self.searchField.convert(self.chooseTypeBtn.frame, to: self.searchBar)
        let popMenuView = SearchTypeMenuView(frame: CGRect.init(x: self.chooseTypeBtn.frame.origin.x + 10, y: GlobalConfig.NavH - 10 , width: 0, height: 0))
        popMenuView.delegate = self
        return popMenuView
    }()
    

    // 搜索历史和搜索匹配展示VC
    private lazy var serchRecordVC: SearchRecordeViewController = {  [unowned self] in
            let vc = SearchRecordeViewController()
            vc.view.isHidden = true
            vc.resultDelegate = self
            return vc
    }()
    
    // 切换历史搜索和 搜索结果展示界面
    var showRecordView: Bool = false{
        willSet{
            self.serchRecordVC.view.isHidden = !newValue
            // 历史记录 或 搜索结果  table view 显示
            self.serchRecordVC.showHistoryTable = (self.searchBar.text ?? "").isEmpty
        }
    }
    
    
    
    //rxSwift
    var searchBarObserver:Driver<String>!
    // let 导致dispose lock ？？
    private lazy var dispose:DisposeBag = DisposeBag()

    private lazy var searchVM:SearchViewModel = {
        return SearchViewModel()
    }()
    
    

    override init(searchResultsController: UIViewController?) {
        
        super.init(searchResultsController: searchResultsController)
        
        self.searchShowVC = searchResultsController as? SearchResultController
 
        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = true
        
        self.definesPresentationContext = true
    
        self.searchBar.showsCancelButton = false
        self.searchBar.placeholder = SearchPlaceholder
        
        self.searchBar.tintColor = UIColor.blue
        self.searchBar.sizeToFit()
        
        
        //设置透明
        self.searchBar.backgroundColor = UIColor.clear
        self.searchBar.alpha = 0.7
        
        // 去掉背景上下黑线
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.barTintColor = UIColor.clear
        //设置边框和圆角 已经borderview 背景颜色
    
        searchField = (self.searchBar.value(forKey: "searchField") as! UITextField)
        searchField.layer.borderColor = UIColor.white.cgColor
        searchField.layer.borderWidth = 1
        searchField.layer.backgroundColor  = UIColor.white.cgColor
        searchField.backgroundColor = UIColor.clear
//        searchField.layer.cornerRadius = search_bar_height/2
       
        searchField.borderStyle  = .roundedRect
        searchField.textColor = UIColor.darkGray
        searchField.layer.masksToBounds = true
        
        
        searchField.leftViewMode = .always
        searchField.leftView = chooseTypeBtn
 
        
        self.addChild(serchRecordVC)
        // 必须把布局代码 放这里，才能初始化正常！！！！
        self.view.addSubview(self.serchRecordVC.view)
        // 搜索结果VC的view 布局
        _ = self.serchRecordVC.view.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.rightEqualToView(self.view)?.leftEqualToView(self.view)
        _ = self.searchField.sd_layout()?.topEqualToView(self.searchBar)?.bottomEqualToView(self.searchBar)
  
        
        //self.navigationController?.navigationBar.settranslucent(false)
        //rxswift
        setViewModel()
    
    }
    
    // 必须
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
}



extension BaseSearchViewController{
    
    @objc private func showItems(_ btn:UIButton){
        
        searchField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        }, completion: { bool in
            self.popMenuView.show()
            
        })
        
    }
    
    @objc private func hiddenPopMenu(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.popMenuView.dismiss()

        })
        
    }
}

extension BaseSearchViewController{
    
    internal func setSearchBar(open:Bool){
        self.chooseTypeBtn.isHidden = !open
        self.showRecordView = open
    }
}





// 热门记录 和  搜索的词 点击代理实现
extension BaseSearchViewController:SearchResultDelegate{
    
    func ShowSearchResults(word: String) {
        
        // 添加到搜索历史
        guard !word.isEmpty else {
            return
        }
        
        self.searchBar.text = word
        
        self.showRecordView = false
         DBFactory.shared.getSearchDB().insertSearch(type: self.searchType.searchType, name: word)
        
        if self.searchType == .forum{
            startPostSearch(word: word)
        }else{
            startSearch(word: word)
        }
        
    }
   
    
}

//点击键盘search   搜索帖子 或 其他职位
extension BaseSearchViewController{
    
    open func startSearch(word:String){
        
        self.searchShowVC?.startSearchData(type: currentMenuType, word: word)
        self.searchBar.endEditing(true)

    }
    // 搜索论坛数据 TODO
     open func startPostSearch(word:String){
        
        
    }
}



// 搜索菜单切换 代理
extension BaseSearchViewController: SearchMenuDelegate{
    
    func selectedItem(item: searchItem) {
        
        let refresh  =  currentMenuType == item ? false : true
        currentMenuType = item
        
        self.hiddenPopMenu()
        
        chooseTypeBtn.setTitle(item.describe, for: .normal)
        chooseTypeBtn.imageEdgeInsets = item == .meeting ? UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        
        // 如果是显示结果状态下  才刷新具体类型的搜索数据
        if self.showRecordView == false && refresh{

            if let text = self.searchBar.text, !text.isEmpty{
                self.searchShowVC?.startSearchData(type: currentMenuType, word: text)

            }
        }
    
    }
    
}


extension BaseSearchViewController{
    
    private func setViewModel(){
        
       // searchBar  输入框监听变化
        searchBarObserver =  self.searchBar.rx.text.orEmpty.asDriver()
    
        
        searchBarObserver.map { (str) -> Bool in
            str.isEmpty
        }.asObservable().bind(to: self.popMenuView.rx.hidden).disposed(by: dispose)
        
        searchBarObserver.asObservable().bind(to: self.serchRecordVC.rx.status).disposed(by: dispose)
        
        // 绑定到搜索历史结果 FilterTable
    
  
        searchBarObserver.flatMapLatest {  [unowned self] (words) -> Driver<[String]> in
        
            if words.isEmpty{
                return Driver<[String]>.just([])
            }
            return  self.searchVM.searchMatchWords(type: self.currentMenuType.describe, word: words).map({ (mode) -> [String] in
                mode.body?.words ?? []
            }).asDriver(onErrorJustReturn: [])
            
           }.asObservable().bind(to: self.serchRecordVC.filterTable.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){
                (row, element, cell) in
                cell.textLabel?.text = element
                
                }.disposed(by: self.dispose)
        
            
//            return self.searchVM.searchMatchWords(type: self.searchType.searchType, word: words).map{ (model) -> [String] in
//                //Observable<[String]>.just(model.words ?? [])
//                model.words ?? []
//                }.catchError({ (err) -> Observable<[String]> in
//                    self.view.showToast(title: "发生错误\(err)", customImage: nil, mode: .text)
//                    //showOnlyTextHub(message: "发生错误\(err)", view: self.view)
//                    return Observable<[String]>.just([])
//                })
//
//            }.asObservable().bind(to: self.serchRecordVC.filterTable.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){
//                (row, element, cell) in
//                cell.textLabel?.text = element
//
//            }.disposed(by: dispose)
        
    
        
        // edit
        self.searchBar.rx.textDidBeginEditing.debug().throttle(0.3, scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: ()).drive(onNext: { [weak self] in
                self?.showRecordView = true
        }).disposed(by: self.dispose)
        
        
        
        // 点击搜索按钮
        self.searchBar.rx.searchButtonClicked.throttle(0.3, scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: ()).debug().drive(onNext: {  [weak self] in
            if let text =  self?.searchBar.text, !text.isEmpty{
                self?.ShowSearchResults(word: text)
            }
        }).disposed(by: self.dispose)
        
        // searchController rx
      
     }
    
    
}


