//
//  subconditions.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let campus = "campus"
fileprivate let intern = "intern"



fileprivate let tableHeadH:CGFloat = 64
fileprivate let categoryH:CGFloat = 200
fileprivate let salayViewH:CGFloat = 300
fileprivate let internDayViewH:CGFloat = 300
fileprivate let internMonthViewH:CGFloat = 300
fileprivate let levelH:CGFloat = 300
fileprivate let cityH:CGFloat = 300
fileprivate let businessH:CGFloat = 300
fileprivate let jobcategoryH:CGFloat = 300
fileprivate let NotificationName = "resetTable"

class subconditions: UIViewController {

    
    
    
    lazy var table:UITableView = { [unowned self] in
        var table = UITableView.init()
        table = UITableView.init(frame: self.view.frame)
        table.tableHeaderView =  UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableHeadH))
        table.tableHeaderView?.backgroundColor = UIColor.blue
        table.tableFooterView =  UIView()
        table.register(UINib(nibName:"conditionCell", bundle:nil), forCellReuseIdentifier: conditionCell.identity())
        
        
        let title =  UILabel()
        title.text = "新增订阅条件"
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = UIColor.white
        
        table.tableHeaderView?.addSubview(title)
        _ = title.sd_layout().centerXEqualToView(table.tableHeaderView)?.widthIs(160)?.heightIs(30)?.bottomSpaceToView(table.tableHeaderView,5)
        
        let story =  UIButton.init(type: .custom)
        story.setTitle("保存", for: .normal)
        story.titleLabel?.font  = UIFont.systemFont(ofSize: 12)
        story.addTarget(self, action: #selector(storage), for: .touchUpInside)
        
        table.tableHeaderView?.addSubview(story)
        _ = story.sd_layout().rightSpaceToView(table.tableHeaderView,10)?.bottomSpaceToView(table.tableHeaderView,5)?.widthIs(60)?.heightIs(20)
        
        let cancel = UIImageView.init(image: UIImage.init(named: "cancel"))
        cancel.clipsToBounds  = true
        //
        
        let close = UITapGestureRecognizer(target: self, action:#selector(closed)) // 添加点击事件
        
        close.numberOfTouchesRequired = 1
        cancel.isUserInteractionEnabled = true
        cancel.addGestureRecognizer(close)
        
        
        table.tableHeaderView?.addSubview(cancel)
        
        _  = cancel.sd_layout().leftSpaceToView(table.tableHeaderView,10)?.bottomSpaceToView(table.tableHeaderView,5)?.widthIs(20)?.heightIs(20)
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        return table
        
    }()
    
    
    private let subscribeData = SubScribeConditionItems.init()


    //从事行业
    
    // 弹出界面
    lazy var darkView:UIView = { [unowned self] in
        
        let darkView = UIView()
        darkView.frame = CGRect(x: 0, y: 0, width:ScreenW, height:ScreenH)
        darkView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
        darkView.isUserInteractionEnabled = true // 打开用户交互
        
        let singTap = UITapGestureRecognizer(target: self, action:#selector(hidenView)) // 添加点击事件
        singTap.numberOfTouchesRequired = 1
        darkView.addGestureRecognizer(singTap)
        return darkView
    }()
    
    
    fileprivate lazy  var category:ChooseOneView = { [unowned self] in
        let category =  ChooseOneView.init(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: categoryH), info: subscribeData.types )
        category.call  = self.oneItem
        
        return category
    }()
    private var centerlxY:CGFloat = 0
    
    
    
    fileprivate lazy var citys:CityAndBusiness = {

        let citys = CityAndBusiness.init(frame:  CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: cityH), leftInfo: subscribeData.cityCond.city, righInfo: subscribeData.cityCond.cityChilds)
        citys.call  = getCity
        return citys
    }()
    

    var centerCityY:CGFloat = 0
    
    fileprivate lazy var business:CityAndBusiness = {
        let business  = CityAndBusiness.init(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: businessH), leftInfo: subscribeData.businessCond.business, righInfo: subscribeData.businessCond.businessChilds)
        business.call  = getCity
        return business
    }()
    
    var centerIndustryY:CGFloat = 0
    
    fileprivate lazy var salaryrange:ChooseOneView = { [unowned self] in
        let salaryrange = ChooseOneView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: salayViewH), info: subscribeData.salary)
        salaryrange.call  = self.oneItem
       
        return salaryrange
    }()
    
    var centersalaryY:CGFloat = 0
    
    fileprivate lazy var internDay:ChooseOneView = {
        let  internDay = ChooseOneView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: internDayViewH), info: subscribeData.internDay)
        
        internDay.call  = self.oneItem
        return internDay
    }()
    var centershixidayY:CGFloat = 0
    
     fileprivate lazy  var internMonth:ChooseOneView = { [unowned self] in
        let  internMonth = ChooseOneView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: internMonthViewH),info: subscribeData.internMonth)
        internMonth.call  = self.oneItem
        return internMonth
    }()
    
    
    var centermonthY:CGFloat = 0
    
     fileprivate lazy var degree:ChooseOneView = {
        let degree = ChooseOneView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: levelH),info: subscribeData.degree)
        degree.call  = self.oneItem
        return degree
    }()
    
    
    
    var centerlevelY:CGFloat = 0
    
    
    fileprivate lazy var  jobcategorys:Jobclassificatin = { [unowned self] in
        
        let jobcategorys = Jobclassificatin.init(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: jobcategoryH), level1: subscribeData.jobCategory.level1, level2:  subscribeData.jobCategory.level2, level3:  subscribeData.jobCategory.level3)
        jobcategorys.call  = self.oneItem
        return jobcategorys
    }()
    
    var centercY:CGFloat = 0
    
    fileprivate var isEdit = false
    fileprivate var row:Int = 0
    
    //storage
    let data  =  localData.shared
    
    
    
    
    init(modifyData:[String:String]? = nil, row:Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        if let data = modifyData{
            subscribeData.swich = data["职位类型"]!
            subscribeData.setCurrentValueByDict(data: data)
            isEdit = true
            self.row = row!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        
    }


}

