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
fileprivate let SearchPlaceholder:String = "输入查询内容"
fileprivate let defaultSearchCity:String = "全国"



class baseSearchViewController: UISearchController{

    
    private var searchField:UITextField!
    
    
    // nmenu view
    private lazy var menu1:YNDropDownView = { [unowned self] in
        
        let v1 = CompanySelector.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 160))
        
        // 条件数据 回调
        v1.passData = { (cond:[String:String]?) in
            
            let vm  = (self.searchResultsController as! searchResultController).vm
            // 过滤数据 测试
            // MARK 根据搜索条件查询 服务器数据
            // 在刷新tableview
        
            vm?.loadData.onNext("搜索")
        }
        return v1
        
    }()
    
    private lazy var menu2:YNDropDownView = {
        let v1 = PositionSelector.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 160))
        v1.passData = { (cond:[String:[String]]?) in
            let vm  = (self.searchResultsController as! searchResultController).vm
            // 过滤数据 测试
            // MARK 根据搜索条件查询 服务器数据
            // 在刷新tableview
            
            vm?.loadData.onNext("搜索")
        }
        return v1
        
    }()
    
    private lazy var menu3:YNDropDownView = {
        let v1 = JobArea.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 60))
        v1.passData = { (cond:[String:String]?) in
            let vm  = (self.searchResultsController as! searchResultController).vm
            // 过滤数据 测试
            // MARK 根据搜索条件查询 服务器数据
            // 在刷新tableview
            
            vm?.loadData.onNext("搜索")
        }
        return v1
        
    }()
    
    
    
    // 下拉条件过滤菜单
    private lazy var dropDownMenu:YNDropDownMenu = { [unowned self] in
        
        let items:[YNDropDownView] = [self.menu1,self.menu2,self.menu3]
        let dropDownMenu = YNDropDownMenu(frame: CGRect(x:0,y:0,width:ScreenW,height:dropViewH) , dropDownViews: items, dropDownViewTitles: dropmenus)
        dropDownMenu.isHidden = true
        // 被选中iamge 方向向下，程序会自动翻转iamge
        dropDownMenu.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_xl"), disabled: UIImage(named: "arrow_dim"))
        dropDownMenu.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        dropDownMenu.setLabelFontWhen(normal: .systemFont(ofSize: 12), selected: .boldSystemFont(ofSize: 12), disabled: .systemFont(ofSize: 12))
        
        
        dropDownMenu.backgroundBlurEnabled = true
        dropDownMenu.bottomLine.isHidden = false
        let back = UIView()
        back.backgroundColor = UIColor.black
        dropDownMenu.blurEffectView = back
        dropDownMenu.blurEffectViewAlpha = 0.7
        dropDownMenu.setBackgroundColor(color: UIColor.white)
        return dropDownMenu
        
    }()
    
    // 设置搜索bar 高度 并影藏textfield 背景img
    var height:CGFloat = 0 {
        willSet{
            self.searchBar.setSearchFieldBackgroundImage(build_image(frame: CGRect.init(x: 0, y: 0, width: 1, height: newValue), color: UIColor.clear), for: .normal)
        }
    }
    
    // leftCityBtn
    private lazy  var cityButton:UIButton = {
       var button = UIButton.init(title: (defaultSearchCity, .normal), fontSize: 12, alignment: .center, bColor: UIColor.clear)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.autoresizesSubviews = true
        button.frame = CGRect.init(x: 5, y: 4.5, width: 30, height: 20)
        button.addTarget(self, action: #selector(cityClick), for: .touchUpInside)
        return button
        
    }()
    
    // 搜索历史和搜索匹配展示VC
    lazy  var serchRecordVC:SearchRecodeViewController = {  [unowned self] in
            let vc =  SearchRecodeViewController()
            vc.view.isHidden = true
            vc.resultDelegate = self
            return vc
    }()
    
    var  showRecordView:Bool = false{
        willSet{
            self.serchRecordVC.view.isHidden = !newValue
            self.dropDownMenu.isHidden = newValue
            self.dropDownMenu.hideMenu()
        }
    }
    
    
    var chooseCity:(()->Void)?
    
    
    override init(searchResultsController: UIViewController?) {
        
        super.init(searchResultsController: searchResultsController)
        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = true
        
        self.definesPresentationContext = true
        self.searchBar.showsCancelButton = false
        self.searchBar.showsBookmarkButton = false
        self.searchBar.searchBarStyle = .default
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
        searchField.layer.cornerRadius = 14.0
        searchField.borderStyle  = .roundedRect
        searchField.tintColor = UIColor.black
        searchField.layer.masksToBounds = true
       
        // 搜索框内左侧添加btn 调整位置
        searchField.addSubview(self.cityButton)
        searchBar.setPositionAdjustment(UIOffset.init(horizontal: leftDistance, vertical: 0), for: .search)
        // 必须把布局代码 放这里，才能初始化正常！！！！
        self.view.addSubview(dropDownMenu)
        self.view.addSubview(self.serchRecordVC.view)
        // 搜索结果VC的view 布局
        _ = self.searchResultsController?.view.sd_layout().topSpaceToView(dropDownMenu,0)?.bottomEqualToView(self.view)?.widthIs(ScreenW)
        _ = self.serchRecordVC.view.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.rightEqualToView(self.view)?.leftEqualToView(self.view)
        
        //不隐藏导航栏
        self.navigationController?.navigationBar.settranslucent(false)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    // 选择城市，标签frame更新
    func changeCityTitle(title:String){
        
        // 计算city 字符串长度，改变button长度，和searchicon 偏移位置
        let rect = title.getStringCGRect(size: CGSize.init(width: 120, height: 0),font: (self.cityButton.titleLabel?.font!)!)
        if rect.width > 30{
            let add =  rect.width - 30
            UIView.animate(withDuration: 0.1, animations: {
                self.searchBar.setPositionAdjustment(UIOffsetMake(leftDistance + add, 0), for: .search)
                self.cityButton.frame = CGRect.init(x: 5, y: 4.5, width: 30 + add , height: 20)
                
            })
        }else{
            self.cityButton.frame = CGRect.init(x: 5, y: 4.5, width: 30, height: 20)
            self.searchBar.setPositionAdjustment(UIOffsetMake(leftDistance  , 0), for: .search)

        }
        self.cityButton.setTitle(title, for: .normal)

    }
    
    
    @objc func cityClick(){
       self.chooseCity?()
    }
    
    
}


// 显示搜索结果
extension baseSearchViewController:SearchResultDelegate,UISearchBarDelegate{
    

    func ShowSearchResults(word: String) {
        // 添加到搜索历史
        guard !word.isEmpty else {
            return
        }
        
        DBFactory.shared.getSearchDB().insertSearch(name: word)
        //localData.shared.appendSearchHistories(value: word)
        self.serchRecordVC.AddHistoryItem = true
        // MARK
        let vm  = (self.searchResultsController as!  searchResultController).vm
        
        //SVProgressHUD.show(withStatus: "加载数据")
        vm?.loadData.onNext("load")
        
        
        self.searchBar.text = word
        self.searchBarSearchButtonClicked(self.searchBar)
       
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.showRecordView = false
        searchBar.endEditing(true)
    }
    
    
    
}
