//
//  publisherControllerView.swift
//  internals
//
//  Created by ke.liang on 2017/12/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
private let tsection = 2
private let tHeaderHeight:CGFloat = 200

class publisherControllerView: UITableViewController {

    var infos:Dictionary<String,Any>?
    var publishJobs:[Dictionary<String,String>] = []
    
    lazy var headerView:personTableHeader = {
        let h = personTableHeader.init(frame: CGRect.init(x: 0, y: 80, width: ScreenW, height: tHeaderHeight - 80))
        h.isHR = true 
        return h
    }()
    
    lazy var navigationBack:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 64))
        v.backgroundColor = UIColor.lightGray
        v.alpha = 0
        let title = UILabel.init(frame: CGRect.zero)
        title.text = "吊袜带挖打我@吊袜带挖达到无"
        title.textAlignment = .center
        title.sizeToFit()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        v.addSubview(title)
        _ = title.sd_layout().topSpaceToView(v,25)?.bottomSpaceToView(v,10)?.centerXEqualToView(v)
        return v
    }()
    
    // back img
    lazy var bImg:UIImageView = {
       let image = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tHeaderHeight))
       image.clipsToBounds = true
       image.contentMode = .scaleAspectFill
       image.image = UIImage.init(named: "pbackimg")
       return image
    }()
    private var  bview:UIView = UIView.init(frame: CGRect.zero)
    
    
    
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.loadData()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self 
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
        self.tableView.tableFooterView = UIView.init()
        
        self.tableView.register(UINib(nibName:"company", bundle:nil), forCellReuseIdentifier: "companycell")
        self.tableView.register(companyJobCell.self, forCellReuseIdentifier: companyJobCell.identity())
        
        self.navigationItem.title = ""
        self.setHeader()
 
       
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tsection
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  section == 0 ? 1 : publishJobs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  indexPath.section {
        case 0:
             let cell = tableView.dequeueReusableCell(withIdentifier: "companycell", for: indexPath) as! company
             cell.cimage.image = #imageLiteral(resourceName: "sina")
             cell.name.text = "公司名称"
             cell.infos.text = "行业|地点|人数"
             return cell
        case 1:

            let cell = tableView.dequeueReusableCell(withIdentifier: companyJobCell.identity(), for: indexPath) as! companyJobCell
            cell.setLabel(item: publishJobs[indexPath.row])
            return cell
        default:
            return UITableViewCell.init()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  indexPath.section == 0 ? company.cellHeight() : companyJobCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 5))
        v.backgroundColor = UIColor.lightGray
        return v
    }
   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch  indexPath.section {
        case 0:
            let comp = companyscrollTableViewController()
            self.navigationController?.pushViewController(comp, animated: true)
        case 1:
            let job = JobDetailViewController()
            job.infos = publishJobs[indexPath.row]
            self.navigationController?.pushViewController(job, animated: true)
        default:
            break
        }
    }

}

extension publisherControllerView{
    private func setHeader(){
        headerView.avatarImg.image = UIImage.init(named: "jodel")
        headerView.nameTitle.text = "白飞翔"
        headerView.introduce.text = "C公司@HR"
        //headerView.frame =  CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: tHeaderHeight - 80)
        let th = UIView.init(frame: CGRect.zero)
        th.backgroundColor = UIColor.clear
        self.tableView.tableHeaderView = th
        
        bview.frame = self.view.frame
        bview.addSubview(bImg)
        bview.addSubview(headerView)
        self.tableView.backgroundView = bview
    
    }
    
    private func loadData(){
        
        for _ in 0..<20{
            publishJobs.append(["jobName":"在线讲师","address":"北京","type":"校招","degree":"不限","create_time":"09:45","salary":"面议","tag":"市场"])
        }
       
    }
}


// 滑动效果
extension publisherControllerView{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var frame = self.bImg.frame
        var hframe = self.headerView.frame
        
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
            // 下拉 图片放大？
        else{
            frame.origin.y = 0
            frame.size.height = tHeaderHeight - scrollView.contentOffset.y
            navigationBack.alpha = 0
            hframe.origin.y = 80 - scrollView.contentOffset.y / 2
        }
        self.bImg.frame = frame
        self.headerView.frame = hframe
       
    }
}

