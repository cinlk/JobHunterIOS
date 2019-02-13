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

fileprivate let leftDistance:CGFloat = 40
fileprivate let dropViewH:CGFloat = 40
fileprivate let SearchPlaceholder:String = "搜索公司/职位/宣讲会"



// 搜索类型
enum searchItem:String{
    
    case onlineApply = "onlineApply"
    case graduate = "graduate"
    case intern = "intern"
    case meeting = "meeting"
    case company = "company"
    case forum = "forum"
    case none = "none"
    // 简历添加类型
    case online = "online"
    case attachment = "attachment"
    
    
    var type:String{
        get{
            switch self {
            case .forum:
                return "forum" // 只是论坛
            default:
                return "jobs"  // 公司, 职位, 其他条件
            }
        }
    }
    
    var describe:String{
        get{
            switch self {
            case .intern:
                return "实习"
            case .graduate:
                return "校招"
            case .onlineApply:
                return "网申"
            case .meeting:
                return "宣讲会"
            case .forum:
                return "论坛"
            case .company:
                return "公司"
            case .online:
                return "在线简历"
            case .attachment:
                return "附件简历"
            default:
                return ""
            }
        }
        
    }
    
    static func getType(name:String)->searchItem{
        if name == "实习"{
            return .intern
        }else if name == "校招"{
            return .graduate
        }else if name == "网申"{
            return .onlineApply
        }else if name == "论坛"{
            return .forum
        }else if name == "公司"{
            return .company
        }
        return .none
    }
    
}




