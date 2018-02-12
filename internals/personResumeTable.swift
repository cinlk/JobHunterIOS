//
//  personResumeTable.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


enum resumeViewType:String {
    
    case baseInfo = "个人信息"
    case education = "教育经历"
    case project = "实习/项目经历"
    case skill = "技能/爱好"
    case evaluate = "个人评价"
}


class personResumeTable: UITableViewController {
    
    
    private var pManager:personModelManager = personModelManager.shared
    
  
    
    private var jsonData:[String:Any]?
    
    private var viewType:[resumeViewType] = [.baseInfo,.education,.project,.skill,.evaluate]
    

    
    private var cacahCell:person_educationCell?
    private var projectCell:person_projectCell?
    private var skillCell:person_skillCell?
    private var evaluateCell:person_evaluateCell?
    
    
    // 跳转的界面
    
    private var listItem:listItemsView = listItemsView()
    private var person_infoView:modify_personInfoTBC = modify_personInfoTBC()
    private var estimateVC:evaluateSelfVC = evaluateSelfVC()
    
    
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
        // 设置数据  如果扩展dictionary 加入下标获取值??
        //jsonData = ["个人信息":myinfo,"教育经历":education_infos,"实习/项目经历":project_infos,"我的技能":skill_infos,"自我评价":evaluate]
        listItem.delegate = self
        person_infoView.delegate = self
        estimateVC.delegate = self
        pManager.initialData()
        //navigationItem
        addBarItem()
        
        
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
        return  viewType.count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewType[indexPath.section] {
        case .baseInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: resume_personInfoCell.identity()) as!
                resume_personInfoCell
            cell.mode = pManager.personBaseInfo!
            return cell
        case .education:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_educationCell.identity(), for: indexPath) as!
                person_educationCell
            cell.setContentItemView(datas: pManager.educationInfos)
            cacahCell = cell
            return cell
        case .project:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_projectCell.identity(), for: indexPath) as! person_projectCell
            cell.setContentV(datas: pManager.projectInfo)
            projectCell = cell
            return cell
        case .skill:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_skillCell.identity(), for: indexPath) as!
                person_skillCell
            cell.setContentV(items: pManager.skillInfos)
            skillCell = cell
            return cell
        case .evaluate:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as!
                person_evaluateCell
            cell.setContentV(content: &pManager.estimate)
            evaluateCell = cell
            return cell
        
        }
        
        
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch viewType[indexPath.section] {
        case .baseInfo:
            return resume_personInfoCell.cellHeight()
        case .education:
            return cacahCell?.cellHeight ??  0
        case .project:
            return projectCell?.cellHeight ?? 0
        case .skill:
            return skillCell?.cellHeight ?? 0
        case .evaluate:
            return evaluateCell?.cellHeight ?? 0
        }
        
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewType[indexPath.section] {
        case .baseInfo:
    
        
            person_infoView.section = indexPath.section
            self.navigationController?.pushViewController(person_infoView, animated: true)
            
        case .education:
            
            listItem.mode = (type: .education, section: indexPath.section)
            self.navigationController?.pushViewController(listItem, animated: true)
        case .project:
            listItem.mode = (type: .project, section: indexPath.section)
            self.navigationController?.pushViewController(listItem, animated: true)
        case .skill:
            listItem.mode = (type: .skill, section: indexPath.section)
            self.navigationController?.pushViewController(listItem, animated: true)
        case .evaluate:
            estimateVC.section = indexPath.section
            self.navigationController?.pushViewController(estimateVC, animated: true)
            
        
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

// 查看简历
extension personResumeTable{
    
    private func addBarItem(){
         let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 25))
         button.setTitle("预览简历", for: .normal)
         button.setTitleColor(UIColor.black, for: .normal)
         button.setBackgroundImage(UIImage.init(), for: .normal)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
         button.addTarget(self, action: #selector(showResume), for: .touchUpInside)
         self.navigationItem.rightBarButtonItem =  UIBarButtonItem.init(customView: button)
    }
    
    // TODO: 显示pdf 格式的简历，然后提供分享链接！！
    @objc private func showResume(){
        let myresume = myResumeViewController()
        self.navigationController?.pushViewController(myresume, animated: true)
    }
    
}

// 协议实现


extension personResumeTable: personResumeDelegate{
    func refreshResumeInfo(_ section:Int){
        self.tableView.reloadSections([section], animationStyle: .none)
    }


}


extension personResumeTable: modofy_itemDelegate{

    func refreshItem(_ section:Int){
        self.tableView.reloadSections([section], animationStyle: .none)
        
    }
}
