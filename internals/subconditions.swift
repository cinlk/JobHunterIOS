//
//  subconditions.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let BottomViewH:CGFloat = 300
fileprivate let cellIdentity:String = "cell"
fileprivate let cellH:CGFloat = 55

protocol subconditionDelegate: class {
    func addNewConditionItem(item: BaseSubscribeModel)
    func modifyCondition(index:IndexPath, item: BaseSubscribeModel )
}

class subconditions: UIViewController {

    private lazy var table:UITableView = { [unowned self] in
        let table = UITableView.init(frame: self.view.bounds)
        table.separatorStyle = .singleLine
        table.tableFooterView = UIView()
        table.tableHeaderView?.backgroundColor = UIColor.blue
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.viewBackColor()
        
        return table
    }()
    
    
    private lazy var tableHeaderView:UIView = { [unowned self] in
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: NavH))
        view.backgroundColor = UIColor.blue
        
        let title =  UILabel()
        title.text = "新增订阅条件"
        title.tag  = 10
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = UIColor.white
        title.textAlignment = .center
        title.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        view.addSubview(title)
        _ = title.sd_layout().centerXEqualToView(view)?.bottomSpaceToView(view,10)?.autoHeightRatio(0)
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
    
   
    private lazy var btnBackGround:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH))
        btn.addTarget(self, action: #selector(hidenView), for: .touchUpInside)
        btn.backgroundColor = UIColor.lightGray
        btn.alpha = 0.5
        btn.isHidden = true
        return btn
    }()
  
    
    
    // 一个tableview
    private lazy  var SelectedOne:SelectedOneTablView = { [unowned self] in
        let one =  SelectedOneTablView.init(frame: CGRect(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: BottomViewH))
        one.call  = self.selectOneItem
        return one
    }()
    
    
    // 包含左右2个table的view
    private lazy var SelectedSecond:SelectedTowTableView = {
        let second = SelectedTowTableView.init(frame:  CGRect(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: BottomViewH))
        second.call  = selectOneItem
        return second
    }()
    
    
    // 状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .lightContent
        }
    }
    
    internal var navTitle:String?{
        didSet{
            (self.tableHeaderView.viewWithTag(10) as! UILabel).text = navTitle
        }
    }
    
    // 修改数据界面不能切换 职位类型
    private var isEdit = false
    // 父view修改订阅条件所在的行数
    private var indexPath:IndexPath?
    
    // 默认显示校招 条目
    private var type:subscribeType = .graduate
    
    private var currentItems:BaseSubscribeModel?{
        didSet{
            data = currentItems!.getTypeValue()
            keys = currentItems!.getKeys()
        }
    }
    
    // 所有的key
    fileprivate var keys:[subscribeItemType] = []
    fileprivate var data:[subscribeItemType:String] = [:]
    
    
    
    // 代理回传数据
    weak var delegate:subconditionDelegate?
    
    var editData:(type:subscribeType, data:BaseSubscribeModel, index:IndexPath)?{
        didSet{
            guard let edit  = editData else {
                return
            }
            isEdit = true
            self.indexPath = edit.index
            
            type = edit.type
            // 编辑数据 对应table 数据
            if type == .intern{
                currentItems = edit.data as? internSubscribeModel
            }else{
                currentItems = edit.data as? graduateSubscribeModel

            }
            self.table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 默认是校招
        
        currentItems = graduateSubscribeModel(JSON: ["type":self.type.rawValue])
        
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
        return  data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIdentity)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text =  keys[indexPath.row].describe
        if data[keys[indexPath.row]] == subscribeType.graduate.rawValue{
             cell.detailTextLabel?.text = subscribeType.graduate.describe
        }else if data[keys[indexPath.row]] == subscribeType.intern.rawValue{
            cell.detailTextLabel?.text = subscribeType.intern.describe

        }else if data[keys[indexPath.row]]!.isEmpty{
            cell.detailTextLabel?.text = "(必须填写)"
        }else {
            cell.detailTextLabel?.text = data[keys[indexPath.row]]

        }
       
        cell.detailTextLabel?.textColor = UIColor.lightGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let type =  keys[indexPath.row]
        // 不切换职位类型
        if isEdit && indexPath.row == 0{
            return
        }
        self.showSelectedView(type:type, row: indexPath.row)
        
        
    }
    
}

