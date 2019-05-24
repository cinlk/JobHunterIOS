//
//  showResumeVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/3.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



fileprivate let tableHeaderH:CGFloat = 180

class showResumeVC: UIViewController {

    
    //
    private var viewType:[ResumeSubItems] = [ResumeSubItems.personInfo,.education,.works, .project,.schoolWork,.practice,.skills,.other,.selfEvaludate]

    // test
    //private var pManager:personModelManager = personModelManager.shared

    internal var mode:PersonTextResumeModel?{
        didSet{
            
            self.loadData()
        }
    }
    
    private lazy var table:UITableView = {  [unowned self] in
        let table = UITableView.init(frame: CGRect.zero)
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.showsHorizontalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.contentInsetAdjustmentBehavior = .never
        table.backgroundColor = UIColor.viewBackColor()
        table.register(resumePersonInfoCell.self, forCellReuseIdentifier: resumePersonInfoCell.identity())
        table.register(educationInfoCell.self, forCellReuseIdentifier: educationInfoCell.identity())
        table.register(jobInfoCell.self, forCellReuseIdentifier: jobInfoCell.identity())
        table.register(person_skillCell.self, forCellReuseIdentifier: person_skillCell.identity())
        table.register(person_evaluateCell.self, forCellReuseIdentifier: person_evaluateCell.identity())
        table.register(SocialPracticeCell.self, forCellReuseIdentifier: SocialPracticeCell.identity())
        table.register(studentWorkCell.self, forCellReuseIdentifier: studentWorkCell.identity())
        table.register(projectInfoCell.self, forCellReuseIdentifier: projectInfoCell.identity())
        table.register(ResumeOtherCell.self, forCellReuseIdentifier: ResumeOtherCell.identity())
        return table
    }()
    
    // 带名称的 nav view
    private lazy var nagView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH))
        view.backgroundColor = UIColor.orange
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.tag = 1
        view.addSubview(label)
        _ = label.sd_layout().centerXEqualToView(view)?.bottomSpaceToView(view,15)?.autoHeightRatio(0)
        view.alpha = 0
        return view
        
    }()
    
    // tableHeadView
    private lazy var tabHeader:PersonTableHeader = {
        let view = PersonTableHeader.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: tableHeaderH))
        view.isHR = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.insertSubview(nagView, at: 1)
        self.navigationController?.view.viewWithTag(1999)?.alpha = 0
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nagView.removeFromSuperview()
        self.navigationController?.view.viewWithTag(1999)?.alpha = 1
    }
 
    
    deinit {
        print("deinit showResumeVC \(self)")
    }

}

extension showResumeVC{
    private func loadData(){
        
        tabHeader.mode = (image: self.mode!.basePersonInfo.tx, name: self.mode!.basePersonInfo.name, introduce:"")
        //tabHeader.mode = (image: resumeBaseinfo.tx, name:resumeBaseinfo.name!, introduce:"")
        (nagView.viewWithTag(1) as! UILabel).text = self.mode?.basePersonInfo.name
        tabHeader.layoutSubviews()
        table.tableHeaderView = tabHeader
        table.reloadData()
        
    }
}

// 滑动
extension showResumeVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table{
            let offsetY = scrollView.contentOffset.y
            if offsetY > 0 && offsetY < GlobalConfig.NavH{
                nagView.alpha = offsetY / GlobalConfig.NavH
            }else if offsetY >= GlobalConfig.NavH{
                nagView.alpha = 1
            }else{
                nagView.alpha = 0
                scrollView.contentOffset = CGPoint.zero
            }
        }
    }
}

