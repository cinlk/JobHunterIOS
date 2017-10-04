//
//  subconditions.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class subconditions: UIViewController {

    var table:UITableView!
    
    var type = ["校招":["工作城市","职位类别","从事行业","薪资范围","学历"],"实习":["实习城市","职位类别","从事行业","实习天数","薪资范围","实习时间","学历"]]
    var name = ["职位类型":"请选择"]
    
    var value = ["工作城市":"(必选)请选择","实习城市":"(必选)请选择","职位类别":"(必选)请选择","从事行业":"请选择","薪资范围":"请选择","实习天数":"请选择","实习时间":"请选择","学历":"请选择"]
    
    //从事行业
    
    // 弹出界面
    var darkView:UIView!
    var lx:leixin!
    var centerlxY:CGFloat = 0
    
    var citys:conditionCity!
    var centerCityY:CGFloat = 0
    
    var industry:conditionCity!
    var centerIndustryY:CGFloat = 0
    
    var salaryrange:leixin!
    var centersalaryY:CGFloat = 0
    
    var shixiday:leixin!
    var centershixidayY:CGFloat = 0
    
    var shiximonth:leixin!
    var centermonthY:CGFloat = 0
    
    var level:leixin!
    var centerlevelY:CGFloat = 0
    
    
    var  jobcategorys:Jobclassificatin!
    var centercY:CGFloat = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name["职位类型"]  = "校招"
        table = UITableView.init(frame: self.view.frame)
        table.tableHeaderView =  UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        table.tableHeaderView?.backgroundColor = UIColor.blue
        table.tableFooterView =  UIView()
        table.register(UINib(nibName:"conditionCell", bundle:nil), forCellReuseIdentifier: "conditions")
        
        
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
        
        _  = cancel.sd_layout().leftSpaceToView(self.table.tableHeaderView,10)?.bottomSpaceToView(self.table.tableHeaderView,5)?.widthIs(20)?.heightIs(20)
        
        
        
        table.delegate = self
        table.dataSource = self
        
        // 影藏页面
        
        darkView = UIView()
        darkView.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
        darkView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
        
        darkView.isUserInteractionEnabled = true // 打开用户交互
        
        let singTap = UITapGestureRecognizer(target: self, action:#selector(hidenView)) // 添加点击事件
        
        singTap.numberOfTouchesRequired = 1
        
        darkView.addGestureRecognizer(singTap)

        
        lx =  leixin()
        lx.call  = self.getleixin
        
        lx.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 100)
        centerlxY = lx.centerY
        
        citys = conditionCity(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300))
        centerCityY = citys.centerY
        citys.call  = getCity
        
        //
        
        industry  = conditionCity(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300))
        centerIndustryY = industry.centerY
        industry.call  = getCity
        
        //
        salaryrange = leixin(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300))
        salaryrange.call  = self.getleixin
        centersalaryY = salaryrange.centerY
        
        
        shixiday = leixin(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300))
        shixiday.call  = self.getleixin
        centershixidayY = shixiday.centerY
        
        
        shiximonth = leixin(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300))
        shiximonth.call  = self.getleixin
        centermonthY = shiximonth.centerY
        
        
        level = leixin(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300))
        level.call  = self.getleixin
        centerlevelY = level.centerY
        
        //TODO
        jobcategorys = Jobclassificatin(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 300))
        jobcategorys.call  = self.getleixin
        centercY = jobcategorys.centerY
        
        
        
        
        self.view.addSubview(table)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension  subconditions:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section  == 0 {
            return 1
        }
        return (type[name["职位类型"]!]?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell =   table.dequeueReusableCell(withIdentifier: "conditions", for: indexPath) as! conditionCell
        if indexPath.section == 0 {
            cell.name.text = "职位类型"
            cell.value.text  = name["职位类型"]
            
        }
        else{
            cell.name.text = type[name["职位类型"]!]?[indexPath.row]
            cell.value.text  = value[(type[name["职位类型"]!]?[indexPath.row])!]
            cell.selectionStyle = .none
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! conditionCell
        switch (cell.name?.text)! {
        case "职位类型":
            lx.item = ["校招","实习"]
            self.showlexin(name:cell.name.text!)
            
        case "工作城市","实习城市":
            self.showcity(name: cell.name.text!)
            
             self.citys.leftcity = ["不限","热门城市","广东","浙江","湖北"]
             self.citys.rightcity = ["不限":[],"热门城市":["北京","上海","广州","深圳"],"广东":["广州","韶关","深圳"],"浙江":["杭州","温州","湖州"],"湖北":["武汉","黄石"]]
        case "从事行业":
            self.industry.leftcity = ["不限","IT/互联网","电子/通信/硬件","金融","汽车/机械/制造"]
            self.industry.rightcity = ["不限":[],"IT/互联网":["互联网/电子商务","网络游戏","计算机软件","IT服务/系统集成"],"电子/通信/硬件":["电子技术/半导体/集成电路","通信","计算机硬件"],"金融":["银行","保险","会计/审计","基金/证券/投资"],"汽车/机械/制造":["汽车/模特","印刷/包装/造纸","加工制造"]]
            self.showindustry(name: cell.name.text!)
        case "薪资范围":
            self.salaryrange.item = ["不限","1000-2000","2000-3000","3000-4000","4000-5000"]
            self.showsalary(name: cell.name.text!)
            
        case "实习天数":
            self.shixiday.item = ["2天/周","3天/周","4天/周","5天/周"]
            self.showshixiday(name: cell.name.text!)
            
        case "实习时间":
            self.shiximonth.item = ["1个月","2个月","3个月","4个月","5个月","半年","半年以上"]
            self.showshiximonth(name: cell.name.text!)
        case "学历":
            self.level.item = ["不限","大专","本科","硕士","博士"]
            self.showlevel(name: cell.name.text!)
        case "职位类别":
            self.jobcategorys.t1 = ["销售/客服","技术","产品/设计/运营","项目管理/质量管理"]
            self.jobcategorys.t2 = ["":[],"销售/客服":["销售业务","销售管理","销售行政","客服"],"技术":["前端开发","后端开发"],"产品/设计/运营":["产品","设计","运营"],"项目管理/质量管理":["项目管理/项目协调","质量管理/安全防护"]]
            self.jobcategorys.t3 = ["":[],"销售业务":["销售代表","客户代表","项目执行","代理销售","保险销售"],"销售管理":["客户经理/主管","大客户销售经理","招商总监","团购经理/主管"]
                ,"销售行政":["销售行政专员/助理","商务专员/助理","业务分析师/主管"],"客服":["VIP专员","网络客服","客服总监"],"前端开发":["web开发","JavaScript","HTML5","Flash"],
                 "后端开发":["Java","Python","PHP",".NET","C#","C/C++","Golang"],"项目管理/项目协调":["项目专员"],"质量管理/安全防护":["质量检测员"],"产品":["产品助理","网页产品"],"设计":["网页设计","UI设计","美术设计"],"运营":["数据运营","产品运营"]]
            self.showjobclasses(name: cell.name.text!)
            
        default:
            break
        }
        
        
    }
    
}

