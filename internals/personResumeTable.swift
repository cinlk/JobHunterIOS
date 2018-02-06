//
//  personResumeTable.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let sections = ["个人信息","教育经历","实习/项目经历","我的技能","自我评价"]


class personResumeTable: UITableViewController {
    
    
    // MART test data
    private var myinfo:person_base_info = person_base_info.init(name: "lk", sex: "男", city: "北京", degree: "硕士", birthday: "1988-10", phone: "13718754627", email: "kdwad@163.com")
    
    private var education_infos:[person_education] = [person_education.init(startTime: "2017-10", endTime: "2018-02", colleage: "北大", degree: "本科", department: "土木工程", city: "北京"),person_education.init(startTime: "2017-10", endTime: "2018-02", colleage: "北大", degree: "本科", department: "土木工程", city: "北京")]
    
    private var project_infos:[person_projectInfo] = [person_projectInfo.init(company: "天下", role: "总监", startTime: "2017-11", endTime: "2018-02", content: "达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个 \n 打我的娃打我的\n 达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个 \n 等我大大", city: "北京"),person_projectInfo.init(company: "天下", role: "总监", startTime: "2017-11", endTime: "2018-02", content: "达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个 \n 打我的娃打我的\n 达瓦大大哇吊袜带挖打我分分个人个人个人个人个人各个打我打我的挖的我吊袜带挖打我多哇大无多无吊袜带挖 \n 等我大大达瓦大", city: "北京")]
    
    private var skill_infos:[person_skills] = [person_skills.init(type: person_skills.skillType.professional, describe: "python"),person_skills.init(type: person_skills.skillType.professional, describe: "java 达瓦大哇多无 吊袜带挖达瓦大文的哇多无吊袜带挖多哇多吊袜带挖多哇多哇多哇多达瓦大多哇多哇多 \n 打我打我的"),
            person_skills.init(type: person_skills.skillType.language, describe: "英语6级 java 达瓦大哇多无 吊袜带挖达瓦大文的哇多无吊袜带挖多哇多吊袜带挖多哇多哇多哇\n 多达瓦大多哇多哇多 \n 达瓦大------43534dwad-  -dwadwadwddw")]
    
    private var evaluate:String = "   "
    private var cacahCell:person_educationCell = person_educationCell(style: .default, reuseIdentifier: "test1")
    private var projectCell:person_projectCell = person_projectCell(style: .default, reuseIdentifier: "test2")
    private var skillCell:person_skillCell = person_skillCell(style: .default, reuseIdentifier: "test3")
    private var evaluateCell:person_evaluateCell = person_evaluateCell(style: .default, reuseIdentifier: "test4")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //self.tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 1))
        self.tableView.backgroundColor = UIColor.lightGray
        self.tableView.tableFooterView  = UIView.init()
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorStyle = .singleLine
        self.tableView.register(resume_personInfoCell.self, forCellReuseIdentifier: resume_personInfoCell.identity())
        self.tableView.register(person_educationCell.self, forCellReuseIdentifier: person_educationCell.identity())
        self.tableView.register(person_projectCell.self, forCellReuseIdentifier: person_projectCell.identity())
        self.tableView.register(person_skillCell.self, forCellReuseIdentifier: person_skillCell.identity())
        self.tableView.register(person_evaluateCell.self, forCellReuseIdentifier: person_evaluateCell.identity())
        
        //navigationItem
        addNavigationItem()
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "我的简历"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: resume_personInfoCell.identity()) as!
                resume_personInfoCell
            
            cell.mode = myinfo
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_educationCell.identity(), for: indexPath) as!
                person_educationCell
            cell.setContentItemView(datas: education_infos)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_projectCell.identity(), for: indexPath) as! person_projectCell
            cell.setContentV(datas: project_infos)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_skillCell.identity(), for: indexPath) as!
                person_skillCell
            cell.setContentV(items: skill_infos)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as!
                person_evaluateCell
            cell.setContentV(content: &evaluate)
            return cell
        default:
            return UITableViewCell.init()
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return resume_personInfoCell.cellHeight()
        case 1:
            
            return cacahCell.caculateCellHeight(datas: education_infos)
        case 2:
            return projectCell.caculateCellHeight(datas: project_infos)
        case 3:
            return skillCell.caculateCellHeight(items: skill_infos)
        case 4:
            return evaluateCell.caculateCellHeight(content: &evaluate)
        default:
            return 45
        }
        
    }
    
   

    // section
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let v = UIView.init()
            v.backgroundColor = UIColor.lightGray
            return v
    }

    



}


extension personResumeTable{
    private func addNavigationItem(){
         let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 25))
         button.setTitle("预览简历", for: .normal)
         button.setTitleColor(UIColor.black, for: .normal)
         button.setBackgroundImage(UIImage.init(), for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
         button.addTarget(self, action: #selector(showResume), for: .touchUpInside)
         self.navigationItem.rightBarButtonItem =  UIBarButtonItem.init(customView: button)
    }
    
    @objc private func showResume(){
        let myresume = myResumeViewController()
        self.navigationController?.pushViewController(myresume, animated: true)
    }
    
}