extension showResumeVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
       return viewType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if viewType[section] == .personInfo{
            return 2
        }
        if viewType[section] == .selfEvaludate, let es = self.mode?[viewType[section]] as? EstimateTextResume {
            
            return es.content.isEmpty ? 0 : 2
        }
        let count = (self.mode?[viewType[section]] as? NSArray) ?? []
        return count.count == 0 ? 0: count.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = UITableViewCell()
        cell.selectionStyle = .none
        let line = CALayer.init()
        line.frame = CGRect.init(x: 10, y: 40, width: GlobalConfig.ScreenW - 20, height: 0.5)
        line.backgroundColor = UIColor.lightGray.cgColor
        line.borderWidth = 0.5
        cell.clipsToBounds = true
        cell.layer.addSublayer(line)
        
        let type = viewType[indexPath.section]
        
        if indexPath.row == 0 {
            cell.textLabel?.text = type.describe
            return cell
        }
        
        
        switch type {
            
        case .personInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: resumePersonInfoCell.identity(), for: indexPath) as! resumePersonInfoCell
            //cell.mode = resumeBaseinfo
            cell.mode = self.mode?.basePersonInfo
            return cell
            
        case .education:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: educationInfoCell.identity(), for: indexPath) as! educationInfoCell
            if let ed =  self.mode?[type]  as?  [educationInfoTextResume]{
                cell.mode = ed[indexPath.row - 1]
                cell.showResume = true
                return cell
            }
            
        case .works:
            let cell = tableView.dequeueReusableCell(withIdentifier: jobInfoCell.identity(), for: indexPath) as! jobInfoCell
            if let wk =  self.mode?[type]  as? [workInfoTextResume]{
                cell.showResume = true
                cell.mode = wk[indexPath.row - 1]
                return cell
            }
           
        case .project:
            let cell = tableView.dequeueReusableCell(withIdentifier: projectInfoCell.identity(), for: indexPath) as! projectInfoCell
            if let pj = self.mode?[type]  as? [ProjectInfoTextResume]{
                cell.showResume = true
                cell.mode = pj[indexPath.row - 1]
                return cell
            }
           
        case .schoolWork:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: studentWorkCell.identity(), for: indexPath) as! studentWorkCell
            if let sh = self.mode?[type]  as? [CollegeActivityTextResume]{
                cell.showResume = true
                cell.mode = sh[indexPath.row - 1]
                return cell
            }
          
        
        case .practice:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialPracticeCell.identity(), for: indexPath) as! SocialPracticeCell
            if let pc = self.mode?[type]  as? [SocialPracticeTextResume]{
                cell.showResume = true
                cell.mode = pc[indexPath.row - 1]
                return cell
            }
           
            
        case .skills:

            let cell = tableView.dequeueReusableCell(withIdentifier: person_skillCell.identity(), for: indexPath) as! person_skillCell
            if let sk = self.mode?[type]  as? [SkillsTextResume]{
                cell.showResume = true
                cell.mode = sk[indexPath.row - 1]
                
                return cell
            }
           
        
        case .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: ResumeOtherCell.identity(), for: indexPath) as! ResumeOtherCell
            if let ot = self.mode?[type]  as? [OtherTextResume]{
                cell.showResume = true
                cell.mode = ot[indexPath.row - 1]
                
                return cell
            }
          
            
        case .selfEvaludate:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as! person_evaluateCell
            if let es = self.mode?[type]  as? EstimateTextResume{
                cell.mode = es
                //cell.mode?.isOpen = true
                return cell
            }
            
        default:
            break
        }
        
        
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 40
        }
       
        switch viewType[indexPath.section] {
        case .personInfo:
          
            guard let mode = self.mode?.basePersonInfo else {
                return 0
            }
           return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: resumePersonInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
            
        case .education:
            guard let list = self.mode?[.education]  as? [educationInfoTextResume] else {
                return 0
            }
            
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: educationInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
            
        case .works:
            
            guard let list =  self.mode?[.works]  as? [workInfoTextResume] else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: jobInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
        case .project:
            
            guard let list = self.mode?[.project]  as? [ProjectInfoTextResume] else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: projectInfoCell.self, contentViewWidth: GlobalConfig.ScreenW)
            
        case .schoolWork:
            
            guard let list = self.mode?[.schoolWork]  as? [CollegeActivityTextResume]  else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: studentWorkCell.self, contentViewWidth: GlobalConfig.ScreenW)
            
        case .practice:
            
            guard let list = self.mode?[.practice]  as? [SocialPracticeTextResume] else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: SocialPracticeCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
            
        case .skills:
            
            guard let list = self.mode?[.skills]  as? [SkillsTextResume] else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_skillCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
        case .other:
            
            guard let list = self.mode?[.other]  as? [OtherTextResume] else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ResumeOtherCell.self, contentViewWidth: GlobalConfig.ScreenW)
            
        case .selfEvaludate:
            
            guard let mode = self.mode?[.selfEvaludate]  as? EstimateTextResume, !mode.content.isEmpty else {
                return 0
            }
            
            mode.isOpen = true
            
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_evaluateCell.self, contentViewWidth: GlobalConfig.ScreenW)

        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    
    // section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let type = viewType[section]
        if type == .personInfo{
            return 20
        }
        if type == .selfEvaludate, let es = self.mode?[viewType[section]] as? EstimateTextResume {
              return   es.content.isEmpty ? 0 : 20
        }
        let count =  self.mode?[type] as? NSArray ?? []
        return count.count > 0 ? 20 : 0
        
    }
    
    
    
}
