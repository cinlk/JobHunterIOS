//
//  personResumeTable.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa




fileprivate let VCtitle:String = "简历完整度"

// 在线简历VC
class PersonTextResumeViewController: BaseViewController {
    
    
    
    internal var resumeID:String?{
        didSet{
            guard let _  = resumeID else {
                return
            }
            loadData()
        }
    }
    
    private lazy var mode:PersonTextResumeModel = PersonTextResumeModel.init(JSON: [:])!
    
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    
    
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
    

    // 进入页面时 要刷新数据
    //private var pManager:personModelManager = personModelManager.shared
    // 初始化subitem类型
    
    private var viewType:[ResumeSubItems] = [.personInfo,.education,.works, .project,.schoolWork,.practice,.skills,.other,.selfEvaludate]
   
//    private var datas:[ResumeSubItems:Any?]{
//        get{
//            return pManager.getDatas()
//        }
//    }
    

    private lazy var barBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 25))
        
        btn.setTitle("预览简历", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setBackgroundImage(UIImage.init(), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //btn.addTarget(self, action: #selector(showResume), for: .touchUpInside)
        return btn
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        setViewModel()
    }

    
    override func setViews(){
        
       
        self.view.addSubview(tableView)
        _ = tableView.sd_layout().topSpaceToView(self.view,GlobalConfig.NavH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        
    
        self.hiddenViews.append(tableView)
        self.hiddenViews.append(barBtn)
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem.init(customView: barBtn)
        
        super.setViews()
        
    }
    
    override func didFinishloadData(){
        
        self.title  = VCtitle +  "\(self.mode.level)%"
        super.didFinishloadData()
        self.tableView.reloadData()
        
        withUnsafePointer(to: &self.mode.basePersonInfo) { print("basePersonInfo address --->", $0)
        }
        
    }
    
    
    override func reload(){
        super.reload()
        self.loadData()
        
    }
    
    
    deinit {
        print("deinit personTextViewController \(self)")
    }
    

}


extension PersonTextResumeViewController{
    private func setViewModel(){
        
        
        
        barBtn.rx.tap.asDriver().drive(onNext: { [weak self] in
            let vc = showResumeVC.init()
            vc.mode = self?.mode
            self?.navigationController?.pushViewController(vc, animated: true)
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
    }
}


// table

extension PersonTextResumeViewController: UITableViewDataSource, UITableViewDelegate{
    
    
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
        
        guard let arrys = self.mode[viewType[section]] as? NSArray  else {
            return 0
        }
        return arrys.count + 2
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 个人基本信息（不是数组）
        if indexPath.section == 0 {
//            self.mode.basePersonInfo
//            guard let mode = datas[viewType[0]] as? personalBasicalInfo else {
//                return UITableViewCell()
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: resume_personInfoCell.identity()) as!
            resume_personInfoCell
            cell.mode = self.mode.basePersonInfo
            return cell
            
            // 自我评价
        }else if indexPath.section == viewType.count - 1{
//            guard let mode = datas[viewType[indexPath.section]] as? selfEstimateModel else {
//                return UITableViewCell()
//            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as!
            person_evaluateCell
            cell.mode = self.mode.selfEstimate
            
            return cell
            
            
        }else{
            
            let type = viewType[indexPath.section]
            //let infos = (datas[type] as? NSArray) ?? []
            let infos = (self.mode[type] as? NSArray) ?? []
            
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
                cell.addMoreItem = { [weak self] in
                    let view = AddResumeItemSubItemViewController()
                    view.itemType = type
                    view.delegate = self
                    view.resumeId = self?.resumeID ?? ""
                    self?.navigationController?.pushViewController(view, animated: true)
                }
                return cell
                // 具体内容cell
            }else{
                guard infos.count > 0 else { return UITableViewCell() }
                
                
                switch type{
                case .education:
//                    guard let modes = infos as?  [personEducationInfo] else { return UITableViewCell() }
                    let cell = tableView.dequeueReusableCell(withIdentifier: educationInfoCell.identity(), for: indexPath) as!
                    educationInfoCell
                    cell.mode = self.mode.educationInfos[indexPath.row - 1]
                    
                    return cell
                case .works:
                    let cell = tableView.dequeueReusableCell(withIdentifier: jobInfoCell.identity(), for: indexPath) as! jobInfoCell
                    cell.mode = self.mode.workInfos[indexPath.row - 1]
                    return cell
                case .project:
                    let cell = tableView.dequeueReusableCell(withIdentifier: projectInfoCell.identity(), for: indexPath) as!  projectInfoCell
                    cell.mode = self.mode.projectInfos[indexPath.row - 1]
                    return cell
                case .schoolWork:
                    let cell = tableView.dequeueReusableCell(withIdentifier: studentWorkCell.identity(), for: indexPath) as! studentWorkCell
                    cell.mode = self.mode.colleageActivities[indexPath.row - 1]
                    return cell
                case .practice:
                    let cell = tableView.dequeueReusableCell(withIdentifier: SocialPracticeCell.identity(), for: indexPath) as! SocialPracticeCell
                    cell.mode = self.mode.practice[indexPath.row - 1]
                    
                    return cell
                case .other:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: ResumeOtherCell.identity(), for: indexPath) as! ResumeOtherCell
                    cell.mode = self.mode.other[indexPath.row - 1]
                    
                    return cell
                    
                    
                case .skills:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: person_skillCell.identity(), for: indexPath) as! person_skillCell
                    cell.mode = self.mode.skills[indexPath.row - 1]
                    return cell
                    
                case .selfEvaludate:
                    let cell = tableView.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as! person_evaluateCell
                    cell.mode = self.mode.selfEstimate
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
//            guard let mode = datas[viewType[0]] as? personalBasicalInfo else {
//                return 0
//            }
            
            return tableView.cellHeight(for: indexPath, model: self.mode.basePersonInfo, keyPath: "mode", cellClass: resume_personInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
        }else if indexPath.section == viewType.count - 1{
            
            
//            guard  let mode =  datas[viewType[indexPath.section]] as? selfEstimateModel else {
//                return 0
//            }
            let mode = self.mode.selfEstimate
            mode.isOpen = false
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_evaluateCell.self, contentViewWidth: GlobalConfig.ScreenW)
            
        }else{
            
//            guard let modes = datas[viewType[indexPath.section]] as? NSArray else {
//                return 0
//            }
            
            guard let modes = self.mode[viewType[indexPath.section]] as? NSArray else {
                return 0
            }
            if indexPath.row == 0 || indexPath.row == modes.count + 1{
                return 45
            }
            
            //let infos = (datas[viewType[indexPath.section]] as? NSArray) ?? []
            
            switch viewType[indexPath.section]{
                
            case .education:
//                guard let modes = infos as?  [personEducationInfo] else { return 0  }
                let mode = self.mode.educationInfos[indexPath.row - 1]
                mode.isOpen = false
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: educationInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
                
                
            case .works:
//                guard let modes = infos as?  [personInternInfo] else { return 0 }
                let mode = self.mode.workInfos[indexPath.row - 1]
                mode.isOpen = false
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: jobInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
                
            case .project:
            
                //guard let modes = infos as?  [personProjectInfo] else { return 0 }
                let mode = self.mode.projectInfos[indexPath.row - 1]
                mode.isOpen = false
                
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: projectInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
                
            case .schoolWork:
                
                
                //guard let modes = infos as?  [studentWorkInfo] else { return 0 }
                
                let mode = self.mode.colleageActivities[indexPath.row - 1]
                mode.isOpen = false
                
                 return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: studentWorkCell.self, contentViewWidth: GlobalConfig.ScreenW)
              
                
            case .practice:
               // guard let modes = infos as?  [socialPracticeInfo] else { return 0 }
                
                let mode = self.mode.practice[indexPath.row - 1]
                mode.isOpen = false
                
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: SocialPracticeCell.self, contentViewWidth: GlobalConfig.ScreenW)

                
            case .other:
                //guard let modes = infos as?  [resumeOther] else { return 0 }
                
                let mode = self.mode.other[indexPath.row - 1]
                mode.isOpen = false
                
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ResumeOtherCell.self, contentViewWidth: GlobalConfig.ScreenW)

                
            case .skills:
                
                //guard let modes = infos as?  [personSkillInfo] else { return 0 }
                let mode = self.mode.skills[indexPath.row - 1]
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
            //guard let info = datas[type] as? personalBasicalInfo else { return }
            
            let pModify = modifyPersonInfoVC()
            
          
            //pModify.mode = (resumeId: self.resumeID!, indexPath:indexPath, info: self.mode.basePersonInfo)
            pModify.setData(resumeId: self.resumeID!, indexPath: indexPath ,mode: &self.mode.basePersonInfo)
            
            pModify.delegate = self
            
            
            self.navigationController?.pushViewController(pModify, animated: true)
            
        case .education, .works, .skills,.project,.practice,.schoolWork,.other:
            
            guard let modes = self.mode[type] as? NSArray else {
                return
            }
            //if indexPath.row != 0 && indexPath.row != pManager.getCountBy(type: type) + 1{
             if indexPath.row != 0 && indexPath.row != modes.count + 1
            {
                let modify = modifyResumeItemVC()
                modify.delegate = self
//                guard let list = datas[type] as? NSArray else {
//                    return
//                }
                //let list =  self.mode[type]
                modify.mode = (viewType:type, indexPath:IndexPath.init(row: indexPath.row - 1, section: indexPath.section), data: modes[indexPath.row - 1], resumeId: self.resumeID!)
                self.navigationController?.pushViewController(modify, animated: true)
            }
        case .selfEvaludate:
            let evc = evaluateSelfVC()
            evc.delegate = self
//            evc.id  =  self.mode.selfEstimate.id
//            evc.resumeId = self.resumeID!
//            evc.section = indexPath.section
//            evc.content =  self.mode.selfEstimate.content
            evc.setData(id: self.mode.selfEstimate.id, resumeId: self.resumeID!, section: indexPath.section,  content: self.mode.selfEstimate.content)
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



extension PersonTextResumeViewController: modifyItemDelegate{

    
    func modifiedItem(indexPath: IndexPath, type: ResumeSubItems, mode: Any?) {
        
        if viewType[indexPath.section] == .selfEvaludate{
            // 必须用这个 cell自动调整高度
            self.tableView.reloadData()
        }
        switch type {
        case .personInfo:
            if let m = mode as? personalBaseInfoTextResume{
                self.mode.basePersonInfo = m
            }
            
        case .education:
            if let m = mode as? educationInfoTextResume{
                self.mode.educationInfos[indexPath.row] = m
                self.mode.sortByEndTime(type: type)
            }
        case .works:
            if let m = mode as? workInfoTextResume{
                self.mode.workInfos[indexPath.row] = m
                self.mode.sortByEndTime(type: type)
            }
        case .project:
            if let m = mode as? ProjectInfoTextResume{
                self.mode.projectInfos[indexPath.row] = m
                self.mode.sortByEndTime(type: type)
            }
            
        case .schoolWork:
            if let m = mode as? CollegeActivityTextResume{
                self.mode.colleageActivities[indexPath.row] = m
                self.mode.sortByEndTime(type: type)
            }
        case .practice:
            if let m = mode as? SocialPracticeTextResume{
                self.mode.practice[indexPath.row] = m
                self.mode.sortByEndTime(type: type)
            }
        case .skills:
            if let m = mode as? SkillsTextResume{
                self.mode.skills[indexPath.row] = m
                self.mode.sortByEndTime(type: type)
            }
        case .other:
            if let m = mode as? OtherTextResume{
                self.mode.other[indexPath.row] = m
                self.mode.sortByEndTime(type: type)
            }
            
            
        case .selfEvaludate:
            if let m = mode as? EstimateTextResume{
                self.mode.selfEstimate = m
                
            }
        default:
            break
        }
        // 重新排序
        
       // pManager.sortByEndTime(type: viewType[indexPath.section])
        //print(self.mode.basePersonInfo.toJSON())
        self.tableView.reloadSections([indexPath.section], animationStyle: .automatic)
    }
    
    func deleteItem(indexPath: IndexPath, type:ResumeSubItems) {
        // 重新排序
       // pManager.sortByEndTime(type: viewType[indexPath.section])
        
        switch type {
        case .education:
            self.mode.educationInfos.remove(at: indexPath.row)
            self.mode.sortByEndTime(type: type)
        case .works:
            
            self.mode.workInfos.remove(at: indexPath.row)
            self.mode.sortByEndTime(type: type)
            
        case .project:
            
            self.mode.projectInfos.remove(at: indexPath.row)
            self.mode.sortByEndTime(type: type)
            
            
        case .schoolWork:
            
            self.mode.colleageActivities.remove(at: indexPath.row)
            self.mode.sortByEndTime(type: type)
            
        case .practice:
            
            self.mode.practice.remove(at: indexPath.row)
            self.mode.sortByEndTime(type: type)
            
        case .skills:
            
            self.mode.skills.remove(at: indexPath.row)
            self.mode.sortByEndTime(type: type)
            
        case .other:
            
            self.mode.other.remove(at: indexPath.row)
            self.mode.sortByEndTime(type: type)
            
        default:
            break
        }
        self.tableView.reloadSections([indexPath.section], animationStyle: .automatic)
    }
}

extension PersonTextResumeViewController: addResumeItenDelegate{
    
    // 添加数据，刷新section
    func addNewItem(type: ResumeSubItems, mode:Any?) {
        
        
        switch type {
        case .education:
            if let ed = mode as? educationInfoTextResume{
                self.mode.educationInfos.append(ed)
            }
           
        case .works:
            if let m = mode as? workInfoTextResume{
                self.mode.workInfos.append(m)
            }
        case .project:
            if let m = mode as? ProjectInfoTextResume{
                self.mode.projectInfos.append(m)
            }
            
        case .schoolWork:
            if let m = mode as? CollegeActivityTextResume{
                self.mode.colleageActivities.append(m)
            }
        case .practice:
            if let m = mode as? SocialPracticeTextResume{
                self.mode.practice.append(m)
            }
        case .skills:
            if let m = mode as? SkillsTextResume{
                self.mode.skills.append(m)
            }
        case .other:
            if let m = mode as? OtherTextResume{
                self.mode.other.append(m)
            }
            
        default:
            break
        }
        self.mode.sortByEndTime(type: type)
        
        self.tableView.reloadData()
        // 重新排序
       // pManager.sortByEndTime(type: type)
        //self.tableView.reloadSections([viewType.firstIndex(of: type)!], animationStyle: .automatic)
    }
    
}

// 获取数据
extension PersonTextResumeViewController{
    
    private func loadData(){
        
        self.vm.textResumeInfo(resumeId: self.resumeID!).subscribe(onNext: { [weak self] (res) in
            if let mode = res.body{
                self?.mode = mode
                self?.didFinishloadData()
                
                
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            Thread.sleep(forTimeInterval: 1)
//
//            self?.mode = PersonTextResumeModel.init(JSON: ["resume_id":"1223"])!
//            //self?.pManager.getOnlineResume(resumeID: (self?.resumeID)!)
//            DispatchQueue.main.async {
//                self?.didFinishloadData()
//            }
//
//        }
        
    }
}