extension subconditions{
    func showlexin(name:String){
        self.view.addSubview(darkView)
        self.view.addSubview(lx)
        lx.title.text = name
        UIView.animate(withDuration: 0.5, animations: {
                    self.lx.frame  = CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 200)
        }, completion: nil)
    }
    // 回调方法
    func getleixin(type:String,val:String){
         if type  == "职位类型"{
            name[type] = val
            self.value = ["工作城市":"(必选)请选择","实习城市":"(必选)请选择","职位类别":"(必选)请选择","从事行业":"请选择","薪资范围":"请选择","实习天数":"请选择","实习时间":"请选择","学历":"请选择"]
            
        }
        else{
            value[type] = val
        }
        self.hidenView()
        //重置选择数据

        self.table.reloadData()
    }
    
    func showcity(name:String){
        self.view.addSubview(darkView)
        self.view.addSubview(citys)
        citys.title.text  = name
        UIView.animate(withDuration: 0.5, animations: {
            self.citys.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)

        }, completion: nil)
        
    }
    func getCity(type:String,locate:String){
        value[type] =  locate
        self.hidenView()
        self.table.reloadData()
        
        
    }
    
    func showindustry(name:String){
        self.view.addSubview(darkView)
        self.view.addSubview(self.industry)
        industry.title.text = name
        UIView.animate(withDuration: 0.5, animations: {
            self.industry.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
            
        }, completion: nil)
        
    }
    
    func showsalary(name:String){
        self.view.addSubview(darkView)
        self.view.addSubview(self.salaryrange)
        salaryrange.title.text = name
        UIView.animate(withDuration: 0.5, animations: {
            self.salaryrange.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
            
        }, completion: nil)

    }
    
    func showshixiday(name:String){
        self.view.addSubview(darkView)
        self.view.addSubview(self.shixiday)
        shixiday.title.text = name
        UIView.animate(withDuration: 0.5, animations: {
            self.shixiday.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
            
        }, completion: nil)
        
    }
    
    func showshiximonth(name:String){
        self.view.addSubview(darkView)
        self.view.addSubview(self.shiximonth)
        shiximonth.title.text = name
        UIView.animate(withDuration: 0.5, animations: {
            self.shiximonth.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
            
        }, completion: nil)
        
    }
    
    
    
    func showlevel(name:String){
        self.view.addSubview(darkView)
        self.view.addSubview(self.level)
        level.title.text = name
        UIView.animate(withDuration: 0.5, animations: {
            self.level.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
            
        }, completion: nil)
        
    }

    
    func showjobclasses(name:String){
        self.view.addSubview(darkView)
        self.view.addSubview(self.jobcategorys)
        jobcategorys.title.text = name
        UIView.animate(withDuration: 0.5, animations: {
            self.jobcategorys.frame = CGRect(x: 0, y: self.view.frame.height-300, width: self.view.frame.width, height: 300)
            
        }, completion: nil)
        
    }


   
    
    
    
}
extension subconditions{
    func storage(sender:UIButton){
        if self.name["职位类型"] == "校招"{
            if self.value["工作城市"] == "(必选)请选择"{
                let alert = UIAlertController.init(title: "请选择城市", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
                
            }else if self.value["职位类别"] == "(必选)请选择"{
            
                let alert = UIAlertController.init(title: "请选择职位类别", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
            }
            // return
            else{
                self.dismiss(animated: true, completion: nil)
            }
        }
        else{
            
            if self.value["实习城市"] == "(必选)请选择"{
                let alert = UIAlertController.init(title: "请选择城市", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }

                
            }else if self.value["职位类别"] == "(必选)请选择"{
            
                let alert = UIAlertController.init(title: "请选择职位类别", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
            }else{
                self.dismiss(animated: true, completion: nil)

            }
            
        }
    }
    
    func closed(sender:UIImage){
        self.dismiss(animated: true, completion: nil)
    }
    func hidenView(){
        darkView.removeFromSuperview()
        self.lx.removeFromSuperview()
        self.citys.removeFromSuperview()
        self.industry.removeFromSuperview()
        self.salaryrange.removeFromSuperview()
        self.shixiday.removeFromSuperview()
        self.shiximonth.removeFromSuperview()
        self.level.removeFromSuperview()
        self.jobcategorys.removeFromSuperview()
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.lx?.centerY =  self.centerlxY
            self.citys.centerY  = self.centerCityY
            self.industry.centerY = self.centerIndustryY
            self.salaryrange.centerY  = self.centersalaryY
            self.shixiday.centerY = self.centershixidayY
            self.shiximonth.centerY = self.centermonthY
            self.level.centerY = self.centerlevelY
            self.jobcategorys.centerY = self.centercY
            
        }, completion: nil)

    }
}


//
class leixin:UIView,UITableViewDelegate,UITableViewDataSource{
    
    
    // 回调传值
    var call:((String,String)->Void)?
    
    
    var table:UITableView = UITableView()
    var title = UILabel()
    var item:[String] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.text = "职位类型"
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        let line = UIView()
        line.backgroundColor  = UIColor.lightGray
        self.backgroundColor  = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        
        self.addSubview(title)
        self.addSubview(line)
        self.addSubview(table)
        
