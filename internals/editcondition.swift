//
//  subconditions.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import QuartzCore


class editcondition: UIViewController {
    
    var table:UITableView!
    
    var type = ["校招":["工作城市","职位类别","从事行业","薪资范围","学历"],"实习":["实习城市","职位类别","从事行业","实习天数","实习薪水","实习时间","学历"]]
    var name = ["职位类型":"请选择"]
    
    //var value = ["工作城市":"(必选)请选择","实习城市":"(必选)请选择","职位类别":"(必选)请选择","从事行业":"请选择","薪资范围":"请选择","实习天数":"请选择","实习时间":"请选择","学历":"请选择","实习薪水":"请选择"]
    
    var editdata:Dictionary<String,String>?
    var row  = 0
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
    
    //storage
    var data  =  localData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //name["职位类型"]  = "校招"
        
        table = UITableView.init(frame: self.view.frame)
        table.tableFooterView =  UIView()
        table.register(UINib(nibName:"conditionCell", bundle:nil), forCellReuseIdentifier: "conditions")
        
        //
        self.navigationItem.title = "修改职位订阅条件"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(storage))
        
        
        
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

extension  editcondition:UITableViewDelegate,UITableViewDataSource{
    
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
            // TODO
            
        }
        else{
            cell.name.text = type[name["职位类型"]!]?[indexPath.row]
            
            cell.value.text  = editdata?[cell.name.text!]
            
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
            return
            
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
            
        case "实习薪水":
            self.salaryrange.item = ["不限","80/天","100/天","150/天","200/天","250/天"]
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

extension editcondition{
    
    // 回调方法
    func getleixin(type:String,val:String){
      
        editdata?[type] = val
        
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
        editdata?[type] =  locate
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
extension editcondition{
    @objc func storage(sender:UIButton){
        if self.name["职位类型"] == "校招"{
            
                self.data.updateshezhaoCondition(value: editdata!, index: row)
                self.closed()
        }
        else{
                self.data.updateShixiCondition(value: editdata!, index: row)
                self.closed()
            
        }
    }
    
    func closed(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func hidenView(){
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
