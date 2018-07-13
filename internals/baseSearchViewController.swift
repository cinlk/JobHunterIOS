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

import RxDataSources


fileprivate let leftDistance:CGFloat = 40
fileprivate let dropViewH:CGFloat = 40
fileprivate let dropmenus = ["公司筛选","职位筛选","行业领域"]
fileprivate let SearchPlaceholder:String = "搜索公司/职位/宣讲会"



class baseSearchViewController: UISearchController{

    
    // 搜索类型 决定 搜索记录界面显示数据 MARK
    internal var searchType:searchItem = .none{
        didSet{
            switch searchType {
            case .forum:
                self.serchRecordVC.hotItem = ["面试dqd ","实习","租房","刷题","当前为多群无多"]
                self.serchRecordVC.searchType = "forum"
            case .company, .intern, .meeting, .graduate, .onlineApply:
                self.serchRecordVC.hotItem = ["带我去的群无dqdqdqw", "大青蛙","当前为多群","dwq","当前为多","d当前为多群无","当前为多群无多"]
                //默认值
                self.serchRecordVC.searchType = "jobs"

            default:
                break
            }
        }
    }
    
    internal var searchField:UITextField!
    
    // 搜索结果显示控制组件
    internal var searchShowVC:searchResultController?
    
    private lazy var currentMenuType:searchItem = .onlineApply
    
    
    // 选择城市
    internal lazy var cityMenu:[DropItemCityView] = {
        var citys:[DropItemCityView] = []
        
        for _ in 0..<4{
            let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
            city.passData = { citys in
                // 加上currentMenuType类型
                self.searchShowVC?.startSearch(type: self.currentMenuType, word: "搜索", complete: nil)
            }
            city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)
            citys.append(city)
        }
        