extension  subconditions:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  subscribeData.currentTypeList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell =   table.dequeueReusableCell(withIdentifier: conditionCell.identity(), for: indexPath) as? conditionCell{
            let name = subscribeData.currentTypeList[indexPath.row]
            cell.name.text =  name
            cell.value.text  = subscribeData.getCurrentValue()[name]
            
            return cell
        }
        
        return UITableViewCell.init()
      
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return conditionCell.cellHeight()
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! conditionCell
        guard let name = cell.name.text else{
            return
        }
        // 不能修改职位类型
        if isEdit && indexPath.row == 0{
            return
        }
        self.showSelectedView(title: name)
        
        
    }
    
}

extension subconditions{
    
    
    private func setViews(){
        
        centerlxY = category.centerY
        centersalaryY = salaryrange.centerY
        centershixidayY = internDay.centerY
        centermonthY = internMonth.centerY
        centerlevelY = degree.centerY
        centerCityY = citys.centerY
        centerIndustryY = business.centerY
        centercY = jobcategorys.centerY
        
        
        self.view.addSubview(table)
        self.view.addSubview(category)
        self.view.addSubview(salaryrange)
        self.view.addSubview(internMonth)
        self.view.addSubview(internDay)
        self.view.addSubview(degree)
        self.view.addSubview(citys)
        self.view.addSubview(business)
        self.view.addSubview(jobcategorys)
    }
    
