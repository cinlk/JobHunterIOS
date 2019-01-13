//
//  personResumeTable.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let VCtitle:String = "简历完整度"


// 在线简历VC
class personResumeTable: BaseViewController {
    
    
    
    private lazy var tableView:UITableView = {  [unowned self] in
        let tb = UITableView()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.tableFooterView  = UIView.init()
        tb.showsHorizontalScrollIndicator = false
        tb.separatorStyle = .singleLine
        tb.register(resume_personInfoCell.self, forCellReuseIdentifier: resume_personInfoCell.identity())
        tb.register(educationInfoCell.self, forCellReuseIdentifier: educationInfoCell.identity())
        tb.register(jobInfoCell.self, forCellReuseIdentifier: jobInfoCell.identity())
        tb.register(person_skillCell.self, forCellReuseIdentifier: person_skillCell.identity())
        tb.register(person_evaluateCell.self, forCellReuseIdentifier: person_evaluateCell.identity())
        tb.register(SocialPracticeCell.self, forCellReuseIdentifier: SocialPracticeCell.identity())
        tb.register(studentWorkCell.self, forCellReuseIdentifier: studentWorkCell.identity())
        tb.register(projectInfoCell.self, forCellReuseIdentifier: projectInfoCell.identity())
        tb.register(ResumeOtherCell.self, forCellReuseIdentifier: ResumeOtherCell.identity())
        
        
        // 底部cell
        tb.register(singleButtonCell.self, forCellReuseIdentifier: singleButtonCell.identity())
        tb.dataSource = self
        tb.delegate = self
        
        return tb
    }()
    
    internal var resumeID:String?{
        didSet{
            guard let _  = resumeID else {
                return
            }
            loadData()
        }
    }
    // 进入页面时 要刷新数据
    private var pManager:personModelManager = personModelManager.shared
    // 初始化subitem类型
    
    private var viewType:[ResumeSubItems] = [.personInfo,.education,.works, .project,.schoolWork,.practice,.skills,.other,.selfEvaludate]
   
    private var datas:[ResumeSubItems:Any?]{
        get{
            return pManager.getDatas()
        }
    }
    
    
    
    
    

    
    private lazy var barBtn:UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 25))

 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
       
        
    }

    
    override func setViews(){
        
       
        self.view.addSubview(tableView)
        _ = tableView.sd_layout().topSpaceToView(self.view,NavH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        
        
       
        //navigationItem
        addBarItem()
        self.handleViews.append(tableView)
        self.handleViews.append(barBtn)
        
        super.setViews()
        
    }
    
    override func didFinishloadData(){
        
        self.title  = VCtitle +  "\(pManager.integrity)%"
        super.didFinishloadData()
        self.tableView.reloadData()
    }
    
    
    override func reload(){
        super.reload()
        self.loadData()
        
    }
    
    

}


// table

extension personResumeTable: UITableViewDataSource, UITableViewDelegate{
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  viewType.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // 个人信息 和 自我评价只有一行
        if viewType[section] == .personInfo || viewType[section] == .selfEvaludate{
            return 1
        }
        guard let arrys = datas[viewType[section]] as? NSArray else {
            return 0
        }
        return arrys.count + 2
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 个人基本信息（不是数组）
        if indexPath.section == 0 {
            guard let mode = datas[viewType[0]] as? personalBasicalInfo else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: resume_personInfoCell.identity()) as!
            resume_personInfoCell
            cell.mode = mode
            return cell
            
