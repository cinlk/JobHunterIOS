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

    
    
    private var viewType:[resumeViewType] = [.baseInfo,.education,.intern,.skill,.evaluate]
    
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
        table.register(person_educationCell.self, forCellReuseIdentifier: person_educationCell.identity())
        table.register(person_projectCell.self, forCellReuseIdentifier: person_projectCell.identity())
        table.register(person_skillCell.self, forCellReuseIdentifier: person_skillCell.identity())
        table.register(person_evaluateCell.self, forCellReuseIdentifier: person_evaluateCell.identity())
        
        return table
    }()
    // navigation 背景view
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
        table.tableHeaderView = tabHeader
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
        self.loadData()
        
        
        // Do any additional setup after loading the view.
    }

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationItem.title = "简历预览"
        self.navigationController?.view.insertSubview(nagView, at: 1)
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.title = ""
        nagView.removeFromSuperview()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension showResumeVC{
    private func loadData(){
        if let personInfo = pManager.mode?.basicinfo{
            tabHeader.mode = (image: personInfo.tx, name:personInfo.name, introduce:"")
            (nagView.viewWithTag(1) as! UILabel).text = personInfo.name
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
        case .education:
            // 内容cell 和   标题cell
            return (pManager.mode?.educationInfo.count ?? 0) + 1
        case .intern:
            return (pManager.mode?.internInfo.count ?? 0) + 1
        case .skill:
            return (pManager.mode?.skills.count ?? 0) + 1
        default:
            break
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = UITableViewCell()
        cell.selectionStyle = .none
        
        switch viewType[indexPath.section] {
        case .baseInfo:
            if indexPath.row == 0 {
              cell.textLabel?.text = "个人信息"
              return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: resumePersonInfoCell.identity(), for: indexPath) as! resumePersonInfoCell
            cell.mode = pManager.mode?.basicinfo
            return cell
            
        case .education:
            if indexPath.row == 0 {
                cell.textLabel?.text = "教育经历"
                return cell
            }
            
            let cell = table.dequeueReusableCell(withIdentifier: person_educationCell.identity(), for: indexPath) as! person_educationCell
            cell.modifyIcon.isHidden = true 
            cell.mode = pManager.mode?.educationInfo[indexPath.row - 1]
            cell.selectionStyle = .none
            
            return cell
            
        case .intern:
            if indexPath.row == 0 {
                cell.textLabel?.text = "实习经历"
                return cell
            }
            let cell = table.dequeueReusableCell(withIdentifier: person_projectCell.identity(), for: indexPath) as! person_projectCell
            cell.modifyIcon.isHidden = true
            cell.mode = pManager.mode?.internInfo[indexPath.row - 1]
            cell.selectionStyle = .none
            return cell
            
        case .skill:
            if indexPath.row == 0 {
                cell.textLabel?.text = "技能"
                return cell
            }
            let cell = table.dequeueReusableCell(withIdentifier: person_skillCell.identity(), for: indexPath) as! person_skillCell
            cell.modifyIcon.isHidden = true
            cell.mode = pManager.mode?.skills[indexPath.row - 1]
            cell.selectionStyle = .none
            return cell
            
        case .evaluate:
            if indexPath.row == 0 {
                cell.textLabel?.text = "自我评价"
                return cell
            }
            let cell = table.dequeueReusableCell(withIdentifier: person_evaluateCell.identity(), for: indexPath) as! person_evaluateCell
            cell.close = true
            cell.mode = pManager.mode?.estimate
            cell.selectionStyle = .none
            return cell
     
        }
        
        //return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 45
        }
       
        switch viewType[indexPath.section] {
        case .baseInfo:
            // 必须有值
            guard let mode = pManager.mode?.basicinfo  else {
                return 0
            }
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: resumePersonInfoCell.self, contentViewWidth: ScreenW)
            
        case .education:
            guard let mode = pManager.mode?.educationInfo[indexPath.row - 1] else {
                return 0
            }
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_educationCell.self, contentViewWidth: ScreenW)
            
        case .intern:
            guard let mode =  pManager.mode?.internInfo[indexPath.row - 1] else {
                return 0
            }
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_projectCell.self, contentViewWidth: ScreenW)
            
        case .skill:
            guard let mode = pManager.mode?.skills[indexPath.row - 1] else {
                return 0
            }
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: person_skillCell.self, contentViewWidth: ScreenW)
            
        case .evaluate:
            guard let str = pManager.mode?.estimate else {
                return 0
            }
            if str.isEmpty{
                return 0 
            }
            return   tableView.cellHeight(for: indexPath, model: str, keyPath: "mode", cellClass: person_evaluateCell.self, contentViewWidth: ScreenW)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        return
    }
    
    
    // section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    
}
