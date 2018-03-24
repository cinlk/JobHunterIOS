//
//  subconditions.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD


fileprivate let campus = "campus"
fileprivate let intern = "intern"
fileprivate let BottomViewH:CGFloat = 300



protocol subconditionDelegate: class {
    func addNewConditionItem(item: subscribeConditionModel)
    func modifyCondition(row:Int, item: subscribeConditionModel )
}

class subconditions: UIViewController {

    
    
    fileprivate let types:[String] = ["实习", "校招"]
    fileprivate let initalType:[String:[(String,String)]] = ["实习":[("职位类型","实习"),("城市","(必选)请选择"),("职位类别","(必选)请选择"),("从事行业","不限"),("实习天数","不限"),("实习薪水","不限"),("实习时间","不限"),("学位","不限")],
        "校招":[("职位类型","校招"),("城市","(必选)请选择"),("职位类别","(必选)请选择"),("从事行业","不限"),("学位","不限"),("薪资范围","不限")]]
    // 与subscribeConditionModel 数据转化
    fileprivate var restMapData:[String:String] = ["职位类型":"校招","城市":"(必选)请选择","职位类别":"(必选)请选择","从事行业":"不限","学位":"不限","薪资范围":"不限","实习天数":"不限","实习薪水":"不限","实习时间":"不限"]
    
    private lazy var table:UITableView = { [unowned self] in
        let table = UITableView.init(frame: self.view.bounds)
        table.separatorStyle = .singleLine
        table.tableFooterView = UIView()
        table.tableHeaderView?.backgroundColor = UIColor.blue
        table.register(conditionCell.self, forCellReuseIdentifier: conditionCell.identity())
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.viewBackColor()
        
        return table
    }()
    
    
    private lazy var tableHeaderView:UIView = { [unowned self] in
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        view.backgroundColor = UIColor.blue
        
        let title =  UILabel()
        title.text = "新增订阅条件"
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = UIColor.white
        title.textAlignment = .center
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        view.addSubview(title)
        _ = title.sd_layout().centerXEqualToView(view)?.bottomSpaceToView(view,5)?.autoHeightRatio(0)
        title.setMaxNumberOfLinesToShow(1)
        
        
        let story =  UIButton.init(type: .custom)
        story.setTitle("保存", for: .normal)
        story.titleLabel?.font  = UIFont.systemFont(ofSize: 12)
        story.addTarget(self, action: #selector(storage), for: .touchUpInside)
        
        view.addSubview(story)
        
        _ = story.sd_layout().rightSpaceToView(view,10)?.bottomSpaceToView(view,5)?.widthIs(60)?.heightIs(20)
        
        let cancel = UIImageView.init(image: UIImage.init(named: "cancel"))
        cancel.clipsToBounds  = true
        //
        let close = UITapGestureRecognizer(target: self, action:#selector(closed)) // 添加点击事件
        
        close.numberOfTouchesRequired = 1
        cancel.isUserInteractionEnabled = true
        cancel.addGestureRecognizer(close)
        
        
        view.addSubview(cancel)
        
        _  = cancel.sd_layout().leftSpaceToView(view,10)?.bottomEqualToView(story)?.widthIs(20)?.heightIs(20)
       
        return view
    }()
    
   


    // 背景view
    private lazy var darkView:UIView = { [unowned self] in
        
        let darkView = UIView()
        darkView.frame = CGRect(x: 0, y: 0, width:ScreenW, height:ScreenH)
        darkView.backgroundColor = UIColor.lightGray
        darkView.alpha = 0.5
        darkView.isHidden = true
        darkView.isUserInteractionEnabled = true // 打开用户交互
        let singTap = UITapGestureRecognizer(target: self, action:#selector(hidenView)) // 添加点击事件
        singTap.numberOfTouchesRequired = 1
        darkView.addGestureRecognizer(singTap)
        return darkView
    }()
    
    
    // 一个tableview
    private lazy  var SelectedOne:SelectedOneTablView = { [unowned self] in
        let one =  SelectedOneTablView.init(frame: CGRect(x: 0, y: ScreenH, width: ScreenW, height: BottomViewH))
        
        one.call  = self.selectOneItem
        return one
    }()
    
    
    // 包含左右2个table的view
    private lazy var SelectedSecond:SelectedTowTableView = {

        let second = SelectedTowTableView.init(frame:  CGRect(x: 0, y: ScreenH, width: ScreenW, height: BottomViewH))
        second.call  = selectOneItem
        return second
    }()
    
    // 包含3个tableview 的界面
    private lazy var  SelectedThird:SelectedThreeTableView = { [unowned self] in
        
        let third = SelectedThreeTableView.init(frame: CGRect(x: 0, y: ScreenH, width: ScreenW, height: BottomViewH))
        third.call  = self.selectOneItem
        return third
    }()
    
    // 底部弹出界面位置
    private var centerCategoryY:CGFloat = 0

    private var centerCityY:CGFloat = 0
    
    private var centerJobcategorysY:CGFloat = 0
    
    // 修改数据界面不能切换 职位类型
    private var isEdit = false
    // 父view修改订阅条件所在的行数
    private var row:Int = 0
    // 默认显示校招 条目
    private var type:String = "校招"
    
    private var currentItems:[(String,String)]  = []
    
    // 代理回传数据
    weak var delegate:subconditionDelegate?
    
    var editData:subscribeConditionModel?{
        didSet{
            isEdit = true
            type = editData?.type ?? "校招"
            // 编辑数据 对应table 数据
            
            currentItems = editData!.getAttributes()
            for item in currentItems{
                restMapData[item.0] = item.1
            }
            self.table.reloadData()
            
        }
    }
    
    init(row:Int? = nil) {
        self.row = row ?? 0
        if let res = initalType[type]{
            currentItems = res
        }
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearNodeStatus()
        
    }


}

extension  subconditions:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  currentItems.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell =  table.dequeueReusableCell(withIdentifier: conditionCell.identity(), for: indexPath) as! conditionCell
        cell.mode = currentItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! conditionCell
        guard let name = cell.mode?.0 else{
            return
        }
        // 不切换职位类型
        if isEdit && indexPath.row == 0{
            return
        }
        self.showSelectedView(title:name, row: indexPath.row)
        
        
    }
    
}

extension subconditions{
    
    
    private func setViews(){
        
        table.tableHeaderView = tableHeaderView
        centerCategoryY = SelectedOne.centerY
        centerCityY = SelectedSecond.centerY
        centerJobcategorysY = SelectedThird.centerY
        
        
        self.view.addSubview(table)
        // dartview 在table 前顺序
        self.view.addSubview(darkView)
        self.view.addSubview(SelectedOne)
        self.view.addSubview(SelectedSecond)
        self.view.addSubview(SelectedThird)
    }
    
    
    
    
    func showSelectedView(title:String, row:Int){
        
        darkView.isHidden = false
        switch title {
            
        case "职位类型", "学位", "薪资范围", "实习天数", "实习时间", "实习薪水":
            SelectedOne.title.text = title
            SelectedOne.mode = (name:title, row:row)
            SelectedOne.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.SelectedOne.frame = CGRect.init(x: 0, y: ScreenH - BottomViewH, width: ScreenW, height: BottomViewH)
            })
        case "城市","从事行业":
            SelectedSecond.title.text = title
            SelectedSecond.mode = (name: title, row: row)
            SelectedSecond.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.SelectedSecond.frame = CGRect.init(x: 0, y: ScreenH - BottomViewH, width: ScreenW, height: BottomViewH)
            })
            
        case "职位类别":
            SelectedThird.title.text = title
            SelectedThird.mode = (name:title,row: row)
            SelectedThird.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.SelectedThird.frame = CGRect(x: 0, y: ScreenH-BottomViewH, width: ScreenW, height: BottomViewH)

        }, completion: nil)
        
        default:
            return
        }
          
    }
    
    

    // 回调方法
    func selectOneItem(name:String,value:String, row:Int){
        
        self.hidenView()
        // 切换当前视图
        if name == "职位类型" && value != type{
            restMapData["职位类型"] = value
            type = value
            currentItems = initalType[type] ?? []
            self.table.reloadData()
            clearNodeStatus()
            // 清楚数据
            SelectedThird.results.removeAll()
            

        }else if name == "职位类型" && value == type{}
            
        else{
            // 刷新当前行数据
            currentItems[row].1 = value
            restMapData[currentItems[row].0] = value
            self.table.reloadRows(at: [IndexPath.init(item: row, section: 0)], with: .automatic)
            
        }
        
    }
    
    private func clearNodeStatus(){
        
        // 清楚所有选中类型的node选中状态
        for (name, _) in restMapData{
            SelectItemUtil.shared.clearByName(name: name)
        }
        
    }
 
    

}
extension subconditions{
    
