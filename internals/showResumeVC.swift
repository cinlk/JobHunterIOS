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
    private var pManager:personModelManager = personModelManager.shared

    
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
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        view.backgroundColor = UIColor.orange
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.tag = 1
        view.addSubview(label)
        _ = label.sd_layout().centerXEqualToView(view)?.bottomSpaceToView(view,15)?.autoHeightRatio(0)
        view.alpha = 0
        return view
        
    }()
    
    // tableHeadView
    private lazy var tabHeader:personTableHeader = {
        let view = personTableHeader.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tableHeaderH))
        view.isHR = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
        self.loadData()
        
        
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
 

}

extension showResumeVC{
    private func loadData(){
        
       
        tabHeader.mode = (image: resumeBaseinfo.tx, name:resumeBaseinfo.name!, introduce:"")
        (nagView.viewWithTag(1) as! UILabel).text = resumeBaseinfo.name
        tabHeader.layoutSubviews()
        table.tableHeaderView = tabHeader
        
        
    }
}

// 滑动
extension showResumeVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table{
            let offsetY = scrollView.contentOffset.y
            if offsetY > 0 && offsetY < NavH{
                nagView.alpha = offsetY / NavH
            }else if offsetY >= NavH{
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
        let count = pManager.getCountBy(type: viewType[section])
        return count == 0 ? 0: count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = UITableViewCell()
        cell.selectionStyle = .none
        let line = CALayer.init()
        line.frame = CGRect.init(x: 10, y: 40, width: ScreenW - 20, height: 0.5)
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
            cell.mode = resumeBaseinfo
            
            return cell
            
        case .education:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: educationInfoCell.identity(), for: indexPath) as! educationInfoCell
            if let ed = pManager.getItemBy(type: .education) as?  [personEducationInfo]{
                cell.mode = ed[indexPath.row - 1]
                cell.showResume = true
                return cell
            }
            
        case .works:
            let cell = tableView.dequeueReusableCell(withIdentifier: jobInfoCell.identity(), for: indexPath) as! jobInfoCell
            if let wk = pManager.getItemBy(type: .works) as? [personInternInfo]{
                cell.showResume = true
                cell.mode = wk[indexPath.row - 1]
                return cell
            }
           
        case .project:
            let cell = tableView.dequeueReusableCell(withIdentifier: projectInfoCell.identity(), for: indexPath) as! projectInfoCell
            if let pj = pManager.getItemBy(type: .project) as? [personProjectInfo]{
                cell.showResume = true
                cell.mode = pj[indexPath.row - 1]
                return cell
            }
           
        case .schoolWork:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: studentWorkCell.identity(), for: indexPath) as! studentWorkCell
            if let sh = pManager.getItemBy(type: .schoolWork) as? [studentWorkInfo]{
                cell.showResume = true
                cell.mode = sh[indexPath.row - 1]
                return cell
            }
          
        
        case .practice:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialPracticeCell.identity(), for: indexPath) as! SocialPracticeCell
            if let pc = pManager.getItemBy(type: .practice) as? [socialPracticeInfo]{
                cell.showResume = true
                cell.mode = pc[indexPath.row - 1]
                return cell
            }
           
            
        case .skills:

            let cell = tableView.dequeueReusableCell(withIdentifier: person_skillCell.identity(), for: indexPath) as! person_skillCell
            if let sk = pManager.getItemBy(type: .skills) as? [personSkillInfo]{
                cell.showResume = true
                cell.mode = sk[indexPath.row - 1]
                
                return cell
            }
           
        
        case .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: ResumeOtherCell.identity(), for: indexPath) as! ResumeOtherCell
            if let ot = pManager.getItemBy(type: .other) as? [resumeOther]{
                cell.showResume = true
                cell.mode = ot[indexPath.row - 1]
                
                return cell
            }
          
            
        case .selfEvaludate:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as! person_evaluateCell
            if let es = pManager.getItemBy(type: .selfEvaludate) as? selfEstimateModel{
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
           
            // 必须有值
            return tableView.cellHeight(for: indexPath, model: resumeBaseinfo, keyPath: "mode", cellClass: resumePersonInfoCell.self, contentViewWidth: ScreenW)
            
        case .education:
            guard let list = pManager.getItemBy(type: .education) as? [personEducationInfo] else {
                return 0
            }
            
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: educationInfoCell.self, contentViewWidth: ScreenW)
            
        case .works:
            
            guard let list =  pManager.getItemBy(type: .works) as? [personInternInfo] else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: jobInfoCell.self, contentViewWidth: ScreenW)
        
        case .project:
            
            guard let list = pManager.getItemBy(type: .project) as? [personProjectInfo] else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: projectInfoCell.self, contentViewWidth: ScreenW)
            
        case .schoolWork:
            
            guard let list = pManager.getItemBy(type: .schoolWork) as? [studentWorkInfo]  else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: studentWorkCell.self, contentViewWidth: ScreenW)
            
        case .practice:
            
            guard let list = pManager.getItemBy(type: .practice) as? [socialPracticeInfo] else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: SocialPracticeCell.self, contentViewWidth: ScreenW)
        
            
        case .skills:
            
            guard let list = pManager.getItemBy(type: .skills) as? [personSkillInfo] else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_skillCell.self, contentViewWidth: ScreenW)
        
        case .other:
            
            guard let list = pManager.getItemBy(type: .other) as? [resumeOther] else {
                return 0
            }
            let mode = list[indexPath.row - 1]
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ResumeOtherCell.self, contentViewWidth: ScreenW)
            
        case .selfEvaludate:
            
            guard let mode = pManager.getItemBy(type: .selfEvaludate) as? selfEstimateModel, !mode.content.isEmpty else {
                return 0
            }
            
            mode.isOpen = true
            
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_evaluateCell.self, contentViewWidth: ScreenW)

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
        
        let count = pManager.getCountBy(type: type)
        return count > 0 ? 20 : 0
        
    }
    
    
    
}