        _ = title.sd_layout().topSpaceToView(self,5)?.centerXEqualToView(self)?.widthIs(120)?.heightIs(25)
        _ = line.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topSpaceToView(self,35)?.heightIs(1)
        _ = table.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.topSpaceToView(line,0)
        
        
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = item[indexPath.row]
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font  = UIFont.systemFont(ofSize: 12)
        cell.selectionStyle = .none
        cell.textLabel?.highlightedTextColor = UIColor.blue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.isHighlighted = true
        if self.call != nil{
            self.call!(title.text!,(cell?.textLabel?.text)!)
        }
        
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.isHighlighted = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  40
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//  工作城市 和 从事行业

class conditionCity:UIView,UITableViewDelegate,UITableViewDataSource{
    
    
    lazy var lefttable:UITableView = {
        var table = UITableView()
        table.backgroundColor = UIColor.gray
        table.tableFooterView = UIView()
        table.isMultipleTouchEnabled  = false
        
        return table
    }()
    
    lazy var righttable:UITableView = {
       var table = UITableView()
        table.backgroundColor = UIColor.white
        table.tableFooterView = UIView()
        table.isMultipleTouchEnabled  = false

        return table
        
        
    }()
    var title:UILabel = UILabel()
    var line:UIView = UIView()
    