    func showSelectedView(title:String){
        self.view.insertSubview(darkView, at: 1)
        
        switch title {
            case "职位类型":
                category.title.text = title
                UIView.animate(withDuration: 0.5, animations: {
                    self.category.frame  = CGRect(x: 0, y: self.view.frame.height-categoryH, width: self.view.frame.width, height: categoryH)
                }, completion: nil)
        
            case "工作城市","实习城市":
                citys.title.text  = title
                UIView.animate(withDuration: 0.5, animations: {
                    self.citys.frame = CGRect(x: 0, y: self.view.frame.height-cityH, width: self.view.frame.width, height: cityH)
                    
                }, completion: nil)
        
            case "从事行业":
                business.title.text = title
                UIView.animate(withDuration: 0.5, animations: {
                    self.business.frame = CGRect(x: 0, y: self.view.frame.height-businessH, width: self.view.frame.width, height: businessH)
                    
                }, completion: nil)
            
             case "薪资范围":
                self.salaryrange.changeInfoValue(newValue: subscribeData.salary)
                salaryrange.title.text = title
                UIView.animate(withDuration: 0.5, animations: {
                    self.salaryrange.frame = CGRect(x: 0, y: self.view.frame.height-salayViewH, width: self.view.frame.width, height: salayViewH)
                    
                }, completion: nil)
            
            case "实习薪水":
                self.salaryrange.changeInfoValue(newValue: subscribeData.internSalary)
                salaryrange.title.text = title
                UIView.animate(withDuration: 0.5, animations: {
                    self.salaryrange.frame = CGRect(x: 0, y: self.view.frame.height-salayViewH, width: self.view.frame.width, height: salayViewH)
                    
                }, completion: nil)
            
            case "实习天数":
                internDay.title.text = title
                UIView.animate(withDuration: 0.5, animations: {
                    self.internDay.frame = CGRect(x: 0, y: self.view.frame.height-internDayViewH, width: self.view.frame.width, height: internDayViewH)
                    
                }, completion: nil)
 
            case "实习时间":
                internMonth.title.text = title
                UIView.animate(withDuration: 0.5, animations: {
                    self.internMonth.frame = CGRect(x: 0, y: self.view.frame.height-internMonthViewH, width: self.view.frame.width, height: internMonthViewH)
                    
                }, completion: nil)
        
             case "学历":
                degree.title.text = title
                UIView.animate(withDuration: 0.5, animations: {
                    self.degree.frame = CGRect(x: 0, y: self.view.frame.height-levelH, width: self.view.frame.width, height: levelH)
                    
                }, completion: nil)
        
             case "职位类别":
                jobcategorys.title.text = title
                UIView.animate(withDuration: 0.5, animations: {
                    self.jobcategorys.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
                    
                }, completion: nil)
 
            default:
                break
                }
        
          
    }
    
    

    // 回调方法
    func oneItem(type:String,val:String){
         if type  == "职位类型"{
            subscribeData.swich = val
            subscribeData.resetCurrentValue()
            // 取消被选中的cell item
            NotificationCenter.default.post(name:  NSNotification.Name(rawValue: NotificationName), object: self, userInfo: nil)
            
        }
        else{
            subscribeData.updateCurrentValue(value: val, key: type)
        }
        self.hidenView()
        self.table.reloadData()
    }
    
