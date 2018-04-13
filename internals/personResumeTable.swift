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
    case intern = "实习经历"
    case skill = "技能/爱好"
    case evaluate = "个人评价"
}


class personResumeTable: BaseTableViewController {
    
    
    // 进入页面时 要刷新数据
    private var pManager:personModelManager = personModelManager.shared
    private var viewType:[resumeViewType] = [.baseInfo,.education,.intern,.skill,.evaluate]
   
    // 基本信息修改view
    private lazy var person_infoView:modify_personInfoVC = modify_personInfoVC()
    // 自我评价修改view
    private lazy var estimateVC:evaluateSelfVC = evaluateSelfVC()
    
    
    private lazy var barBtn:UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 25))


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        // loadData
        loadData()
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = VCtitle
        self.navigationController?.insertCustomerView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        
        
    }
    
    override func setViews(){
        
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableFooterView  = UIView.init()
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorStyle = .singleLine
        self.tableView.register(resume_personInfoCell.self, forCellReuseIdentifier: resume_personInfoCell.identity())
        self.tableView.register(person_educationCell.self, forCellReuseIdentifier: person_educationCell.identity())
        self.tableView.register(person_projectCell.self, forCellReuseIdentifier: person_projectCell.identity())
        self.tableView.register(person_skillCell.self, forCellReuseIdentifier: person_skillCell.identity())
        self.tableView.register(person_evaluateCell.self, forCellReuseIdentifier: person_evaluateCell.identity())
        // 底部cell
        self.tableView.register(singleButtonCell.self, forCellReuseIdentifier: singleButtonCell.identity())
        
        
        person_infoView.delegate = self
        estimateVC.delegate = self
        //navigationItem
        addBarItem()
        
        self.handleViews.append(barBtn)
        self.handleViews.append(tableView)
        
        super.setViews()
        
    }
    
    override func didFinishloadData(){
        
        super.didFinishloadData()
        self.tableView.reloadData()
    }
    
    
    override func reload(){
        super.reload()
        self.loadData()
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  viewType.count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch viewType[section] {
        case .education:
            // 内容cell 和   标题cell  和 底部添加 cell
            
            return (pManager.mode?.educationInfo.count ?? 0)  + 2
        case .intern:
            return (pManager.mode?.internInfo.count ?? 0)  + 2
        case .skill:
            return (pManager.mode?.skills.count ?? 0) + 2
        default:
            break
        }
        return 1
        
    }
    
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let mode = pManager.mode else { return UITableViewCell() }
        
        
        switch viewType[indexPath.section] {

        case .baseInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: resume_personInfoCell.identity()) as!
                resume_personInfoCell
            
            cell.mode = mode.basicinfo
            return cell
        case .education:
            
            if indexPath.row == 0 {
                let cell = UITableViewCell.init()
                cell.textLabel?.text = "教育经历"
                cell.textLabel?.textAlignment = .left
                cell.isUserInteractionEnabled = false
                return cell
            }
            if  mode.educationInfo.count == 0 && indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: singleButtonCell.identity(), for: indexPath) as! singleButtonCell
                cell.btnType = .add
                cell.btn.setTitle("添加教育经历", for: .normal)
                cell.addMoreItem = {
                    let view = add_educations()
                    view.delegate = self
                    self.navigationController?.pushViewController(view, animated: true)
                }
                return cell
            }else{
                if indexPath.row == mode.educationInfo.count + 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: singleButtonCell.identity(), for: indexPath) as! singleButtonCell
                    cell.btnType = .add
                    cell.btn.setTitle("添加教育经历", for: .normal)
                    cell.addMoreItem = {
                        let view = add_educations()
                        view.delegate = self
                        self.navigationController?.pushViewController(view, animated: true)
                    }
                    return cell
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: person_educationCell.identity(), for: indexPath) as!
                person_educationCell
                cell.mode = mode.educationInfo[indexPath.row - 1]
                
                return cell

            }
            
        case .intern:
            
            if indexPath.row == 0 {
                let cell = UITableViewCell.init()
                cell.textLabel?.text = "实习经历"
                cell.textLabel?.textAlignment = .left
                cell.isUserInteractionEnabled = false
                return cell
            }
            if  mode.internInfo.count == 0 && indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: singleButtonCell.identity(), for: indexPath) as! singleButtonCell
                cell.btnType = .add
                cell.btn.setTitle("实习经历", for: .normal)
                cell.addMoreItem = {
                    let view = add_internVC()
                    view.delegate = self
                    self.navigationController?.pushViewController(view, animated: true)
                }
                return cell
            }else{
                if indexPath.row == mode.internInfo.count + 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: singleButtonCell.identity(), for: indexPath) as! singleButtonCell
                    cell.btnType = .add
                    cell.btn.setTitle("实习经历", for: .normal)
                    cell.addMoreItem = {
                        let view = add_internVC()
                        view.delegate = self
                        self.navigationController?.pushViewController(view, animated: true)
                    }
                    return cell
                }
                
            
                let cell = tableView.dequeueReusableCell(withIdentifier: person_projectCell.identity(), for: indexPath) as! person_projectCell
                cell.mode = mode.internInfo[indexPath.row - 1 ]
                return cell
            }
            
            
        case .skill:
            if indexPath.row == 0 {
                let cell = UITableViewCell.init()
                cell.textLabel?.text = "技能"
                cell.textLabel?.textAlignment = .left
                cell.isUserInteractionEnabled = false
                return cell
            }
            if  mode.skills.count == 0 && indexPath.row == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: singleButtonCell.identity(), for: indexPath) as! singleButtonCell
                cell.btnType = .add
                cell.addMoreItem = {
                    let view = addSkillVC()
                    view.delegate = self
                    self.navigationController?.pushViewController(view, animated: true)
                }
                cell.btn.setTitle("技能", for: .normal)
                return cell
            }else{
                if indexPath.row ==  mode.skills.count + 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: singleButtonCell.identity(), for: indexPath) as! singleButtonCell
                    cell.btnType = .add
                    cell.btn.setTitle("技能", for: .normal)
                    cell.addMoreItem = {
                        let view = addSkillVC()
                        view.delegate = self
                        self.navigationController?.pushViewController(view, animated: true)
                    }
                    return cell
                }
                
        
                let cell = tableView.dequeueReusableCell(withIdentifier: person_skillCell.identity(), for: indexPath) as!
                    person_skillCell
                cell.mode = mode.skills[indexPath.row - 1]
                return cell
            }
            
        case .evaluate:
            let cell = tableView.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as!
                person_evaluateCell
            cell.mode = mode.estimate
            return cell
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let mode = pManager.mode else {
            return 0
        }
        
        switch viewType[indexPath.section] {
        case .baseInfo:
            // 必须有值
            if let info = mode.basicinfo{
                
                 return tableView.cellHeight(for: indexPath, model: info, keyPath: "mode", cellClass: resume_personInfoCell.self, contentViewWidth: ScreenW)
            }
            
            return 0
           
        case .education:
            if indexPath.row == 0 || indexPath.row == mode.educationInfo.count + 1{
                return 45
            }
            
            return tableView.cellHeight(for: indexPath, model: mode.educationInfo[indexPath.row - 1], keyPath: "mode", cellClass: person_educationCell.self, contentViewWidth: ScreenW)
            
            
        case .intern:
            if indexPath.row == 0 || indexPath.row == mode.internInfo.count + 1{
                return 45
            }
            return tableView.cellHeight(for: indexPath, model: mode.internInfo[indexPath.row - 1], keyPath: "mode", cellClass: person_projectCell.self, contentViewWidth: ScreenW)
           
        case .skill:
            if indexPath.row == 0 || indexPath.row == mode.skills.count + 1{
                return 45
            }
            return tableView.cellHeight(for: indexPath, model: mode.skills[indexPath.row - 1], keyPath: "mode", cellClass: person_skillCell.self, contentViewWidth: ScreenW)
            
        case .evaluate:
            
            return   tableView.cellHeight(for: indexPath, model:  mode.estimate, keyPath: "mode", cellClass: person_evaluateCell.self, contentViewWidth: ScreenW)
        }
        
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = viewType[indexPath.section]
        switch type {
            
        case .baseInfo:
    
            person_infoView.section = indexPath.section
            self.navigationController?.pushViewController(person_infoView, animated: true)
            
        case .education,.intern, .skill:
            if indexPath.row != 0 && indexPath.row != pManager.getCountBy(type: type) + 1{
                let modify = modifyitemView()
                modify.delegate = self
                modify.mode = (viewType:type, indexPath:IndexPath.init(row: indexPath.row - 1, section: indexPath.section))
                self.navigationController?.pushViewController(modify, animated: true)
            }
        case .evaluate:
            
            estimateVC.section = indexPath.section
            self.navigationController?.pushViewController(estimateVC, animated: true)
            
        
        }
    }

    // section
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == viewType.count - 1{
            return 0 
        }
        return 20
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
        
         barBtn.setTitle("预览简历", for: .normal)
         barBtn.setTitleColor(UIColor.blue, for: .normal)
         barBtn.setBackgroundImage(UIImage.init(), for: .normal)
         barBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
         barBtn.addTarget(self, action: #selector(showResume), for: .touchUpInside)
         self.navigationItem.rightBarButtonItem =  UIBarButtonItem.init(customView: barBtn)
    }
    
    //
    @objc private func showResume(){
        
        self.navigationController?.pushViewController(showResumeVC(), animated: true)
    }
    
}


extension personResumeTable: modifyItemDelegate{
    
    func modifiedItem(indexPath: IndexPath) {
        
        if viewType[indexPath.section] == .evaluate{
            // 必须用这个 cell自动调整高度
            self.tableView.reloadData()
        }
        // 重新排序
        pManager.sortByEndTime(type: viewType[indexPath.section])
        self.tableView.reloadSections([indexPath.section], animationStyle: .automatic)
        //self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func deleteItem(indexPath: IndexPath) {
        // 重新排序
        pManager.sortByEndTime(type: viewType[indexPath.section])
        self.tableView.reloadSections([indexPath.section], animationStyle: .automatic)
        //self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension personResumeTable: addResumeItenDelegate{
    
    // 添加数据，刷新section
    func addNewItem(type: resumeViewType) {
        // 重新排序
        pManager.sortByEndTime(type: type)
        self.tableView.reloadSections([viewType.index(of: type)!], animationStyle: .automatic)
    }
    
}

// 获取数据
extension personResumeTable{
    
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            
            self?.pManager.initialData()
            DispatchQueue.main.async {
                self?.didFinishloadData()
            }
            
        }
        
    }
}
