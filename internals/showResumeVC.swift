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
    private var viewType:[ResumeSubItems] = [.personInfo,.education,.works, .project,.schoolWork,.practice,.skills,.other,.selfEvaludate]

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
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.title = ""
        nagView.removeFromSuperview()
    }

}

extension showResumeVC{
    private func loadData(){
        
        if let personInfo = pManager.mode?.basicinfo{
            tabHeader.mode = (image: personInfo.tx, name:personInfo.name, introduce:"")
            (nagView.viewWithTag(1) as! UILabel).text = personInfo.name
            
            tabHeader.layoutSubviews()
            table.tableHeaderView = tabHeader
        }
        
        
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
            }
        }
    }
}

extension showResumeVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
       return viewType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewType[section] {
            
        case .personInfo:
            return 2
        case .education:
            if pManager.mode?.educationInfo.count  == 0 {
                return 0
            }
            return (pManager.mode?.educationInfo.count ?? 0) + 1
        case .works:
            if pManager.mode?.internInfo.count  == 0 {
                return 0
            }
            
            return (pManager.mode?.internInfo.count ?? 0) + 1
        case .project:
            if pManager.mode?.projectInfo.count  == 0 {
                return 0
            }
            return (pManager.mode?.projectInfo.count ?? 0) + 1
        case .schoolWork:
            if pManager.mode?.studentWorkInfo.count  == 0 {
                return 0
            }
            return (pManager.mode?.studentWorkInfo.count ?? 0) + 1
        case .practice:
            if pManager.mode?.practiceInfo.count  == 0 {
                return 0
            }
            return (pManager.mode?.practiceInfo.count ?? 0) + 1
        case .skills:
            if pManager.mode?.skills.count  == 0 {
                return 0
            }
            return (pManager.mode?.skills.count ?? 0) + 1
        case .other:
            if pManager.mode?.resumeOtherInfo.count  == 0 {
                return 0
            }
            return (pManager.mode?.resumeOtherInfo.count ?? 0) + 1
        case .selfEvaludate:
            if let content = pManager.mode?.estimate?.content{
                return content.isEmpty ? 0 : 2
            }
            return 0
        default:
            return 0
        }
        
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
            cell.mode = pManager.mode?.basicinfo
            
            return cell
            
        case .education:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: educationInfoCell.identity(), for: indexPath) as! educationInfoCell
            cell.mode = pManager.mode?.educationInfo[indexPath.row - 1]
            cell.showResume = true
            return cell
            
        case .works:
            let cell = tableView.dequeueReusableCell(withIdentifier: jobInfoCell.identity(), for: indexPath) as! jobInfoCell
            cell.showResume = true
            cell.mode = pManager.mode?.internInfo[indexPath.row - 1]
           
            return cell
        case .project:
            let cell = tableView.dequeueReusableCell(withIdentifier: projectInfoCell.identity(), for: indexPath) as! projectInfoCell
            cell.showResume = true
            cell.mode = pManager.mode?.projectInfo[indexPath.row - 1]
            return cell
        case .schoolWork:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: studentWorkCell.identity(), for: indexPath) as! studentWorkCell
            cell.showResume = true
            cell.mode = pManager.mode?.studentWorkInfo[indexPath.row - 1]
            return cell
        
        case .practice:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SocialPracticeCell.identity(), for: indexPath) as! SocialPracticeCell
            cell.showResume = true
            cell.mode = pManager.mode?.practiceInfo[indexPath.row - 1]
            return cell
            
        case .skills:

            let cell = tableView.dequeueReusableCell(withIdentifier: person_skillCell.identity(), for: indexPath) as! person_skillCell
            cell.showResume = true
            cell.mode = pManager.mode?.skills[indexPath.row - 1]
            
            return cell
        
        case .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: ResumeOtherCell.identity(), for: indexPath) as! ResumeOtherCell
            cell.showResume = true
            cell.mode = pManager.mode?.resumeOtherInfo[indexPath.row - 1]
            
            return cell
            
        case .selfEvaludate:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as! person_evaluateCell
            cell.mode = pManager.mode?.estimate
            //cell.mode?.isOpen = true
            return cell
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
            guard let mode = pManager.mode?.basicinfo  else {
                return 0
            }
            
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: resumePersonInfoCell.self, contentViewWidth: ScreenW)
            
        case .education:
            guard let mode = pManager.mode?.educationInfo[indexPath.row - 1] else {
                return 0
            }
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: educationInfoCell.self, contentViewWidth: ScreenW)
            
        case .works:
            
            guard let mode =  pManager.mode?.internInfo[indexPath.row - 1] else {
                return 0
            }
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: jobInfoCell.self, contentViewWidth: ScreenW)
        
        case .project:
            
            guard let mode = pManager.mode?.projectInfo[indexPath.row - 1] else {
                return 0
            }
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: projectInfoCell.self, contentViewWidth: ScreenW)
            
        case .schoolWork:
            
            guard let mode = pManager.mode?.studentWorkInfo[indexPath.row - 1] else {
                return 0
            }
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: studentWorkCell.self, contentViewWidth: ScreenW)
            
        case .practice:
            
            guard let mode = pManager.mode?.practiceInfo[indexPath.row - 1] else {
                return 0
            }
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: SocialPracticeCell.self, contentViewWidth: ScreenW)
        
            
        case .skills:
            
            guard let mode = pManager.mode?.skills[indexPath.row - 1] else {
                return 0
            }
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_skillCell.self, contentViewWidth: ScreenW)
        
        case .other:
            
            guard let mode = pManager.mode?.resumeOtherInfo[indexPath.row - 1] else {
                return 0
            }
            mode.isOpen = true
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ResumeOtherCell.self, contentViewWidth: ScreenW)
            
        case .selfEvaludate:
            
            guard let mode = pManager.mode?.estimate, !mode.content.isEmpty else {
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
        switch type {
        case .personInfo:
            return 20
        case .education:
            if let mode = pManager.mode?.educationInfo, mode.count > 0 {
                return 20
            }
        case .works:
            if let mode = pManager.mode?.internInfo, mode.count > 0{
                return 20
            }
        case .project:
            if let mode = pManager.mode?.projectInfo, mode.count > 0{
                return 20
            }
        case .schoolWork:
            if let mode = pManager.mode?.studentWorkInfo, mode.count > 0{
                return 20
            }
        case .practice:
            if let mode = pManager.mode?.practiceInfo, mode.count > 0{
                return 20
            }
        case .skills:
            if let mode = pManager.mode?.skills, mode.count > 0{
               return 20
            }
        case .other:
            if let mode = pManager.mode?.resumeOtherInfo, mode.count > 0{
                return 20
            }
        case .selfEvaludate:
            if let content = pManager.mode?.estimate, !content.content.isEmpty{
                return 20
            }
        default:
            break
        }
            
        return 0
        
        
        
        
       
    }
    
    
    
}
