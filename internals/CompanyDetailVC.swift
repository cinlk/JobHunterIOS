//
//  companyDetailVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


// 与companyMainVC 一致
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
        let head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: CompanyMainVC.headerViewH))
        head.backgroundColor = UIColor.viewBackColor()
        tb.tableHeaderView = head
        
        tb.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        // cell
        tb.register(feedBackTypeCell.self, forCellReuseIdentifier: feedBackTypeCell.identity())
        tb.register(contentAndTitleCell.self, forCellReuseIdentifier: contentAndTitleCell.identity())
        tb.register(worklocateCell.self, forCellReuseIdentifier: worklocateCell.identity())
        tb.register(subIconAndTitleCell.self, forCellReuseIdentifier: subIconAndTitleCell.identity())
        
        return tb
        
    }()
    
    // deleagte
    weak var delegate:CompanySubTableScrollDelegate?
    
    private lazy var tap :UIGestureRecognizer  = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(open))
        
        return tap
    }()
    
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
        if let web = detailModel?.webSite, !web.isEmpty{
            return sections + 1
        }
        return   sections
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        
        case 0:
            let cell  = tableView.dequeueReusableCell(withIdentifier: feedBackTypeCell.identity(), for: indexPath) as! feedBackTypeCell
            cell.collectionView.isUserInteractionEnabled = false
            
            cell.mode = detailModel?.tags  ?? []
            return cell
            
        case 1:
            let cell  = tableView.dequeueReusableCell(withIdentifier: contentAndTitleCell.identity(), for: indexPath) as! contentAndTitleCell
            cell.des = detailModel?.describe  ?? ""
            return cell
        case 2:
            let cell  = tableView.dequeueReusableCell(withIdentifier: worklocateCell.identity(), for: indexPath) as! worklocateCell
            cell.mode = detailModel?.address
            
            return cell
        
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: subIconAndTitleCell.identity(), for: indexPath) as! subIconAndTitleCell
            
            cell.content.isUserInteractionEnabled = true
            cell.content.attributedText = NSAttributedString.init(string: (detailModel?.webSite)!, attributes: [NSAttributedStringKey.foregroundColor:UIColor.blue, NSAttributedStringKey.link: URL(string: (detailModel?.webSite)!)!])
            cell.content.addGestureRecognizer(tap)
            //cell.mode = detailModel?.webSite
            cell.icon.image  = #imageLiteral(resourceName: "link")
            cell.iconName.text = "公司网址"
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
            return tableView.cellHeight(for: indexPath, model: tags, keyPath: "mode", cellClass: feedBackTypeCell.self, contentViewWidth: ScreenW)
        case 1:
            let des  = detailModel?.describe ?? ""
            return tableView.cellHeight(for: indexPath, model: des, keyPath: "des", cellClass: contentAndTitleCell.self, contentViewWidth: ScreenW)
        case 2:
           
            return tableView.cellHeight(for: indexPath, model: detailModel?.address, keyPath: "mode", cellClass: worklocateCell.self, contentViewWidth: ScreenW)
            
        case 3:
            let mode = detailModel?.webSite
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: subIconAndTitleCell.self, contentViewWidth: ScreenW) + 20
            
            
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

extension CompanyDetailVC{
    @objc private func open(){
        
        openApp(appURL: (detailModel?.webSite)!, completion:{
            bool in
            
        })
    }
}
