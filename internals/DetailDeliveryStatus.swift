//
//  jobstatusView.swift
//  internals
//
//  Created by ke.liang on 2017/10/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let DescribeViewH:CGFloat =  70
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
        
        self.navigationItem.title  = "投递记录"
        self.view.addSubview(table)
       
        
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
        
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
            return  tableView.cellHeight(for: indexPath, model: feedback, keyPath: "mode", cellClass: feedBackCell.self, contentViewWidth: ScreenW)
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
        let jobV = JobDetailViewController()
        jobV.jobID = (mode?.id)!
        self.navigationController?.pushViewController(jobV, animated: true)
    }
}




@objcMembers fileprivate  class feedBackCell:UITableViewCell{
    
    
    private lazy var leftLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.setSingleLineAutoResizeWithMaxWidth(120)
        label.text = "投递反馈: "
        return label
    }()
    
    // 反馈描述
    private lazy var rightLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 100)
        return label
    }()
    
    dynamic var mode:String?{
        didSet{
            rightLabel.text = mode ?? ""
            self.setupAutoHeight(withBottomViewsArray: [leftLabel, rightLabel], bottomMargin: 5)
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightLabel)
        _ = leftLabel.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        _ = rightLabel.sd_layout().leftSpaceToView(leftLabel,10)?.topEqualToView(leftLabel)?.autoHeightRatio(0)
        
        rightLabel.setMaxNumberOfLinesToShow(3)
        
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
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        return label
    }()
    
    private lazy var company:UILabel = {
        let company = UILabel.init()
        company.font = UIFont.systemFont(ofSize: 16)
        company.textAlignment = .left
        company.textColor = UIColor.black
        company.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        return company
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        return label
    }()
    
    // 行业类型
    private lazy var business:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
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
            business.text = mode.business?.joined(separator: " ")
           
            setView(type: mode.jobtype)
            
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [icon, rightArrow, jobName, company, address, business]
        self.sd_addSubviews(views)
        
        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,10)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = rightArrow.sd_layout().rightSpaceToView(self,10)?.centerYEqualToView(self)?.widthIs(15)?.heightEqualToWidth()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.white
    }
    
    private func setView(type:jobType){
        
    
       
        switch type {
        case .intern, .graduate:
            
              _ = jobName.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
              _ = company.sd_layout().leftEqualToView(jobName)?.topSpaceToView(jobName,5)?.autoHeightRatio(0)
              _ = address.sd_layout().leftEqualToView(jobName)?.topSpaceToView(company,5)?.autoHeightRatio(0)
              jobName.setMaxNumberOfLinesToShow(1)

              self.setupAutoHeight(withBottomViewsArray: [icon, address], bottomMargin: 10)
            
            
        case .onlineApply:
            
              _ = company.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
              _ = address.sd_layout().leftEqualToView(company)?.topSpaceToView(company,5)?.autoHeightRatio(0)
              _ = business.sd_layout().leftEqualToView(address)?.topSpaceToView(address,5)?.autoHeightRatio(0)
              business.setMaxNumberOfLinesToShow(2)
              
              self.setupAutoHeight(withBottomViewsArray: [icon, business], bottomMargin: 10)

        default:
            return
        }
        
        company.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(2)
        
        
    }
}