            // 自我评价
        }else if indexPath.section == viewType.count - 1{
            guard let mode = datas[viewType[indexPath.section]] as? selfEstimateModel else {
                return UITableViewCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as!
            person_evaluateCell
            cell.mode = mode
            
            return cell
            
            
        }else{
            
            let type = viewType[indexPath.section]
            let infos = (datas[type] as? NSArray) ?? []
            
            // 名字cell
            if indexPath.row == 0 {
                
                let cell = UITableViewCell.init()
                
                cell.textLabel?.text = type.describe
                cell.textLabel?.textAlignment = .left
                cell.isUserInteractionEnabled = false
                return cell
                
                // 添加btn cell
            }else if indexPath.row == infos.count + 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: singleButtonCell.identity(), for: indexPath) as! singleButtonCell
                cell.btnType = .add
                cell.btn.setTitle(type.add, for: .normal)
                cell.addMoreItem = {
                    let view = AddBaseInfoTableViewController()
                    view.itemType = type
                    view.delegate = self
                    self.navigationController?.pushViewController(view, animated: true)
                }
                return cell
                // 具体内容cell
            }else{
                guard infos.count > 0 else { return UITableViewCell() }
                
                
                switch type{
                case .education:
                    guard let modes = infos as?  [personEducationInfo] else { return UITableViewCell() }
                    let cell = tableView.dequeueReusableCell(withIdentifier: educationInfoCell.identity(), for: indexPath) as!
                    educationInfoCell
                    cell.mode = modes[indexPath.row - 1]
                    
                    return cell
                    
                default:
                    break
                }
            }
            
        }
        
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            guard let mode = datas[viewType[0]] as? personalBasicalInfo else {
                return 0
            }
            
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: resume_personInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
        }else if indexPath.section == viewType.count - 1{
            
            
            guard  let mode =  datas[viewType[indexPath.section]] as? selfEstimateModel else {
                return 0
            }
            mode.isOpen = false
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_evaluateCell.self, contentViewWidth: GlobalConfig.ScreenW)
            
        }else{
            
            guard let modes = datas[viewType[indexPath.section]] as? NSArray else {
                return 0
            }
            
            if indexPath.row == 0 || indexPath.row == modes.count + 1{
                return 45
            }
            
            let infos = (datas[viewType[indexPath.section]] as? NSArray) ?? []
            
            switch viewType[indexPath.section]{
                
            case .education:
                guard let modes = infos as?  [personEducationInfo] else { return 0  }
                let mode = modes[indexPath.row - 1]
                mode.isOpen = false
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: educationInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
                
                
            case .works:
                guard let modes = infos as?  [personInternInfo] else { return 0 }
                let mode = modes[indexPath.row - 1]
                mode.isOpen = false
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: jobInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
                
            case .project:
            
                guard let modes = infos as?  [personProjectInfo] else { return 0 }
                let mode = modes[indexPath.row - 1]
                mode.isOpen = false
                
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: projectInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
                
            case .schoolWork:
                
                
                guard let modes = infos as?  [studentWorkInfo] else { return 0 }
                
                let mode = modes[indexPath.row - 1]
                mode.isOpen = false
                
                 return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: studentWorkCell.self, contentViewWidth: GlobalConfig.ScreenW)
              
                
            case .practice:
                guard let modes = infos as?  [socialPracticeInfo] else { return 0 }
                
                let mode = modes[indexPath.row - 1]
                mode.isOpen = false
                
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: SocialPracticeCell.self, contentViewWidth: GlobalConfig.ScreenW)

                
            case .other:
                guard let modes = infos as?  [resumeOther] else { return 0 }
                
                let mode = modes[indexPath.row - 1]
                mode.isOpen = false
                
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ResumeOtherCell.self, contentViewWidth: GlobalConfig.ScreenW)

                
            case .skills:
                
                guard let modes = infos as?  [personSkillInfo] else { return 0 }
                let mode = modes[indexPath.row - 1]
                mode.isOpen = false
                
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_skillCell.self, contentViewWidth: GlobalConfig.ScreenW)
            
            default:
                break
            }
            
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let type = viewType[indexPath.section]
        switch type {
            
        case .personInfo:
            guard let info = datas[type] as? personalBasicalInfo else { return }
            let pModify = modifyPersonInfoVC()
            pModify.mode = (indexPath:indexPath, info:info)
            pModify.delegate = self
            
            self.navigationController?.pushViewController(pModify, animated: true)
            
        case .education, .works, .skills,.project,.practice,.schoolWork,.other:
            
            if indexPath.row != 0 && indexPath.row != pManager.getCountBy(type: type) + 1{
                
                
                let modify = modifyitemView()
                modify.delegate = self
                guard let list = datas[type] as? NSArray else {
                    return
                }
                modify.mode = (viewType:type, indexPath:IndexPath.init(row: indexPath.row - 1, section: indexPath.section), data: list[indexPath.row - 1])
                self.navigationController?.pushViewController(modify, animated: true)
            }
        case .selfEvaludate:
            let evc = evaluateSelfVC()
            evc.delegate = self
            evc.section = indexPath.section
            self.navigationController?.pushViewController(evc, animated: true)

        default:
            break
            
        }
    }
    
    // section
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  20
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
        
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
        
        if viewType[indexPath.section] == .selfEvaludate{
            // 必须用这个 cell自动调整高度
            self.tableView.reloadData()
        }
        // 重新排序
        pManager.sortByEndTime(type: viewType[indexPath.section])
        self.tableView.reloadSections([indexPath.section], animationStyle: .automatic)
    }
    
    func deleteItem(indexPath: IndexPath) {
        // 重新排序
        pManager.sortByEndTime(type: viewType[indexPath.section])
        self.tableView.reloadSections([indexPath.section], animationStyle: .automatic)
    }
}

extension personResumeTable: addResumeItenDelegate{
    
    // 添加数据，刷新section
    func addNewItem(type: ResumeSubItems) {
        // 重新排序
        pManager.sortByEndTime(type: type)
        self.tableView.reloadSections([viewType.index(of: type)!], animationStyle: .automatic)
    }
    
}

// 获取数据
extension personResumeTable{
    
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 1)
            
            self?.pManager.getOnlineResume(resumeID: (self?.resumeID)!)
            DispatchQueue.main.async {
                self?.didFinishloadData()
            }
            
        }
        
    }
}