extension subconditions{
    
    
    private func setViews(){
        
        table.tableHeaderView = tableHeaderView
        self.view.addSubview(table)
        self.view.addSubview(btnBackGround)
        self.view.addSubview(SelectedOne)
        self.view.addSubview(SelectedSecond)
    }
    
    
    
    
    func showSelectedView(type:subscribeItemType, row:Int){
        
        btnBackGround.isHidden = false
        
        switch type {
            
        case .type, .degree, .salary, .internDay, .internSalary, .internMonth:
            
            SelectedOne.mode = (name:type.describe, row:row)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.SelectedOne.frame = CGRect.init(x: 0, y: GlobalConfig.ScreenH - BottomViewH, width: GlobalConfig.ScreenW, height: BottomViewH)
            }, completion: nil)
           
        case .locate, .business:
            
            SelectedSecond.mode = (name: type.describe, row: row)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.SelectedSecond.frame = CGRect.init(x: 0, y: GlobalConfig.ScreenH - BottomViewH, width: GlobalConfig.ScreenW, height: BottomViewH)
                
            }, completion: nil)
            

        }
          
    }
    
    

    // 回调方法
    func selectOneItem(value:String, row:Int){
        
        self.hidenView()
        
        if row == 0 {
            // 切换数据
            if value != type.describe{
                
                if value == "实习"{
                    type = .intern
                    currentItems =  internSubscribeModel(JSON: ["type":type.rawValue])
                }else{
                    type = .graduate
                    currentItems = graduateSubscribeModel(JSON: ["type":type.rawValue])
                }
                clearNodeStatus()
                self.table.reloadData()
            }
        }else{
            data[keys[row]] = value
            self.table.reloadRows(at: [IndexPath.init(item: row, section: 0)], with: .automatic)
        }
        
    }
    
    
    // 取消被选中的node
    private func clearNodeStatus(){
        
        for (key,_) in data{
            SelectItemUtil.shared.clearByName(name: key.describe)
        }
        
    }
 
    

}
extension subconditions{
    
    // 保存条件数据
    @objc func storage(sender:UIButton){
        
        var res:[String:String] = [:]
        data.forEach {
            res[$0.key.rawValue] = $0.value
        }
        
        switch type {
        case .intern:
            
            // 检查条件
            if res[subscribeItemType.locate.rawValue]!.isEmpty{
                self.view.showToast(title: "请选择城市", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "请选择城市", view: self.view)
                return
            }
            if res[subscribeItemType.internDay.rawValue]!.isEmpty{
                self.view.showToast(title: "请选择实习天数", customImage: nil, mode: .text)

                //showOnlyTextHub(message: "请选择实习天数", view: self.view)
                return
            }
            if res[subscribeItemType.internMonth.rawValue]!.isEmpty{
                self.view.showToast(title: "请选择实习时间", customImage: nil, mode: .text)

               // showOnlyTextHub(message: "请选择实习时间", view: self.view)
                return
            }
            
            
            currentItems = internSubscribeModel(JSON: res)
        case .graduate:
             // 检查条件
            if res[subscribeItemType.locate.rawValue]!.isEmpty{
                self.view.showToast(title: "请选择城市", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "请选择城市", view: self.view)
                return
            }
            
            currentItems = graduateSubscribeModel(JSON: res)
           
            
        default:
            break
        }
        

        if isEdit{
            self.delegate?.modifyCondition(index: self.indexPath!, item: currentItems!)
        }else{
            self.delegate?.addNewConditionItem(item: currentItems!)
        }
        
        clearNodeStatus()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func closed(sender:UIImage){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hidenView(){
        btnBackGround.isHidden = true
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.SelectedOne.origin.y = GlobalConfig.ScreenH
            self.SelectedSecond.origin.y = GlobalConfig.ScreenH
            
        }, completion: nil)

    }
}




