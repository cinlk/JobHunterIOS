//
//  companyDetailVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit




fileprivate let headerViewH:CGFloat =  100
fileprivate let sections:Int = 3
fileprivate var sectionHeight:CGFloat = 10



class CompanyDetailVC: UIViewController {
    
    lazy var detailTable:UITableView = { [unowned self] in
        
        let tb = UITableView.init(frame: CGRect.zero)
        tb.tableFooterView = UIView.init()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.delegate = self
        tb.dataSource = self
        tb.contentInsetAdjustmentBehavior = .never
        tb.separatorStyle = .none
        //tb.bounces = false
        // 底部内容距离底部高60，防止回弹底部内容被影藏
        let head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: headerViewH))
        head.backgroundColor = UIColor.viewBackColor()
        tb.tableHeaderView = head
        
        tb.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        // cell
        tb.register(tagsTableViewCell.self, forCellReuseIdentifier: "tagsTableViewCell")
        tb.register(introductionCell.self, forCellReuseIdentifier: "introductionCell")
        tb.register(CompanyDetailCell.self, forCellReuseIdentifier: "CompanyDetailCell")
        
        return tb
        
    }()
    
    // deleagte
    weak var delegate:CompanySubTableScrollDelegate?
    
    
    var detailModel:CompanyModel?{
        didSet{
            self.detailTable.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        //loadData()
        
    }

    private func setViews() {
        
        self.view.addSubview(detailTable)
        _ = detailTable.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }
    
    
    

}



extension CompanyDetailVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  sections
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        
        case 0:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "tagsTableViewCell", for: indexPath) as! tagsTableViewCell
            cell.tags = detailModel?.tags  ?? [""]
            return cell
            
        case 1:
            let cell  = tableView.dequeueReusableCell(withIdentifier: "introductionCell", for: indexPath) as! introductionCell
            cell.des = detailModel?.describe  ?? ""
            return cell
        case 2:
            //let comp = CompanyDetail(address: "地址 北京 - 定位", webSite: "https://www.baidu.com")
            
            let cell  = tableView.dequeueReusableCell(withIdentifier: "CompanyDetailCell", for: indexPath) as! CompanyDetailCell
            cell.comp = detailModel
            return cell
            
        default:
            break
            
        }
        
        return UITableViewCell()
        
        
    }
    
    // section 高度
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        switch indexPath.section {
        case 0:
            let tags =  detailModel?.tags ?? []
            return tableView.cellHeight(for: indexPath, model: tags, keyPath: "tags", cellClass: tagsTableViewCell.self, contentViewWidth: ScreenW)
        case 1:
            let des  = detailModel?.describe ?? ""
            return tableView.cellHeight(for: indexPath, model: des, keyPath: "des", cellClass: introductionCell.self, contentViewWidth: ScreenW)
        case 2:
            if let cMode = detailModel{
                return tableView.cellHeight(for: indexPath, model: cMode, keyPath: "comp", cellClass: CompanyDetailCell.self, contentViewWidth: ScreenW)
            }
        default:
            break
        }

        return 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}


extension CompanyDetailVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        // 向上滑动
        if offsetY > 0 {
             delegate?.scrollUp(view: self.detailTable, height: offsetY)
        }else{
             delegate?.scrollUp(view: self.detailTable, height: 0)
        }
        
       
    }
}
