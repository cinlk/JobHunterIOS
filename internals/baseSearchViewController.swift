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

class baseSearchViewController: UISearchController {

    
    var height:Int = 0 {
        willSet{
            self.searchBar.setSearchFieldBackgroundImage(build_image(frame: CGRect.init(x: 0, y: 0, width: 1, height: newValue), color: UIColor.clear), for: .normal)
        }
    }
    
    var resultTableView:UITableViewController!
    
    
    override init(searchResultsController: UIViewController?) {
        
        super.init(searchResultsController: searchResultsController)
        
        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = true
        self.searchBar.showsCancelButton = false
        self.searchBar.showsBookmarkButton = false

        self.searchBar.searchBarStyle = .default
        self.searchBar.placeholder = "输入查询内容"
        //设置透明
        self.searchBar.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        self.searchBar.alpha = 0.7
        //self.searchBar.setSearchFieldBackgroundImage(build_image(frame: CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0), color: UIColor.clear), for: .normal)
        
        // 去掉背景上下黑线
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.barTintColor = UIColor.clear
        
        
    
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func customerBookmark(cname:String){
        
        
        let im = UIImage()
        
        self.searchBar.showsBookmarkButton = true

        self.searchBar.setImage(im.str_image(cname, size: (60.0,60.0)), for: .bookmark, state: .normal)
        
        // fix  size TODO
        self.searchBar.setPositionAdjustment(UIOffsetMake(-250, 0), for: .bookmark)
        
       // self.indexOfSearchFieldInSubviews()
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


