//
//  baseSearchViewController.swift
//  internals
//
//  Created by ke.liang on 2017/9/23.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNSearch
import YNDropDownMenu



protocol baseSearchDelegate {
    func chooseCity()
}




class baseSearchViewController: UISearchController {

    
    var searchField:UITextField!
    let leftDistance:CGFloat = 40
    var cityDelegate:baseSearchDelegate?
    
    var height:Int = 0 {
        willSet{
            self.searchBar.setSearchFieldBackgroundImage(build_image(frame: CGRect.init(x: 0, y: 0, width: 1, height: newValue), color: UIColor.clear), for: .normal)
        }
    }
    
    // leftCityBuuton
    lazy  private var cityButton:UIButton = {
       var button = UIButton.init()
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor.clear
        button.setTitle("全国", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.autoresizesSubviews = true
        button.addTarget(self, action: #selector(cityClick), for: .touchUpInside)
        return button
        
    }()
    
    
    var resultTableView:UITableViewController!
    
    
    override init(searchResultsController: UIViewController?) {
        
        super.init(searchResultsController: searchResultsController)
        
        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = true
        self.searchBar.showsCancelButton = false
        self.searchBar.showsBookmarkButton = false

        self.searchBar.searchBarStyle = .default
        self.searchBar.placeholder = "输入查询内容"
        self.searchBar.tintColor = UIColor.blue
        
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
            
//        let icon = searchField.leftView!
//        let textfiledlabel = searchField.value(forKey: "placeholderLabel") as! UILabel
        searchBar.setPositionAdjustment(UIOffset.init(horizontal: leftDistance, vertical: 0), for: .search)
        //_ = cityButton.sd_layout().bottomEqualToView(textfiledlabel)?.rightSpaceToView(icon,10)?.widthIs(30)?.heightIs(20)
        
        cityButton.frame = CGRect.init(x: 5, y: 4.5, width: 30, height: 20)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    
    func createDropDown(menus:[String],views:[YNDropDownView]){
        
      
        let items:[YNDropDownView] = views
        let conditions = YNDropDownMenu(frame: CGRect(x:0,y:0,width:self.view.frame.width,height:40) , dropDownViews: items, dropDownViewTitles: menus)
        
        
        conditions.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_sel"), disabled: UIImage(named: "arrow_dim"))
        conditions.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        conditions.setLabelFontWhen(normal: .systemFont(ofSize: 12), selected: .boldSystemFont(ofSize: 12), disabled: .systemFont(ofSize: 12))
        
        
        conditions.backgroundBlurEnabled = true
        conditions.bottomLine.isHidden = false
        let back = UIView()
        back.backgroundColor = UIColor.black
        conditions.blurEffectView = back
        conditions.blurEffectViewAlpha = 0.7
        conditions.setBackgroundColor(color: UIColor.white)
        self.view.addSubview(conditions)
        _ = self.searchResultsController?.view.sd_layout().topSpaceToView(conditions,0.01)?.bottomEqualToView(self.view)?.widthIs(self.view.frame.width)

        
    }
    
    
    func changeCityTitle(title:String){
        
        // 计算city 字符串长度，改变button长度，和searchicon 偏移位置
        let rect = title.getStringCGRect(size: CGSize.init(width: 100, height: 0),font: (self.cityButton.titleLabel?.font!)!)
        if rect.width > 30{
            
            let add =  rect.width - 30
            UIView.animate(withDuration: 0.1, animations: {
                self.searchBar.setPositionAdjustment(UIOffsetMake(self.leftDistance + add, 0), for: .search)
                self.cityButton.frame = CGRect.init(x: 5, y: 4.5, width: 30 + add , height: 20)
                
            })
        }else{
            self.cityButton.frame = CGRect.init(x: 5, y: 4.5, width: 30, height: 20)
            self.searchBar.setPositionAdjustment(UIOffsetMake(self.leftDistance  , 0), for: .search)

        }
    
        self.cityButton.setTitle(title, for: .normal)

    }
    
    @objc func cityClick(){
        self.cityDelegate?.chooseCity()
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


