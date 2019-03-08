//
//  jobstatusView.swift
//  internals
//
//  Created by ke.liang on 2017/10/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let iconSize:CGSize = CGSize.init(width: 45, height: 45)
fileprivate let cellIdentity:String = "status"


class DetailDeliveryStatus: UIViewController {

   private  lazy var jobHeader:tableHeaderView = {  [unowned self] in
        let head = tableHeaderView.init(frame: CGRect.zero)
        let tap = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(showJob))
        head.addGestureRecognizer(tap)
        return head
        
    }()
    
    
    private lazy var table:UITableView = { [unowned self] in
        
        let table = UITableView.init(frame: CGRect.zero)
        table.backgroundColor = UIColor.viewBackColor()
        table.delegate = self
        table.dataSource = self
        table.register(feedBackCell.self, forCellReuseIdentifier: feedBackCell.identity())
        table.register(UINib(nibName:"statustage", bundle:nil), forCellReuseIdentifier: cellIdentity)
        table.tableFooterView =  UIView()
        table.separatorStyle = .none
        return table
        
    }()
    
    
    private lazy var record:[(status:String,time:String)] = []
    
    var mode:DeliveredJobsModel?{
        didSet{
            
            guard let mode = mode else {
                return
            }
            jobHeader.mode = mode
            // 这才计算完header 布局后的高度, 在赋值给table
            jobHeader.layoutSubviews()
            table.tableHeaderView = jobHeader
            // 投递历史状态
            if let status = mode.historyStatus{
                record = status
            }else{
                record = [(status:mode.currentStatus!, time:mode.createTimeStr)]
            }
            
            self.table.reloadData()
        }
    }
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "历史记录"
        self.view.addSubview(table)
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
        
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 
    }

}



extension DetailDeliveryStatus:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : record.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: feedBackCell.identity(), for: indexPath) as! feedBackCell
            cell.mode = mode?.feedBack
            return cell
        }
        
        
        guard record.count > 0 else {
            return UITableViewCell.init()
        }
        
      
        
        if let  cell = table.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath) as? statustage{
        
            // 当前是有一个状态
            if record.count - 1  == 0{
            
                cell.status.text =  record[0].status
                cell.time.text  = record[0].time
                cell.logo.image =  #imageLiteral(resourceName: "checked")
            
            // 最新状态放前面(倒序)
            }else{
                let data = record[indexPath.row]
                cell.logo.image = #imageLiteral(resourceName: "unchecked")
                cell.status.text = data.status
                cell.time.text = data.time
                
                // 最后一个cell
                if indexPath.row  == record.count - 1{
                
                    cell.upline.isHidden = false
                }else if indexPath.row == 0{
                    cell.logo.image = #imageLiteral(resourceName: "checked")
                    cell.downline.isHidden = false
                }else{
                    cell.upline.isHidden = false
                    cell.downline.isHidden = false
                }
            
            }
        
            return cell
        }
        
        return UITableViewCell.init()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            let feedback = mode?.feedBack
            return  tableView.cellHeight(for: indexPath, model: feedback, keyPath: "mode", cellClass: feedBackCell.self, contentViewWidth: GlobalConfig.ScreenW)
        }
        
        return 60
        
    }
    
    
   
    // section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
 
    
    
}




extension DetailDeliveryStatus{
    
    // 跳转job详细界面 (校招，实习， 网申) MARK
    @objc func showJob(){
        guard  let mode = mode  else {
            return
        }
        if mode.jobtype == .onlineApply{
            let apply = OnlineApplyShowViewController()
            //apply.onlineApplyID = "test-id"
            apply.uuid = "trhtr765765"
            self.navigationController?.pushViewController(apply, animated: true)
            
        }else if mode.jobtype == .graduate || mode.jobtype == .intern{
            let jobV = JobDetailViewController()
           
            jobV.job = (mode.id ?? "", mode.jobtype)
            //jobV.kind = (id: mode.id!, type: mode.jobtype)
            self.navigationController?.pushViewController(jobV, animated: true)
        }
    }
}




@objcMembers fileprivate  class feedBackCell:UITableViewCell{
    
    
    private lazy var feedBack:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 20)
        label.isAttributedContent = true
        
        return label
    }()
    
    
    dynamic var mode:String?{
        didSet{
            let attr = NSMutableAttributedString.init(string: "投递反馈: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
            attr.append(NSAttributedString.init(string: mode ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            self.feedBack.attributedText = attr
            self.setupAutoHeight(withBottomView: feedBack, bottomMargin: 5)
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(feedBack)
        self.selectionStyle = .none 
        _ = feedBack.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
      
        feedBack.setMaxNumberOfLinesToShow(-1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "feedBackCell"
    }
}

private class tableHeaderView:UIView{
    
    
    private lazy var icon:UIImageView = {
        let img = UIImageView.init()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    // 右箭头
    private lazy var rightArrow:UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        img.image = #imageLiteral(resourceName: "forward").changesize(size: CGSize.init(width: 15, height: 15))
        return img
    }()
    
    private lazy var jobName:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
        return label
    }()
    
    private lazy var company:UILabel = {
        let company = UILabel.init()
        company.font = UIFont.systemFont(ofSize: 14)
        company.textAlignment = .left
        company.textColor = UIColor.black
        company.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
        return company
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
        return label
    }()
    
    
    var mode:DeliveredJobsModel?{
        didSet{
            guard let mode = mode else {
                return
            }
            icon.image = UIImage.init(named: mode.icon)
            jobName.text = mode.title
            company.text = mode.companyName
            address.text =  mode.address?.joined(separator: " ")
           
            self.setupAutoHeight(withBottomView: address, bottomMargin: 5)
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [icon, rightArrow, jobName, company, address]
        self.sd_addSubviews(views)
        
        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = rightArrow.sd_layout().rightSpaceToView(self,5)?.centerYEqualToView(self)?.widthIs(15)?.heightEqualToWidth()
        
        _ = jobName.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = company.sd_layout().leftEqualToView(jobName)?.topSpaceToView(jobName,5)?.autoHeightRatio(0)
        _ = address.sd_layout().leftEqualToView(jobName)?.topSpaceToView(company,5)?.autoHeightRatio(0)
        jobName.setMaxNumberOfLinesToShow(1)
        company.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(2)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.white
    }
    
}







