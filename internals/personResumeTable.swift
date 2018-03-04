//
//  personResumeTable.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let VCtitle:String = "我的简历"

enum resumeViewType:String {
    
    case baseInfo = "个人信息"
    case education = "教育经历"
    case project = "实习/项目经历"
    case skill = "技能/爱好"
    case evaluate = "个人评价"
}


class personResumeTable: UITableViewController {
    
    
    // 进入页面时 要刷新数据
    private var pManager:personModelManager = personModelManager.shared
    private var viewType:[resumeViewType] = [.baseInfo,.education,.project,.skill,.evaluate]
    // 跳转的界面
    private lazy var listItem:listItemsView = listItemsView()
    private lazy var person_infoView:modify_personInfoVC = modify_personInfoVC()
    private lazy var estimateVC:evaluateSelfVC = evaluateSelfVC()
    
    
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
     
        listItem.delegate = self
        person_infoView.delegate = self
        estimateVC.delegate = self
        pManager.initialData()
        //navigationItem
        addBarItem()
        // loadData
        loadData()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = VCtitle
        
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
            // 不需要cell frame缓存，内容大小会改变
            //cell.useCellFrameCache(with: indexPath, tableView: tableView)
            return cell
            
        case .education:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_educationCell.identity(), for: indexPath) as!
                person_educationCell
            cell.mode = pManager.educationInfos
            //cell.useCellFrameCache(with: indexPath, tableView: tableView)
            return cell
        case .project:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_projectCell.identity(), for: indexPath) as! person_projectCell
            cell.mode = pManager.projectInfo
            //cell.useCellFrameCache(with: indexPath, tableView: tableView)
            return cell
        case .skill:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_skillCell.identity(), for: indexPath) as!
                person_skillCell
            cell.mode = pManager.skillInfos
            //cell.useCellFrameCache(with: indexPath, tableView: tableView)
            return cell
            
        case .evaluate:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as!
                person_evaluateCell
            cell.mode = pManager.estimate
            //cell.useCellFrameCache(with: indexPath, tableView: tableView)
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch viewType[indexPath.section] {
        case .baseInfo:
            if let info = pManager.personBaseInfo{
                
                 return tableView.cellHeight(for: indexPath, model: info, keyPath: "mode", cellClass: resume_personInfoCell.self, contentViewWidth: ScreenW)
            }
            return 0
           
        case .education:
            
            
            return tableView.cellHeight(for: indexPath, model: pManager.educationInfos, keyPath: "mode", cellClass: person_educationCell.self, contentViewWidth: ScreenW)
           
            
        case .project:
         
            return tableView.cellHeight(for: indexPath, model: pManager.projectInfo, keyPath: "mode", cellClass: person_projectCell.self, contentViewWidth: ScreenW)
           
        case .skill:
            
            return tableView.cellHeight(for: indexPath, model: pManager.skillInfos, keyPath: "mode", cellClass: person_skillCell.self, contentViewWidth: ScreenW)
            
        case .evaluate:
            return   tableView.cellHeight(for: indexPath, model: pManager.estimate, keyPath: "mode", cellClass: person_evaluateCell.self, contentViewWidth: ScreenW)
        }
        
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = viewType[indexPath.section]
        switch type {
        case .baseInfo:
    
            person_infoView.section = indexPath.section
            self.navigationController?.pushViewController(person_infoView, animated: true)
            
        case .education,.project, .skill:
            
            listItem.mode = (type: type, section: indexPath.section)
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
//        let myresume = myResumeViewController()
//        self.navigationController?.pushViewController(myresume, animated: true)
    }
    
}

// 协议实现


extension personResumeTable: personResumeDelegate{
    func refreshResumeInfo(_ section:Int){
        //self.tableView.reloadSections([section], animationStyle: .none)
         //只有reload 方法 才能从新布局
        self.tableView.reloadData()
    }
}

extension personResumeTable: modofy_itemDelegate{

    func refreshItem(_ section:Int){
        
         //只有reload 方法 才能从新布局
         self.tableView.reloadData()
         self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: section), at: .top, animated: false)
    }
}


extension personResumeTable{
    
    private func loadData(){
        pManager.initialData()
    }
}