    // 
    var call:((String,String)->Void)?
    
   
    var leftcity:[String] = []
    var rightcity:Dictionary<String,[String]> = [:]
    
    var choosed:String = "不限"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
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
        
        _ = lefttable.sd_layout().leftEqualToView(self)?.topSpaceToView(line,0)?.widthIs(160)?.heightIs(self.frame.height)
        
        _ = righttable.sd_layout().leftSpaceToView(lefttable,0)?.topSpaceToView(line,0)?.widthIs(160)?.heightIs(self.frame.height)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell.init(style: .default, reuseIdentifier: "demo")
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
        if rightcity[choosed] != nil{
           return rightcity[choosed]!.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.isHighlighted = true
        
        if tableView  == lefttable{
            choosed  =  leftcity[indexPath.row]
            if choosed == "不限"{
                self.call!(title.text!,choosed)
                return
            }
            righttable.reloadData()
        }else{
            self.call!(title.text!,(rightcity[choosed]?[indexPath.row])!)
            
            print("choose city \(rightcity[choosed]?[indexPath.row])")
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.isHighlighted  = false
    }
    
}


// 职位类别

class Jobclassificatin:UIView,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    
    
    //
    var call:((String,String)->Void)?
    
    //
   
    
    var t1:[String] = []
    var t2:Dictionary<String,Array<String>> = ["":[]]
    var t3:Dictionary<String,Array<String>> = ["":[]]
    
    var title = UILabel()
    var line = UIView()
    var confirm = UIButton()
    
    
    lazy var table1:UITableView = {
        var table = UITableView()
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.backgroundColor = UIColor.lightGray
        table.register(selectCell.self, forCellReuseIdentifier: "select")

        return table
        
    }()
    
    lazy var table2:UITableView = {
        
        var table = UITableView()
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.backgroundColor = UIColor.white
        table.register(selectCell.self, forCellReuseIdentifier: "select")
        
        return table
        
    }()
    
    lazy var table3:UITableView = {
        
        
        var table = UITableView()
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.backgroundColor = UIColor.lightGray
        table.register(selectCell.self, forCellReuseIdentifier: "select")

        
        
        return table
        
    }()
    
    
    lazy var scroller:UIScrollView = {
        var scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isPagingEnabled = true
        scroll.bounces = false
        return scroll
        
    }()
    
    
    
    // 最多5个选择
    var count = 0
    //最后一层
    var result:[String] = []
    //中间层
    var middle:[String] = []
    //第一层
    var first:[String] = []
    
    
    var choose1 = ""
    var chooos2 = ""
    var show:UIView!
    var timer:Timer?
    
