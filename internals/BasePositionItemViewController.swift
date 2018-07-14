//
//  BasePositionItemViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu


class BasePositionItemViewController: BaseViewController {

    internal let dropMenuH:CGFloat = 40

    // 内容显示table
    lazy var table:UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.viewBackColor()
       
        
        return table
    }()
    
    
    // 选择城市
    internal lazy var cityMenu:DropItemCityView = {
        let city = DropItemCityView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 200))
        // 覆盖指定高度
        
        city.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + 35)
        return city
    }()
    
    // 行业分类
    internal lazy var industryKind:DropItemIndustrySectorView = {
        let indus = DropItemIndustrySectorView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
       
        indus.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + 35)

        return indus
        
    }()
    // 公司性质
    internal lazy var companyKind: DropCompanyPropertyView = {
        let company = DropCompanyPropertyView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 6*45))
        company.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + 35)

        return company
    }()
    
    // 大学
    internal lazy var colleges: DropCollegeItemView = {
        let college = DropCollegeItemView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 200))
        college.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + 35)

        return college
    }()
    
    
    // 职业类型
    lazy var careerClassify:DropCarrerClassifyView = { [unowned self] in
        let v1 = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 240))
        v1.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + 35)

        
        return v1
    }()
    
    // 学历
    lazy var degree:DropDegreeMenuView = { [unowned self] in
        let v = DropDegreeMenuView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 45*5))
        v.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + 35)

        return v
    }()
    
    
    // 宣讲会过期?
    internal lazy var meetingValidate:DropValidTimeView = {  [unowned self] in
        
        let v1 = DropValidTimeView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 45*3))
        v1.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + 35)
    
        return v1
    }()
    
    
    // 实习条件
    internal lazy var  internCondition:DropInternCondtionView = { [unowned self] in
        let v1 = DropInternCondtionView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 200))
        
        v1.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + 35)

        return v1
        
    }()
    
    //
    internal  lazy var meetingTime:YNDropDownView = { [unowned self] in
        let v1 = DropCarrerClassifyView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH - 260))
        v1.backGroundBtn.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH + 35)

        return v1
    }()
    
    // 条件选择下拉菜单view
    lazy var dropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = YNDropDownMenu.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: dropMenuH), dropDownViews: [cityMenu,industryKind], dropDownViewTitles: ["城市","行业领域"])
        
        menu.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_xl"), disabled: UIImage(named: "arrow_dim"))
        menu.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
        menu.backgroundBlurEnabled = true
        menu.blurEffectViewAlpha = 0.5
        menu.showMenuSpringWithDamping = 1
        menu.hideMenuSpringWithDamping = 1
        menu.bottomLine.isHidden = false
        
        // 添加手势
        menu.addSwipeGestureToBlurView()
        

        return menu
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(table)
        self.view.addSubview(dropMenu)
        
        _ = table.sd_layout().topSpaceToView(self,dropMenuH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func setViews() {
        
        self.handleViews.append(table)
        self.handleViews.append(dropMenu)
        super.setViews()
        
    }
    
    // 子类实现方法 MARK 抽象出来必须实现（语法？？）
    func sendRequest(){
    
    }

    
    

   

}



