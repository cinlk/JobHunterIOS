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
import SVProgressHUD
import RxDataSources


protocol baseSearchDelegate: class {
    
    func chooseCity()
}

private let leftDistance:CGFloat = 40
private let dropmenus = ["公司筛选","职位筛选","行业领域"]

class baseSearchViewController: UISearchController{

    // data
    private var datas:[[String:String]] = []
    
    
    private var searchField:UITextField!
    
    weak var cityDelegate:baseSearchDelegate?
    
   
    
    
    // nmenu view
    lazy var menu1:YNDropDownView = { [unowned self] in
        
        let v1 = CompanySelector.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 160))
        v1.passData = { (cond:[String:String]?) in
            
            let table  = (self.searchResultsController as! searchResultController).table
            // 过滤数据 测试
            // MARK 根据搜索条件查询 服务器数据
            // 在刷新tableview
            self.datas.removeAll()
            self.datas.append(["picture":"sina",
                          "comapany":"sina",
                          "jobName":"公司筛选",
                          "address":"云计算研发",
                          "salary":"10",
                          "create_time":"2017-12-22",
                          "education":"本科"])
            table.reloadData()
            return
        }
        return v1
        
    }()
    
    lazy var menu2:YNDropDownView = {
        let v1 = PositionSelector.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 160))
        v1.passData = { (cond:[String:[String]]?) in
            let table  = (self.searchResultsController as! searchResultController).table
            // 过滤数据 测试
            // MARK 根据搜索条件查询 服务器数据
            // 在刷新tableview
            self.datas.removeAll()
            self.datas.append(["picture":"sina",
                               "comapany":"sina",
                               "jobName":"职位筛选",
                               "address":"云计算研发",
                               "salary":"10",
                               "create_time":"2017-12-22",
                               "education":"本科"])
            table.reloadData()
            return
            
        }
        return v1
        
    }()
    
    lazy var menu3:YNDropDownView = {
        let v1 = JobArea.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 60))
        v1.passData = { (cond:[String:String]?) in
            let table  = (self.searchResultsController as! searchResultController).table
            // 过滤数据 测试
            // MARK 根据搜索条件查询 服务器数据
            // 在刷新tableview
            self.datas.removeAll()
            self.datas.append(["picture":"sina",
                               "comapany":"sina",
                               "jobName":"行业领域",
                               "address":"云计算研发",
                               "salary":"10",
                               "create_time":"2017-12-22",
                               "education":"本科"])
            table.reloadData()
            return
        }
        return v1
        
    }()
    
    
    
    lazy var dropDownMenu:YNDropDownMenu = { [unowned self] in
        
        let items:[YNDropDownView] = [self.menu1,self.menu2,self.menu3]
        let dropDownMenu = YNDropDownMenu(frame: CGRect(x:0,y:0,width:ScreenW,height:40) , dropDownViews: items, dropDownViewTitles: dropmenus)
        dropDownMenu.isHidden = true
        
        dropDownMenu.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_sel"), disabled: UIImage(named: "arrow_dim"))
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
    
    var height:CGFloat = 0 {
        willSet{
            self.searchBar.setSearchFieldBackgroundImage(build_image(frame: CGRect.init(x: 0, y: 0, width: 1, height: newValue), color: UIColor.clear), for: .normal)
        }
    }
    
    // leftCityBuuton
    lazy  private var cityButton:UIButton = {
       var button = UIButton.init(title: ("全国", .normal), fontSize: 12, alignment: .center, bColor: UIColor.clear)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.autoresizesSubviews = true
        button.addTarget(self, action: #selector(cityClick), for: .touchUpInside)
        return button
        
    }()
    
    // 搜索历史viewcontroller
    lazy  var serchRecordView:SearchRecodeViewController = {  [unowned self] in
            let vc =  SearchRecodeViewController()
            vc.view.isHidden = true
            vc.resultDelegate = self
            return vc
    }()
    
    var  showRecordView:Bool = false{
        willSet{
            self.serchRecordView.view.isHidden = !newValue
            self.dropDownMenu.isHidden = newValue
            self.dropDownMenu.hideMenu()
        }
    }
    
    
    
    override init(searchResultsController: UIViewController?) {
       
        super.init(searchResultsController: searchResultsController)
       
        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = true
        
        self.definesPresentationContext = true
        self.searchBar.showsCancelButton = false
        self.searchBar.showsBookmarkButton = false
        self.searchBar.searchBarStyle = .default
        self.searchBar.placeholder = "输入查询内容"
        self.searchBar.tintColor = UIColor.blue
        self.searchBar.sizeToFit()
        
        
        //设置透明
        self.searchBar.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.searchBar.alpha = 0.7
        //self.searchBar.setSearchFieldBackgroundImage(build_image(frame: CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0), color: UIColor.clear), for: .normal)
        
        // 去掉背景上下黑线
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.barTintColor = UIColor.clear
        //设置边框和圆角 已经borderview 背景颜色
        searchField = self.searchBar.value(forKey: "searchField") as! UITextField
        searchField.layer.borderColor = UIColor.white.cgColor
        searchField.layer.borderWidth = 1;
        searchField.layer.backgroundColor  = UIColor.white.cgColor
        searchField.backgroundColor = UIColor.clear
        searchField.layer.cornerRadius = 14.0
        searchField.borderStyle  = .roundedRect
        searchField.tintColor = UIColor.black
        searchField.layer.masksToBounds = true
        
        
        searchField.addSubview(self.cityButton)
        searchBar.setPositionAdjustment(UIOffset.init(horizontal: leftDistance, vertical: 0), for: .search)
        cityButton.frame = CGRect.init(x: 5, y: 4.5, width: 30, height: 20)
        self.view.addSubview(self.serchRecordView.view)
        
        // 添加 搜索筛选view
        self.createDropDown()
    }
   
  
    
    override func viewWillLayoutSubviews() {
       // self.resultTableView.tableView.mj_header.beginRefreshing()
        _ = self.serchRecordView.view.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.widthIs(self.view.frame.width)?.leftEqualToView(self.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    
    func createDropDown(){
        
        
        self.view.addSubview(dropDownMenu)
        _ = self.searchResultsController?.view.sd_layout().topSpaceToView(dropDownMenu,0)?.bottomEqualToView(self.view)?.widthIs(self.view.frame.width)
        
    }
    
    
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
        self.cityDelegate?.chooseCity()
    }
    
    
}


// 显示搜索结果
extension baseSearchViewController:SearchResultDelegate,UISearchBarDelegate{
    
    func ShowSearchResults(word: String) {
        // 添加到搜索历史
        localData.shared.appendSearchHistories(value: word)
        self.serchRecordView.AddHistoryItem = true 
        // MARK
        let vm  = (self.searchResultsController as!  searchResultController).vm
        
        SVProgressHUD.show(withStatus: "加载数据")
        vm?.loadData.onNext("load")
        
        
        self.searchBar.text = word
        self.searchBarSearchButtonClicked(self.searchBar)
       
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.showRecordView = false
        searchBar.endEditing(true)
    }
    
    
    
}