    func getCity(type:String,locate:String){
        subscribeData.updateCurrentValue(value: locate, key: type)
        self.hidenView()
        self.table.reloadData()
        
        
    }
    

}
extension subconditions{
    @objc func storage(sender:UIButton){
        
           
        let (result, err) = subscribeData.getResults()
        guard  result != nil else {
            let alert = UIAlertController.init(title: err!, message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
            return
            
        }
       
        if result?["职位类型"] == "校招"{
            if isEdit{
                data.updateSubscribe(type: campus, value: result!, index: self.row)
            }else{
                data.appendSubscribe(type: campus, value: result!)
            }
        }else if result?["职位类型"] == "实习"{
            if isEdit{
                data.updateSubscribe(type: intern, value: result!, index: self.row)
            }else{
                data.appendSubscribe(type: intern, value: result!)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func closed(sender:UIImage){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func hidenView(){
        darkView.removeFromSuperview()
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.category.centerY =  self.centerlxY
            self.citys.centerY  = self.centerCityY
            self.business.centerY = self.centerIndustryY
            self.salaryrange.centerY  = self.centersalaryY
            self.internDay.centerY = self.centershixidayY
            self.internMonth.centerY = self.centermonthY
            self.degree.centerY = self.centerlevelY
            self.jobcategorys.centerY = self.centercY
            
        }, completion: nil)

    }
}




//
private class ChooseOneView:UIView,UITableViewDelegate,UITableViewDataSource{
    
    
    // 回调传值
    var call:((String,String)->Void)?
    
    
    private var table:UITableView = UITableView()
    var title = UILabel()
    private var info:[String]!
 
    
    init(frame: CGRect, info:[String]) {
        self.info = info
        
        super.init(frame: frame)
        
        self.setViews()
        
    }
    
    private func setViews(){
        
        title.text = "职位类型"
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        let line = UIView()
        line.backgroundColor  = UIColor.lightGray
        self.backgroundColor  = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(title)
        self.addSubview(line)
        self.addSubview(table)
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(resetTable(_:)), name: NSNotification.Name(rawValue: NotificationName), object: nil)
        
        
        _ = title.sd_layout().topSpaceToView(self,5)?.centerXEqualToView(self)?.widthIs(120)?.heightIs(25)
        _ = line.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topSpaceToView(self,35)?.heightIs(1)
        _ = table.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.topSpaceToView(line,0)
        
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationName), object: nil)
    }
    
    @objc private func resetTable(_ notify:NotificationCenter){
        self.table.indexPathsForSelectedRows?.forEach({ [unowned self]  (index) in
             let cell = self.table.cellForRow(at: index)
             cell?.textLabel?.isHighlighted = false
        })
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = info[indexPath.row]
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font  = UIFont.systemFont(ofSize: 12)
        cell.selectionStyle = .none
        cell.textLabel?.highlightedTextColor = UIColor.blue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.isHighlighted = true
        
        self.call?(title.text!,(cell?.textLabel?.text)!)
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.isHighlighted = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  40
    }
    
   
    func changeInfoValue(newValue:[String]){
        self.info = newValue
    }
    
    
}

//  工作城市 和 从事行业

private class CityAndBusiness:UIView,UITableViewDelegate,UITableViewDataSource{
    
    
    private lazy var lefttable:UITableView = {
        var table = UITableView()
        table.backgroundColor = UIColor.gray
        table.tableFooterView = UIView()
        table.isMultipleTouchEnabled  = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private lazy var righttable:UITableView = {
       var table = UITableView()
        table.backgroundColor = UIColor.white
        table.tableFooterView = UIView()
        table.isMultipleTouchEnabled  = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
        
    }()
    var title:UILabel = UILabel()
    var line:UIView = UIView()
    
    // 
    var call:((String,String)->Void)?
    
   
    private var leftcity:[String]!
    private var rightcity:Dictionary<String,[String]>!
    // 左边选中值
    private var choosed:String = "不限"
    
    init(frame: CGRect, leftInfo:[String], righInfo:Dictionary<String,[String]>) {
        self.leftcity = leftInfo
        self.rightcity = righInfo
        super.init(frame: frame)
        self.setViews()
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationName), object: nil)

    }
    
    private func setViews(){
        
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.black
        
        self.addSubview(title)
        _ = title.sd_layout().topSpaceToView(self,10)?.centerYEqualToView(self)?.widthIs(120)?.heightIs(25)
        
        line.backgroundColor = UIColor.lightGray
        
        self.addSubview(line)
        _ = line.sd_layout().topSpaceToView(title,5)?.widthIs(self.frame.width)?.heightIs(1)
        
        lefttable.delegate = self
        lefttable.dataSource = self
        
        righttable.dataSource = self
        righttable.delegate = self
        
        self.addSubview(lefttable)
        self.addSubview(righttable)
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetTable(_:)), name: NSNotification.Name(rawValue: NotificationName), object: nil)
        
        
        _ = lefttable.sd_layout().leftEqualToView(self)?.topSpaceToView(line,0)?.widthIs(ScreenW / 2 )?.heightIs(self.frame.height)
        // MARK  这里如果用rightEqualToView(self) 约束，大小是对的，但是reloadtable 不生效？？ 换成widthIs(ScreenW / 2 ) 有效？
        _ = righttable.sd_layout().leftSpaceToView(lefttable,0)?.topSpaceToView(line,0)?.widthIs(ScreenW / 2)?.heightIs(self.frame.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

  
    @objc private func resetTable(_ notify:Notification){
        self.righttable.indexPathsForSelectedRows?.forEach({ [unowned self] (index) in
            let cell = self.righttable.cellForRow(at: index)
            cell?.textLabel?.isHighlighted = false
        })
        self.lefttable.indexPathsForSelectedRows?.forEach({ [unowned self] (index) in
            let cell = self.lefttable.cellForRow(at: index)
            cell?.textLabel?.isHighlighted = false
        })
    }
        
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if tableView  == lefttable{
            cell.textLabel?.text  = leftcity[indexPath.row]
        }else{
            cell.textLabel?.text  = rightcity[choosed]?[indexPath.row]
        }
        
        cell.textLabel?.textColor  = UIColor.black
        cell.textLabel?.highlightedTextColor  = UIColor.blue
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == lefttable{
            return leftcity.count
        }

        return rightcity[choosed]?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.isHighlighted = true
        
        if tableView  == lefttable{
            choosed  =  leftcity[indexPath.row]
            if choosed == "不限"{
                self.call?(title.text!,choosed)
                return
            }
         
          self.righttable.reloadData()
            
        }else{
            self.call?(title.text!,(rightcity[choosed]?[indexPath.row])!)
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.isHighlighted  = false
        
        
    }
    
}