    // 保存条件数据
    @objc func storage(sender:UIButton){
        
        
        if  restMapData["职位类别"] == "(必选)请选择" || restMapData["职位类别"]!.isEmpty{
            SVProgressHUD.showError(withStatus: "职位类别不能为空")
            SVProgressHUD.dismiss(withDelay: 2)
            return
        }
        if restMapData["城市"] == "(必选)请选择" || restMapData["城市"]!.isEmpty{
            SVProgressHUD.showError(withStatus: "城市不能为空")
            SVProgressHUD.dismiss(withDelay: 2)
            return
        }
        

        guard  let item = subscribeConditionModel(JSON: [:]) else{ return }
        item.transForData(target: restMapData)
        if isEdit{
            self.delegate?.modifyCondition(row: self.row, item: item)
        }else{
            self.delegate?.addNewConditionItem(item: item)
        }
        
        clearNodeStatus()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func closed(sender:UIImage){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hidenView(){
        darkView.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            
            self.SelectedOne.centerY =  self.centerCategoryY
            self.SelectedSecond.centerY  = self.centerCityY
            self.SelectedThird.centerY = self.centerJobcategorysY
            self.SelectedOne.isHidden = true
            self.SelectedSecond.isHidden = true
            self.SelectedThird.isHidden = true
            
        }, completion: nil)

    }
}