        return citys
    }()
    
    
   
    
    // 行业分类
    internal lazy var industryKind:[DropItemIndustrySectorView] = {
        var indes:[DropItemIndustrySectorView] = []
        for _ in 0..<2{
            let indus = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
            indus.passData = { item in
                self.searchShowVC?.startSearch(type: self.currentMenuType, word: "搜索", complete: nil)
            }
            indus.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)

            indes.append(indus)
        }
        
        return indes
        
    }()
    // 公司性质
    internal lazy var companyKind: DropCompanyPropertyView = {
        let company = DropCompanyPropertyView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 6*45))
        company.passData = { item in
            self.searchShowVC?.startSearch(type: self.currentMenuType , word: "搜索", complete: nil)
            
        }
        company.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)

        return company
    }()
    
    // 大学
    internal lazy var colleges: DropCollegeItemView = {
        let college = DropCollegeItemView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
        college.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)

        return college
    }()
    
    
    // 行业分类
    lazy var careerClassify:[DropCarrerClassifyView] = { [unowned self] in
        var classes:[DropCarrerClassifyView] = []
        for _ in 0..<3{
            let v1 = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
            v1.passData = {  kind in
                self.searchShowVC?.startSearch(type: self.currentMenuType , word: "搜索", complete: nil)

            }
            
            v1.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)

        
            classes.append(v1)
        }
        
        return classes
        }()
    
    
    // 宣讲会过期?
    internal lazy var meetingValidate:DropValidTimeView = {  [unowned self] in
        
        let v1 = DropValidTimeView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 90))
        
        v1.passData = { validate in
            
            self.searchShowVC?.startSearch(type: self.currentMenuType ,word: "搜索", complete:  nil)
        }
        v1.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)

        return v1
    }()
    
    
    //
    internal lazy var  internCondition:DropInternCondtionView = { [unowned self] in
        let v1 = DropInternCondtionView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
        v1.passData = { conds in
            self.searchShowVC?.startSearch(type: self.currentMenuType , word: "搜索", complete:  nil)

        }
        v1.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)

        
        return v1
        
    }()
    
    internal  lazy var meetingTime:YNDropDownView = { [unowned self] in
        let v1 = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 260))
        v1.passData = { meet in
            self.searchShowVC?.startSearch(type: self.currentMenuType , word: "搜索", complete:  nil)

        }
        
        v1.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH)

        
        return v1
    }()
    
    
    // dropBackView
    private lazy var dropBackView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: dropViewH))
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    
    private lazy var  OnLineApplydropDownMenu:YNDropDownMenu = { [unowned self] in

        return  configDropMenu(items: [cityMenu[0],industryKind[0]], titles: ["城市","行业领域"], height: dropViewH)
    }()
    
    
    private lazy var graduate:YNDropDownMenu = { [unowned self] in
        
        return  configDropMenu(items: [cityMenu[1],careerClassify[0],companyKind], titles: ["城市","行业分类","公司性质"], height: dropViewH)

        
    }()
    
    private lazy var intern:YNDropDownMenu = { [unowned self] in
        return  configDropMenu(items: [cityMenu[2],careerClassify[1],internCondition], titles: ["城市","行业分类","实习条件"], height: dropViewH)

    }()
    private lazy var meeting:YNDropDownMenu = {  [unowned self] in
        return  configDropMenu(items: [colleges,industryKind[1],meetingValidate], titles: ["学校","行业领域","宣讲时间"], height: dropViewH)

    }()
    
    private lazy var company:YNDropDownMenu = {  [unowned self] in
        return  configDropMenu(items: [cityMenu[3],careerClassify[2]], titles: ["城市","行业分类"], height: dropViewH)
        
    }()
    
    private var  currentDropMenuView:[searchItem: YNDropDownMenu] = [:]
    

    
    // 设置搜索bar 高度 并影藏textfield 背景img
    var height:CGFloat = 0 {
        willSet{
            self.searchBar.setSearchFieldBackgroundImage(build_image(frame: CGRect.init(x: 0, y: 0, width: 1, height: newValue), color: UIColor.clear), for: .normal)
        }
    }
    
    
    // 类型选择btn
    internal lazy var chooseTypeBtn:UIButton = {
        
        let btn = UIButton.init(frame: CGRect.init(x: 5, y: 4.5, width: 60, height: 20))
        //let btn = UIButton.init(frame: CGRect.zero)
        btn.setImage(#imageLiteral(resourceName: "arrow_nor").changesize(size: CGSize.init(width: 10, height: 10)), for: .normal)
        btn.setTitle(currentMenuType.describe, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        
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
        let popMenuView = SearchTypeMenuView(frame: CGRect.init(x: 30, y: 50, width: 100, height: 160))
        popMenuView.delegate = self
        return popMenuView
    }()
    
    // 背景btn
    private lazy var backgroundBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        btn.addTarget(self, action: #selector(hiddenPopMenu), for: .touchUpInside)
        btn.backgroundColor = UIColor.lightGray
        btn.alpha = 0.5
        return btn
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
            currentDropMenuView[currentMenuType]?.hideMenu()
            currentDropMenuView[currentMenuType]?.isHidden = newValue
            // 影藏背景view
            dropBackView.isHidden = newValue
        }
    }
    
    
    
    

    
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
        searchField = self.searchBar.value(forKey: "searchField") as! UITextField
        searchField.layer.borderColor = UIColor.white.cgColor
        searchField.layer.borderWidth = 1
        searchField.layer.backgroundColor  = UIColor.white.cgColor
        searchField.backgroundColor = UIColor.clear
        searchField.layer.cornerRadius = searchBarH/2
        searchField.borderStyle  = .roundedRect
        searchField.textColor = UIColor.darkGray
        searchField.layer.masksToBounds = true
        
 
         //searchField.addSubview(self.cityButton)
        searchField.addSubview(chooseTypeBtn)
        
        
       
        //
        currentDropMenuView = [searchItem.onlineApply: OnLineApplydropDownMenu, .company: company, .intern: intern, .graduate: graduate, .meeting: meeting]
        
        self.addChildViewController(serchRecordVC)
        
        // 必须把布局代码 放这里，才能初始化正常！！！！
        self.view.addSubview(self.serchRecordVC.view)
        self.view.addSubview(dropBackView)
       // self.view.addSubview(currentDropMenuView[currentMenuType]!)
        self.view.sd_addSubviews(currentDropMenuView.values.reversed())
        // 搜索结果VC的view 布局
        _ = self.serchRecordVC.view.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.rightEqualToView(self.view)?.leftEqualToView(self.view)
        
        _ = self.searchResultsController?.view.sd_layout().topSpaceToView(self,dropViewH)?.bottomEqualToView(self.view)?.widthIs(ScreenW)
         // _ = self.searchShowVC?.view.sd_layout().widthIs(ScreenW)?.heightIs(ScreenH - NavH - dropViewH)?.xIs(0)?.yIs(dropViewH)
        //不隐藏导航栏
       
        self.navigationController?.navigationBar.settranslucent(false)
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    

    
    
}



