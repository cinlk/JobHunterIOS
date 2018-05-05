//
//  publisherControllerView.swift
//  internals
//
//  Created by ke.liang on 2017/12/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

private let tsection = 2
private let tHeaderHeight:CGFloat = 200

class publisherControllerView: BaseTableViewController {

    // MARK:-  不同类型职位
    private var publishJobs:[CompuseRecruiteJobs] = []
    
    private lazy var jd:JobDetailViewController = JobDetailViewController()
    
    private lazy var headerView:personTableHeader = {
        let h = personTableHeader.init(frame: CGRect.init(x: 0, y: 80, width: ScreenW, height: tHeaderHeight - 80))
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
    
    
    var mode:HRInfo?{
        didSet{
             headerView.mode = (image:mode?.icon ?? "", name: mode?.name ?? "", introduce: "C公司@HR")
             (navigationBack.viewWithTag(1) as! UILabel).text = "C公司@HR"
        }
    }
    
    //
    var userID:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.navigationItem.title = ""
       
        self.navigationController?.view.insertSubview(navigationBack, at: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBack.removeFromSuperview()
        self.navigationController?.view.willRemoveSubview(navigationBack)
        
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = self.tableView.tableHeaderView?.sd_layout().topEqualToView(self.tableView)?.leftEqualToView(self.tableView)?.rightEqualToView(self.tableView)?.heightIs(tHeaderHeight)
        
    }
    
    
    override func setViews(){
        
        // 导航的view 为白色,tableview 是该vc的第一个view
        self.navigationController?.view.backgroundColor = UIColor.white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(UINib(nibName:"CompanySimpleCell", bundle:nil), forCellReuseIdentifier: "companyCell")
        self.tableView.register(companyJobCell.self, forCellReuseIdentifier: companyJobCell.identity())
        self.setHeader()
        
        self.handleViews.append(tableView)
        super.setViews()
        
    }
    
    
    override func didFinishloadData(){
        super.didFinishloadData()
        self.tableView.reloadData()
        self.mode = HRInfo(name: "测试---", position: "测试---", lastLogin: "02-21号", icon: "jodel")
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
        return  section == 0 ? 1 : publishJobs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  indexPath.section {
        case 0:
             let cell = tableView.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath) as! CompanySimpleCell
             cell.mode = (image: "sina", companyName:"公司x", tags:"行业|地点|人数ring")
             return cell
        case 1:

            let cell = tableView.dequeueReusableCell(withIdentifier: companyJobCell.identity(), for: indexPath) as! companyJobCell
            cell.mode =  publishJobs[indexPath.row]
            cell.useCellFrameCache(with: indexPath, tableView: tableView)
            return cell
        default:
            return UITableViewCell.init()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if   indexPath.section == 0 {
            return  CompanySimpleCell.cellHeight()
        }
        
        let mode = publishJobs[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: companyJobCell.self, contentViewWidth: ScreenW)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 10))
        v.backgroundColor = UIColor.viewBackColor()
        return v
    }
   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  indexPath.section {
        case 0:
            let comp = CompanyMainVC()
            comp.companyID  = "dqwdqw-324"
            self.navigationController?.pushViewController(comp, animated: true)
        case 1:
            
            jd.jobID = publishJobs[indexPath.row].id!
            self.navigationController?.pushViewController(jd, animated: true)
        default:
            break
        }
    }

}



extension publisherControllerView{
    private func setHeader(){
        
        let th = UIView.init(frame: CGRect.zero)
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
            
            // 1 查询hr信息 mode
            self?.userID = "4234-53453"
            // 2 获取ta 发布的职位
            Thread.sleep(forTimeInterval: 3)
            for _ in 0..<20{
                let json =  ["id":"dwqd","jobName":"在线讲师","address":"北京","picture":"sina","type":"compuse","degree":"不限","create_time":"09:45","salary":"面议","tag":"市场","education":"本科"]
               
                
                self?.publishJobs.append(Mapper<CompuseRecruiteJobs>().map(JSON: json)!)
            }
            
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
            hframe.origin.y = 80 - scrollView.contentOffset.y
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
            if scrollView.contentOffset.y < 64{
                  navigationBack.alpha = scrollView.contentOffset.y / CGFloat(64)
                
            }else if scrollView.contentOffset.y >= 64{
                 navigationBack.alpha  = 1
            }
        }else if scrollView.contentOffset.y >= tHeaderHeight{
            // 取消header section 悬浮
            scrollView.contentInset = UIEdgeInsetsMake(-tHeaderHeight, 0, 0, 0)
        }
            // 下拉 图片放大，固定y坐标
        else{
            frame.origin.y = 0
            frame.size.height = tHeaderHeight - scrollView.contentOffset.y
            navigationBack.alpha = 0
            // 变化速度
            hframe.origin.y = 80 - scrollView.contentOffset.y / 2
        }
        self.bImg.frame = frame
        self.headerView.frame = hframe
       
    }
}