// 职位类别

private class Jobclassificatin:UIView{
    
    
    
    var call:((String,String)->Void)?

    fileprivate  lazy var title:UILabel = {
        let title = UILabel.init()
        title.font = UIFont.systemFont(ofSize: 12)
        title.textColor = UIColor.black
        return title
    }()
    
   private var line = UIView()
    
    fileprivate lazy var confirm:UIButton = {
        let confirm = UIButton.init()
        confirm.setTitle("确定", for: .normal)
        confirm.addTarget(self, action: #selector(click), for: .touchUpInside)
        confirm.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        confirm.setTitleColor(UIColor.blue, for: .normal)
        return confirm
    }()
    
    
    
    
    lazy var table1:UITableView = { [unowned self] in
        var table = UITableView()
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.backgroundColor = UIColor.lightGray
        table.delegate = self
        table.dataSource = self
        table.register(selectCell.self, forCellReuseIdentifier: selectCell.identity())
        return table
    }()
    
    lazy var table2:UITableView = {  [unowned self] in
        
        var table = UITableView()
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.register(selectCell.self, forCellReuseIdentifier: selectCell.identity())
        
        return table
        
    }()
    
    lazy var table3:UITableView = { [unowned self] in
        
        var table = UITableView()
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.backgroundColor = UIColor.lightGray
        table.delegate = self
        table.dataSource = self
        table.register(selectCell.self, forCellReuseIdentifier: selectCell.identity())
        return table
        
    }()
    
    lazy var scroller:UIScrollView = { [unowned self] in
        var scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.backgroundColor = UIColor.white
        scroll.bounces = false
        scroll.delegate = self
        scroll.contentSize = CGSize.init(width: ScreenW + ScreenW / 2 , height: self.frame.height - 36)
        return scroll
    }()
    
    fileprivate lazy var warnLabel:UILabel = {
        let label = UILabel()
        label.text  = "最多选择5个"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        return label
    }()
    
    fileprivate lazy var AlertShow:UIView = {
        let show = UIView()
        show.backgroundColor = UIColor.lightGray
        show.alpha =  0.6
        show.isHidden  = true
        return show
    }()
    
    // 最多5个选择
    var count = 0
    //最后一层
    var result:[String] = []
    //中间层
    var middle:[String] = []
    //第一层
    var first:[String] = []
    
    private var t1:[String] = []
    private var t2:Dictionary<String,[String]> = ["":[]]
    private var t3:Dictionary<String,[String]> = ["":[]]
    var choose1 = ""
    var chooos2 = ""
    var timer:Timer?
    var leftTime:Int = 5
    
    
    init(frame: CGRect, level1:[String], level2:Dictionary<String,[String]>, level3:Dictionary<String,[String]>) {
        super.init(frame: frame)
        self.t1 = level1
        self.t2 = level2
        self.t3 = level3
        self.setViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationName), object: nil)

    }
    
    @objc private func resetTable(_ notify:Notification){
        self.table1.indexPathsForSelectedRows?.forEach({ [unowned self] (index) in
            let cell = self.table1.cellForRow(at: index) as? selectCell
            cell?.label.isHighlighted = false
        })
        self.table2.indexPathsForSelectedRows?.forEach({ [unowned self] (index) in
            let cell = self.table2.cellForRow(at: index) as? selectCell
            cell?.label.isHighlighted = false
        })
        self.table3.indexPathsForSelectedRows?.forEach({ [unowned self] (index) in
            let cell = self.table3.cellForRow(at: index) as? selectCell
            cell?.label.isHighlighted = false
        })
        count = 0
        first.removeAll()
        middle.removeAll()
        result.removeAll()
        self.scroller.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        
        
    }
    
    private func setViews(){
        
        
        line.backgroundColor  = UIColor.lightGray
        self.backgroundColor = UIColor.white
        
        self.addSubview(title)
        self.addSubview(line)
        self.addSubview(confirm)
        self.addSubview(scroller)
        self.addSubview(AlertShow)
        scroller.addSubview(table1)
        scroller.addSubview(table2)
        scroller.addSubview(table3)
        AlertShow.addSubview(warnLabel)
        
        _ = title.sd_layout().topSpaceToView(self,5)?.centerXEqualToView(self)?.widthIs(100)?.heightIs(25)
        _ = confirm.sd_layout().rightSpaceToView(self,5)?.centerYEqualToView(title)?.widthIs(50)?.heightIs(20)
        _ = line.sd_layout().topSpaceToView(title,5)?.widthIs(ScreenW)?.heightIs(1)
        
        
        _ = scroller.sd_layout().leftEqualToView(self)?.topSpaceToView(line,0)?.bottomEqualToView(self)?.rightEqualToView(self)
        
        
        _ = table1.sd_layout().leftEqualToView(scroller)?.topEqualToView(scroller)?.bottomEqualToView(scroller)?.widthIs(ScreenW / 2)
        _ = table2.sd_layout().leftSpaceToView(table1,0)?.topEqualToView(scroller)?.bottomEqualToView(scroller)?.widthIs(ScreenW / 2)
        _ = table3.sd_layout().leftSpaceToView(table2,0)?.topEqualToView(scroller)?.bottomEqualToView(scroller)?.widthIs(ScreenW / 2)
        
        
        _ = AlertShow.sd_layout().topSpaceToView(self,70)?.centerXEqualToView(self)?.widthIs(120)?.heightIs(25)
        _ = warnLabel.sd_layout().centerXEqualToView(AlertShow)?.topSpaceToView(AlertShow,2)?.widthIs(100)?.heightIs(20)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetTable(_:)), name: NSNotification.Name(rawValue: NotificationName), object: nil)
        
    }
    
    @objc func tickDown(){
        
        
        if leftTime<=0{
            self.AlertShow.isHidden = true
            self.timer?.invalidate()
            self.timer = nil
            return
        }
        // MARK 界面禁止识别触发事件？
        self.AlertShow.isHidden = false
        leftTime -= 1
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // 返回数据 用 + 连接的
    @objc private func click(){
        
        if result.isEmpty{
            self.call?(title.text!,"不限")
            return
        }
        var str = ""
        let count = result.count - 1
        for (index,item) in result.enumerated(){
           str += item
            if index != count{
                str += "+"
            }
        }
        self.call?(title.text!,str)
    }
    
    
    
    
}