extension baseSearchViewController{
    @objc private func showItems(_ btn:UIButton){
        
        searchField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            UIApplication.shared.keyWindow?.addSubview(self.backgroundBtn)
        }, completion: { bool in
            self.popMenuView.show()
            
        })
        
    }
    
    @objc private func hiddenPopMenu(){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.popMenuView.dismiss()

        }) { bool in
            self.backgroundBtn.removeFromSuperview()

        }
        
    }
}

extension baseSearchViewController{
    internal func setSearchBar(open:Bool){
        
        self.chooseTypeBtn.isHidden = !open
        self.showRecordView = open
        //self.popMenuView.dismiss()
        
    }
}





// 搜索历史记录view  代理实现
extension baseSearchViewController:SearchResultDelegate,UISearchBarDelegate{
    
    func ShowSearchResults(word: String) {
        
        // 添加到搜索历史
        guard !word.isEmpty else {
            return
        }
        
        if self.searchType == .forum{
            startPostSearch(word: word)
        }else{
            startSearch(word: word)
        }
        

        self.searchBar.text = word
        self.searchBarSearchButtonClicked(self.searchBar)
       
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.popMenuView.dismiss()
        self.showRecordView = false
        searchBar.endEditing(true)
    }
    
}

//点击键盘search   搜索帖子 或 其他职位
extension baseSearchViewController{
    open func startSearch(word:String){
        
        
        self.showRecordView = false
        // 查找新的item 然后 查询数据刷新搜索结果界面
        //self.popMenuView.dismiss()
        DBFactory.shared.getSearchDB().insertSearch(type: self.serchRecordVC.searchType,name: word)
        
        currentDropMenuView.values.forEach{
            $0.isHidden = true
        }

        // 测试搜索数据
        self.searchShowVC?.startSearch(type: currentMenuType , word: "test", complete: { bool in
            if bool == true {
                self.setDropMenu(item: self.currentMenuType, isHidden: false)
            }
        })

    }
    // 搜索论坛数据
     open func startPostSearch(word:String){
         self.showRecordView = false
         DBFactory.shared.getSearchDB().insertSearch(type: self.serchRecordVC.searchType,name: word)
         currentDropMenuView.values.forEach{
            $0.isHidden = true
        }
        self.searchShowVC?.startSearch(type: .forum, word: "test", complete: nil)
        
    }
}


extension baseSearchViewController{
    private func setDropMenu(item:searchItem, isHidden:Bool){
        currentDropMenuView.forEach{
            if $0.key == item{
                $0.value.isHidden = isHidden
            }else{
                $0.value.isHidden = !isHidden
            }
        }
        
        dropBackView.isHidden = false
    
        
        
    }
}
// 搜索菜单代理
extension baseSearchViewController: SearchMenuDelegate{
    
    func selectedItem(item: searchItem) {
        
        let refresh  =  currentMenuType == item ? false : true
        currentMenuType = item
        
        self.hiddenPopMenu()
        
        chooseTypeBtn.setTitle(item.describe, for: .normal)
        if item == .meeting{
            chooseTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)
        }else{
            chooseTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)

        }
        
        // 刷新结果界面
        if self.showRecordView == false && refresh{
            //self.popMenuView.dismiss()
            currentDropMenuView.values.forEach{
                $0.isHidden = true
            }

            // 测试搜索数据
            self.searchShowVC?.startSearch(type: currentMenuType, word: "test", complete:{  bool in
                if bool == true {
                    self.setDropMenu(item: self.currentMenuType, isHidden: false)
                }

                
            })
            
        }
    
    }
    
}