    var leftTime:Int = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 12)
        title.textColor = UIColor.black
        line.backgroundColor  = UIColor.lightGray
        confirm.setTitle("确定", for: .normal)
        confirm.addTarget(self, action: #selector(click), for: .touchUpInside)
        confirm.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        confirm.setTitleColor(UIColor.blue, for: .normal)
        
        self.addSubview(title)
        self.addSubview(line)
        self.addSubview(confirm)
        
        _ = title.sd_layout().topSpaceToView(self,5)?.centerXEqualToView(self)?.widthIs(100)?.heightIs(25)
        _ = confirm.sd_layout().rightSpaceToView(self,5)?.topSpaceToView(self,5)?.widthIs(50)?.heightIs(20)
        
        _ = line.sd_layout().topSpaceToView(title,5)?.widthIs(self.frame.width)?.heightIs(1)
        
        table1.delegate = self
        table1.dataSource = self
        
        table2.delegate = self
        table2.dataSource = self
        
        table3.delegate = self
        table3.dataSource = self
        
        
        
        scroller.delegate = self
        
        
        self.addSubview(scroller)

        _ = scroller.sd_layout().leftEqualToView(self)?.topSpaceToView(line,0)?.bottomEqualToView(self)?.widthIs(self.frame.width)
        
        scroller.contentSize = CGSize(width: 480, height:  self.frame.height-36)

        
        scroller.addSubview(table1)
        scroller.addSubview(table2)
        scroller.addSubview(table3)
        
        _ = table1.sd_layout().leftEqualToView(scroller)?.topEqualToView(scroller)?.bottomEqualToView(scroller)?.widthIs(160)
        _ = table2.sd_layout().leftSpaceToView(table1,0)?.topEqualToView(scroller)?.bottomEqualToView(scroller)?.widthIs(160)
        _ = table3.sd_layout().leftSpaceToView(table2,0)?.topEqualToView(scroller)?.bottomEqualToView(scroller)?.widthIs(160)

        
        
        //
        
        show = UIView()
        var label = UILabel()
        show.backgroundColor = UIColor.white
        label.text  = "最多选择5个"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        show.backgroundColor = UIColor.lightGray
        show.alpha =  0.6
        
        
        self.addSubview(show)
        _ = show.sd_layout().topSpaceToView(self,70)?.leftSpaceToView(self,100)?.widthIs(120)?.heightIs(25)
        show.isHidden  = true
        
        show.addSubview(label)
        _ = label.sd_layout().centerXEqualToView(show)?.topSpaceToView(show,2)?.widthIs(100)?.heightIs(20)

        
        
        
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView  == table1{
            return t1.count
        }else if tableView == table2{
            return t2[choose1]!.count
        }else{
            return t3[chooos2]!.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "select", for: indexPath) as! selectCell
        cell.selectionStyle = .none
        
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var cell = tableView.cellForRow(at: indexPath) as! selectCell
        
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
            scroller.setContentOffset(CGPoint(x:160,y:0), animated: true)
        }else{
            
            //再次点击取消选择
            if result.contains(cell.label.text!){
                var tmp:String = ""
                    cell.sel = false
                    cell.label.isHighlighted = false
                    cell.accessoryType = .none

                    count -= 1
                    result.remove(at: result.index(of: cell.label.text!)!)
                
                    //
                
                    for (k,v) in t3{
                        for item in v{
                            if cell.label.text! == item{
                                middle.remove(at: middle.index(of: k)!)
                                tmp = k
                            }
                        }
                    }
                
                // 第一层
                for (k,v) in t2{
                    for item in v{
                        if tmp == item{
                            first.remove(at: first.index(of: k)!)
                        }
                    }
                }


                    return
            }else{
                if count < 5{
                    
                    var tmp:String = ""
                    cell.label.isHighlighted = true
                    cell.sel = true
                    cell.accessoryType = .checkmark
                    count += 1
                    result.append(cell.label.text!)
                    for (k,v) in t3{
                        for item in v{
                            print(item,cell.label.text!)
                            if cell.label.text! == item{
                                middle.append(k)
                                tmp = k
                            }
                        }
                    }
                    // 第一层
                    for (k,v) in t2{
                        for item in v{
                            if tmp == item{
                                first.append(k)
                            }
                        }
                    }
                    
                }else{
                    
                    if self.timer == nil{
                        print("initil timer")
                        leftTime = 5
                        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
                    }
                    
                }
            }
           
                
                
        }
    }

    
    func tickDown(){
        print("start ")
        if leftTime<=0{
            self.show.isHidden = true
            self.timer?.invalidate()
            self.timer = nil
            return
        }
        self.show.isHidden = false
        leftTime -= 1
        
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
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func click(){
        
        if result.isEmpty{
            self.call!(title.text!,"职位类别不限")
            return
        }
        var str = ""
        var count = result.count - 1
        for (index,item) in result.enumerated(){
           str += item
            if index != count{
                str += "+"
            }
        }
        self.call!(title.text!,str)
    }
    
    
    
    
}

class selectCell:UITableViewCell{
    
    var sel:Bool = false
    
    var label = UILabel()
    
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sel  = false
        label.isHighlighted = false
        label.textColor = UIColor.black
        label.highlightedTextColor = UIColor.blue
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        self.contentView.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.widthIs(120)?.heightIs(20)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