extension Jobclassificatin: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView  == table1{
            return t1.count
        }else if tableView == table2{
            return t2[choose1]?.count ?? 0
        }else{
            return t3[chooos2]?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: selectCell.identity(), for: indexPath) as! selectCell
        if tableView  == table1{
            let str = t1[indexPath.row]
            if first.contains(str){
                cell.label.isHighlighted = true
            }
            cell.label.text  = t1[indexPath.row]
            
        }else if tableView == table2{
            if let str = t2[choose1]?[indexPath.row]{
                if middle.contains(str){
                    cell.label.isHighlighted = true
                }
            }
            cell.label.text = t2[choose1]?[indexPath.row]
            
        }else{
            if let str = t3[chooos2]?[indexPath.row]{
                if result.contains(str){
                    cell.label.isHighlighted = true
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }
            cell.label.text  = t3[chooos2]?[indexPath.row]
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! selectCell
        if tableView == table1{
            if first.contains(cell.label.text!){
                cell.label.isHighlighted = true
            }else{
                cell.label.isHighlighted = false
            }
        }else if tableView == table2{
            if middle.contains(cell.label.text!){
                cell.label.isHighlighted = true
            }else{
                cell.label.isHighlighted = false
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath) as! selectCell
        
        if tableView == table1{
            cell.label.isHighlighted = true
            
            choose1  = (cell.label.text)!
            chooos2 = ""
            table2.reloadData()
            table3.reloadData()
            
        }else if tableView == table2{
            cell.label.isHighlighted = true
            
            chooos2 = (cell.label.text)!
            table3.reloadData()
            scroller.setContentOffset(CGPoint(x:ScreenW / 2,y:0), animated: true)
        }else{
            self.setResult(cell: cell)
        }
            
    }
}

extension Jobclassificatin{
    
    private func setResult(cell: selectCell){
        //再次点击取消选择
        if result.contains(cell.label.text!){
            var tmp:String = ""
            cell.isSelected = false
            cell.label.isHighlighted = false
            cell.accessoryType = .none
            
            count -= 1
            result.remove(at: result.index(of: cell.label.text!)!)
            
            // 取消父值 关联算法？
            loop1: for (k,v) in t3{
                
                for item in v{
                    if cell.label.text! == item{
                        middle.remove(at: middle.index(of: k)!)
                        tmp = k
                        break loop1
                    }
                }
            }
            
            // 第一层
            loop2: for (k,v) in t2{
                for item in v{
                    if tmp == item{
                        first.remove(at: first.index(of: k)!)
                        break loop2
                    }
                }
            }
            
            return
        }else{
            guard count < 5 else{
                if self.timer == nil{
                    leftTime = 5
                    self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
                }
                return
                
            }
            
            
            var tmp:String = ""
            cell.label.isHighlighted = true
            cell.isSelected = true
            cell.accessoryType = .checkmark
            count += 1
            result.append(cell.label.text!)
            
            loop1: for (k,v) in t3{
                for item in v{
                    if cell.label.text! == item{
                        middle.append(k)
                        tmp = k
                        break loop1
                    }
                }
            }
            // 第一层
            loop2: for (k,v) in t2{
                for item in v{
                    if tmp == item{
                        first.append(k)
                        break loop2
                    }
                }
            }
            
        }
        
    }
        
        
}


private class selectCell:UITableViewCell{
    
   
    lazy var label:UILabel = {
        let label = UILabel.init()
        label.isHighlighted = false
        label.textColor = UIColor.black
        label.highlightedTextColor = UIColor.blue
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isSelected = false
        self.contentView.addSubview(label)
        self.selectionStyle = .none
        _ = label.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.widthIs(120)?.heightIs(20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "cell"
    }
    
    class func cellHeith()->CGFloat{
        return 45.0
    }
}
