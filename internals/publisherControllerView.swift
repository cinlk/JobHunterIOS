//
//  publisherControllerView.swift
//  internals
//
//  Created by ke.liang on 2017/12/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

private let tsection = 3
private let tHeaderHeight:CGFloat = 200

class publisherControllerView: BaseTableViewController {

    // MARK:-  不同类型职位
    private var publishJobs:[CompuseRecruiteJobs] = []
    
    
    private lazy var headerView:personTableHeader = {
        let h = personTableHeader.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: tHeaderHeight - NavH))
        h.isHR = true 
        return h
    }()
    
    
    
    private lazy var navigationBack:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        v.backgroundColor = UIColor.navigationBarColor()
        v.alpha = 0
        let title = UILabel.init(frame: CGRect.zero)
        title.text = ""
        title.textAlignment = .center
        title.tag = 1
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        title.font = UIFont.boldSystemFont(ofSize: 16)
        v.addSubview(title)
        _ = title.sd_layout().topSpaceToView(v,25)?.bottomSpaceToView(v,10)?.centerXEqualToView(v)?.autoHeightRatio(0)
        title.setMaxNumberOfLinesToShow(1)
        return v
    }()
    
    
    
    // header 图片背景
    private lazy var bImg:UIImageView = {
       let image = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tHeaderHeight))
       image.clipsToBounds = true
       image.contentMode = .scaleAspectFill
       image.image = UIImage.init(named: "pbackimg")
       return image
    }()
    // tableview 背景view
    private var  bview:UIView = UIView.init(frame: CGRect.zero)
    
    
    internal var mode:HRPersonModel?
    
    internal var companyModel: CompanyModel?
    
    //用id 查询信息
    var userID:String = ""{
        didSet{
            loadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.navigationItem.title = ""
       
        self.navigationController?.removeCustomerView()
        self.navigationController?.view.insertSubview(navigationBack, at: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBack.removeFromSuperview()
        self.navigationController?.view.willRemoveSubview(navigationBack)
        

    }
    
    
    
    override func setViews(){
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib(nibName:"CompanySimpleCell", bundle:nil), forCellReuseIdentifier: CompanySimpleCell.identity())
        self.tableView.register(companySimpleJobCell.self, forCellReuseIdentifier: companySimpleJobCell.identity())
        self.tableView.register(singleTextCell.self, forCellReuseIdentifier: singleTextCell.identity())
        self.setHeader()
        
        self.handleViews.append(bview)
        //self.handleViews.append(self.tableView)
        super.setViews()
        
    }
    
    
    override func didFinishloadData(){
        super.didFinishloadData()
        self.tableView.reloadData()
        
        guard  let mode = mode  else {
            return
        }
        let introduce = mode.company! + "@" + mode.position!
        // icon TEST MARK!
        headerView.mode = (image:  "chicken", name: mode.name!, introduce: introduce)
        (navigationBack.viewWithTag(1) as! UILabel).text = introduce
        
        
    }
    
    override func showError(){
        super.showError()
    }
    
    override func reload(){
        
        super.reload()
        self.loadData()
        
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tsection
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 加载时 不显示cell
        if section == 0  || section == 1{
            return (companyModel != nil ?  1 : 0)
        }
        return publishJobs.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  indexPath.section {
        case 0:
            
             let cell = tableView.dequeueReusableCell(withIdentifier: CompanySimpleCell.identity(), for: indexPath) as! CompanySimpleCell
             cell.mode = companyModel
             return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: singleTextCell.identity(), for: indexPath) as!
            singleTextCell
            
            return cell
            
        case 2:

            let cell = tableView.dequeueReusableCell(withIdentifier: companySimpleJobCell.identity(), for: indexPath) as! companySimpleJobCell
            cell.selectionStyle = .none
            cell.mode =  publishJobs[indexPath.row]
            cell.useCellFrameCache(with: indexPath, tableView: tableView)
            return cell
        default:
            return UITableViewCell.init()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if   indexPath.section == 0 {
           // return  CompanySimpleCell.cellHeight()
            return 60
        }
        
        if indexPath.section == 1{
            return 30
        }
        
        let mode = publishJobs[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: companySimpleJobCell.self, contentViewWidth: ScreenW)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 10))
        v.backgroundColor = UIColor.viewBackColor()
        return v
    }
   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 2 ? 0 : 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch  indexPath.section {
        case 0:
            let com = CompanyMainVC()
            com.companyID  = companyModel?.id
            self.navigationController?.pushViewController(com, animated: true)
        case 1:
            
            let mode = publishJobs[indexPath.row]
            let jd = JobDetailViewController()
            jd.uuid = mode.id!
            //jd.kind = (id: mode.id!, type: mode.kind!)
            self.navigationController?.pushViewController(jd, animated: true)
            
        default:
            break
        }
    }

}