class BaseSearchViewController: UISearchController{

    
    // 搜索类型 决定 搜索记录界面显示数据 MARK
    internal var searchType:searchItem = .none{
        didSet{
            
            // 热门关键词
            searchVM.searchLatestHotRecord(type: searchType.type).asDriver().drive(onNext: { words in
                self.serchRecordVC.hotItem = words
            }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
            
            
            // 搜索历史记录
            switch searchType {
            case .forum:
                self.serchRecordVC.searchType = "forum"
            case .company, .intern, .meeting, .graduate, .onlineApply:
                //默认值
                self.serchRecordVC.searchType = "jobs"

            default:
                break
            }
        }
    }
    
    internal var searchField:UITextField!
    
    // 搜索结果显示控制组件
    internal  weak var searchShowVC:searchResultController?
    
    private lazy var currentMenuType:searchItem = .onlineApply

    
    // 设置搜索bar 高度 并影藏textfield 背景img
    var height:CGFloat = 0 {
        willSet{
//            self.searchBar.setSearchFieldBackgroundImage(UIImage.drawNormalImage(frame: CGRect.init(x: 0, y: 0, width: 1, height: newValue), color: UIColor.red), for: .normal)
        }
    }
    
    
    // 类型选择btn
    internal lazy var chooseTypeBtn:UIButton = {
        
        let btn = UIButton.init(frame: CGRect.init(x: 5, y: 4.5, width: 60, height: 20))
        btn.setImage(#imageLiteral(resourceName: "arrow_nor").changesize(size: CGSize.init(width: 10, height: 10)), for: .normal)
        btn.setTitle(currentMenuType.describe, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // btn的元素排列
        btn.semanticContentAttribute = .forceRightToLeft
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(showItems(_:)), for: .touchUpInside)
        btn.isHidden = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.autoresizesSubviews = true
        return btn
        
    }()
    
    // 下拉菜单tableview
    internal lazy var popMenuView:SearchTypeMenuView = { [unowned self] in
        // 计算 btn 相对windows 的位置
        //let absolute =  self.searchField.convert(self.chooseTypeBtn.frame, to: self.searchBar)
        print("the absolue view CGrect \(self.chooseTypeBtn.frame)")
        let popMenuView = SearchTypeMenuView(frame: CGRect.init(x: self.chooseTypeBtn.frame.origin.x + self.chooseTypeBtn.size.width, y: self.chooseTypeBtn.frame.origin.y +  self.chooseTypeBtn.size.height, width: 100, height: 160))
        popMenuView.delegate = self
        return popMenuView
    }()
    

    // 搜索历史和搜索匹配展示VC
    lazy  var serchRecordVC:SearchRecodeViewController = {  [unowned self] in
            let vc =  SearchRecodeViewController()
            vc.view.isHidden = true
            vc.resultDelegate = self
            return vc
    }()
    
    // 切换历史搜索和 搜索结果展示界面
    var  showRecordView:Bool = false{
        willSet{
            self.serchRecordVC.view.isHidden = !newValue
            self.serchRecordVC.ShowHistoryTable = (self.searchBar.text ?? "").isEmpty
        }
    }
    
    
    
    //rxSwift
    var searchBarObserver:Observable<String>!
    let dispose:DisposeBag = DisposeBag()

    private lazy var searchVM:searchViewModel = {
        return searchViewModel()
    }()
    
    

    override init(searchResultsController: UIViewController?) {
        
        super.init(searchResultsController: searchResultsController)
        
        self.searchShowVC = searchResultsController as? searchResultController
 
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
       
        super.viewDidLayoutSubviews()
        
        
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





// 搜索热门记录 点击代理实现
extension BaseSearchViewController:SearchResultDelegate{
    
    func ShowSearchResults(word: String) {
        
        // 添加到搜索历史
        guard !word.isEmpty else {
            return
        }
        
        self.searchBar.text = word
        
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
        
        self.showRecordView = false
        DBFactory.shared.getSearchDB().insertSearch(type: self.serchRecordVC.searchType,name: word)
        self.searchShowVC?.startSearchData(type: currentMenuType, word: word)
        self.searchBar.endEditing(true)

    }
    // 搜索论坛数据
     open func startPostSearch(word:String){
         self.showRecordView = false
         DBFactory.shared.getSearchDB().insertSearch(type: self.serchRecordVC.searchType,name: word)
        
    }
}



// 搜索菜单代理
extension BaseSearchViewController: SearchMenuDelegate{
    
    func selectedItem(item: searchItem) {
        
        let refresh  =  currentMenuType == item ? false : true
        currentMenuType = item
        
        self.hiddenPopMenu()
        
        chooseTypeBtn.setTitle(item.describe, for: .normal)
        if item == .meeting{
            chooseTypeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        }else{
            chooseTypeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

        }
        
        // 刷新结果界面
        if self.showRecordView == false && refresh{

            if let text = self.searchBar.text, !text.isEmpty{
                self.searchShowVC?.startSearchData(type: currentMenuType, word: text)

            }
        }
    
    }
    
}


extension BaseSearchViewController{
    
    private func setViewModel(){
        
       // searchBar rx
       searchBarObserver =  self.searchBar.rx.text.orEmpty.throttle(0.3, scheduler: MainScheduler.instance).distinctUntilChanged().flatMapLatest { (query) -> Observable<String> in
            if query.isEmpty{
                return Observable<String>.just("")
            }
            return Observable<String>.just(query)
        }.share().observeOn(MainScheduler.instance)
     
        searchBarObserver.map { (str) -> Bool in
            str.isEmpty
        }.bind(to: self.popMenuView.rx.hidden).disposed(by: dispose)
        
        searchBarObserver.bind(to: self.serchRecordVC.rx.status).disposed(by: dispose)
        
        // 绑定到搜索历史结果 FilterTable
        searchBarObserver.flatMapLatest { (words) -> Observable<[String]> in
        
            if words.isEmpty{
                return  Observable<[String]>.just([])
            }
            
            return self.searchVM.searchMatchWords(type: self.searchType.type, word: words).map{ (model) -> [String] in
                //Observable<[String]>.just(model.words ?? [])
                model.words ?? []
                }.catchError({ (err) -> Observable<[String]> in
                    self.view.showToast(title: "发生错误\(err)", customImage: nil, mode: .text)
                    //showOnlyTextHub(message: "发生错误\(err)", view: self.view)
                    return Observable<[String]>.just([])
                })
            
            }.share().bind(to: self.serchRecordVC.FilterTable.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){
                (row, element, cell) in
                cell.textLabel?.text = element
                
            }.disposed(by: dispose)
        
    
        
        // edit
        self.searchBar.rx.textDidBeginEditing.debug().throttle(0.3, scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: ()).drive(onNext: {
                self.showRecordView = true
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        
        // 点击搜索按钮
        self.searchBar.rx.searchButtonClicked.throttle(0.3, scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: ()).debug().drive(onNext: {
            if let text =  self.searchBar.text, !text.isEmpty{
                self.startSearch(word: text)
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        // searchController rx
      
     }
    
    
}


