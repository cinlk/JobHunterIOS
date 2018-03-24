//
//  jobstatusView.swift
//  internals
//
//  Created by ke.liang on 2017/10/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let JobViewH:CGFloat =  120
fileprivate let DescribeViewH:CGFloat =  70
fileprivate let iconSize:CGSize = CGSize.init(width: 45, height: 45)

class jobstatusView: UIViewController {


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
        table.register(UINib(nibName:"statustage", bundle:nil), forCellReuseIdentifier: "bottom")
       // table.tableHeaderView = self.jobHeader
        table.tableFooterView =  UIView()
        table.separatorStyle = .none
        return table
        
    }()
    
    private lazy var navigationBackView:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        // naviagtionbar 默认颜色
        v.backgroundColor = UIColor.navigationBarColor()
        
        return v
    }()
    
    private lazy var record:[[String]] = []
    
    var mode:DeliveredJobsModel?{
        didSet{
            record =  mode?.records ?? []
            //self.describle.contentLabel.text = mode?.response?["des"] ?? ""
            jobHeader.mode = mode
            // 这才计算完header 布局后的高度, 在赋值给table
            jobHeader.layoutSubviews()
            table.tableHeaderView = jobHeader
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
         self.navigationController?.view.insertSubview(navigationBackView, at: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBackView.removeFromSuperview()
        self.navigationController?.view.willRemoveSubview(navigationBackView)
    }

}

extension jobstatusView{
    @objc func choose(_ gest:UITapGestureRecognizer){
        let  job = JobDetailViewController()
        //job.infos = ["JobName":"测试","address":"北京","salary":"50万"]
        self.navigationController?.pushViewController(job, animated: true)
        
        
    }
    
}


extension jobstatusView:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return record.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: feedBackCell.identity(), for: indexPath) as! feedBackCell
            cell.mode = mode?.response?["des"] ?? ""
            return cell
        }
        
        
        guard record.count > 0 else {
            return UITableViewCell.init()
        }
        
      
        
        if let  cell = table.dequeueReusableCell(withIdentifier: "bottom", for: indexPath) as? statustage{
        
            if record.count - 1  == 0{
            
                cell.status.text =  record[0].first
                cell.time.text  = record[0].last
                cell.logo.image =  #imageLiteral(resourceName: "checked")
            
            }else{
                let data = record[indexPath.row]
                cell.logo.image = #imageLiteral(resourceName: "unchecked")
                cell.status.text = data[0]
                cell.time.text = data[1]
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
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init()
        v.backgroundColor = UIColor.viewBackColor()
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            let des = mode?.response?["des"] ?? ""
            return tableView.cellHeight(for: indexPath, model: des, keyPath: "mode", cellClass: feedBackCell.self, contentViewWidth: ScreenW)
        }
        return 60
        
    }
    
    
}

extension jobstatusView{
    
    // 跳转job详细界面
    @objc func showJob(){
        let jobV = JobDetailViewController()
        jobV.mode = CompuseRecruiteJobs(JSON: mode!.toJSON())
        self.navigationController?.pushViewController(jobV, animated: true)
    }
}



@objcMembers fileprivate  class feedBackCell:UITableViewCell{
    
    
    private lazy var leftLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.text = "投递反馈: "
        return label
    }()
    
    
    private lazy var rightLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 110)
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        return label
    }()
    
    private lazy var type:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        return label
    }()
    
    var mode:DeliveredJobsModel?{
        didSet{
            icon.image = UIImage.init(named: mode?.picture ?? "default")
            jobName.text = mode?.jobName
            company.text = mode?.company
            address.text = mode?.address
            type.text = mode?.type
            
            self.setupAutoHeight(withBottomView: address, bottomMargin: 10)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [icon,jobName, company, address, type]
        self.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,10)?.widthIs(iconSize.width)?.heightIs(iconSize.height)
        _ = jobName.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = company.sd_layout().leftEqualToView(jobName)?.topSpaceToView(jobName,5)?.autoHeightRatio(0)
        _ = address.sd_layout().leftEqualToView(jobName)?.topSpaceToView(company,5)?.autoHeightRatio(0)
        _ = type.sd_layout().leftSpaceToView(address,10)?.topEqualToView(address)?.autoHeightRatio(0)
        
        jobName.setMaxNumberOfLinesToShow(1)
        company.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
        type.setMaxNumberOfLinesToShow(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.white
    }
}