extension publisherControllerView{
    private func setHeader(){
        
        let th = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tHeaderHeight))
        th.backgroundColor = UIColor.clear
        self.tableView.tableHeaderView = th
        // 用bview来管理headerview，并根据滑动拉伸headerview
        bview.frame = self.view.frame
        bview.addSubview(bImg)
        bview.addSubview(headerView)
        self.tableView.backgroundView = bview
    
    }
    
}


// 异步获取数据
extension publisherControllerView{
    
    
    // MARK:
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            
            
       
            
            // 2 获取ta 发布的职位
            Thread.sleep(forTimeInterval: 2)
            for _ in 0..<20{
                
               
                guard let jobData = CompuseRecruiteJobs(JSON: ["id":"dqwdqw-dqwd","type":"intern","benefits":"六险一金,鹅肠大神,海外手游扥等扥","name":"助理","address":["北京玉渊潭公园"],"create_time":Date().timeIntervalSince1970 - TimeInterval(2423),"applyEndTime":Date().timeIntervalSince1970,"education":"本科","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false, "company":["id":"dqwd","name":"公司名称","isCollected":false,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"]]) else {
                    continue
                }
               
                
                
                self?.publishJobs.append(jobData)
            }
            
            //
            self?.companyModel = CompanyModel(JSON:["id":"dqwd","name":"公司名称","isCollected":false,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"])!
            self?.mode = HRPersonModel(JSON:["userID":"dqwd","name":"我是hr","position":"HRBP","ontime": Date().timeIntervalSince1970 - TimeInterval(6514),"icon": #imageLiteral(resourceName: "jing").toBase64String(),"company":"公司名称","role":"招聘者"])!
            
            
            
            DispatchQueue.main.async(execute: {
                
                self?.didFinishloadData()
            })
            
            
        }
        
      
        
    }
}

// 滑动效果
extension publisherControllerView{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var frame = self.bImg.frame
        var hframe = self.headerView.frame
        
        // 0 到 tHeaderHeight直接距离，headerview 向上移动
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < tHeaderHeight{
            hframe.origin.y = NavH - scrollView.contentOffset.y
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
            if scrollView.contentOffset.y < 64{
                  navigationBack.alpha = scrollView.contentOffset.y / CGFloat(64)
                
            }else if scrollView.contentOffset.y >= 64{
                 navigationBack.alpha  = 1
            }
        }else if scrollView.contentOffset.y >= tHeaderHeight{
            // 取消header section 悬浮
            scrollView.contentInset = UIEdgeInsets(top: -tHeaderHeight, left: 0, bottom: 0, right: 0)
        }
            // 下拉 图片放大，固定y坐标
        else{
            frame.origin.y = 0
            frame.size.height = tHeaderHeight - scrollView.contentOffset.y
            navigationBack.alpha = 0
            // 变化速度
            hframe.origin.y = NavH - scrollView.contentOffset.y / 2
        }
        self.bImg.frame = frame
        self.headerView.frame = hframe
       
    }
}



private class singleTextCell:UITableViewCell{
    
    private lazy var content:UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.text = "发布的职位"
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return label
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(content)
        _ = content.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.autoHeightRatio(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "singleTextCell"
    }
}

