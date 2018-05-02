//
//  companyJobsVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let headerViewH:CGFloat =  100
fileprivate let sections:Int = 2
fileprivate let sectionHeight:CGFloat = 10

class CompanyJobsVC: BaseViewController {

    
    
    // 公司id
    var companyID:String?
    
    // 展示所有职位
    private lazy var filterJobs:[Any]? = []

    private lazy var tags:[String] = ["全部"]
    // 校招和实习职位
    private var mode:[CompuseRecruiteJobs] = [] {
        didSet{
            mode.forEach{
                // 添加tag
                $0.tag.forEach{
                    if tags.contains($0) == false{
                        tags.append($0)
                    }
                }
            }
            
        }
    }
    
    // 网申职位
    private var onlineApply:[OnlineApplyModel] = []{
        didSet{
            
            tags.append("网申")
        }
    }
    
    
    // 宣讲会
    private var meeting:[CareerTalkMeetingModel] = []{
        didSet{
            tags.append("宣讲会")
        }
    }
    
    
    
    lazy var joblistTable:UITableView = {
        //let tb = UITableView.init(frame: CGRect.init(x: ScreenW, y: 0, width: ScreenW, height: ScreenH))
        let tb = UITableView.init(frame: CGRect.zero)
        
        tb.tableFooterView = UIView.init()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .singleLine
        //tb.bounces = false
        tb.contentInsetAdjustmentBehavior = .never
        let head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: headerViewH))
        head.backgroundColor = UIColor.viewBackColor()
        tb.tableHeaderView = head
        tb.register(JobTagsCell.self, forCellReuseIdentifier: JobTagsCell.identity())
        tb.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        // 网申
        tb.register(OnlineApplyCell.self, forCellReuseIdentifier: OnlineApplyCell.identity())
        // 宣讲会
        tb.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        
        return tb
    }()
    
    
    // deleagte
    weak var delegate:CompanySubTableScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        //监听job 的tag 变化 刷新第二个table
        NotificationCenter.default.addObserver(self, selector: #selector(filterJoblist(notify:)), name: NSNotification.Name.init("whichTag"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func setViews() {
        self.view.addSubview(joblistTable)
        _ = joblistTable.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        self.handleViews.append(joblistTable)
        super.setViews()
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
        self.joblistTable.reloadData()
    }
    
    override func showError() {
        super.showError()
        
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }

}

extension CompanyJobsVC{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            // 网申
            let onlines = [OnlineApplyModel(JSON: ["id":"fq-4320-dqwd","companyModel":["id":"dqw-dqwd","name":"公司名",
                                                                                       "college":"北京大学","describe":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n","address":["地址1","地址2"],"icon":"sina","type":["教育","医疗","化工"],"webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的当前","当前为多","迭代器","群无多当前为多群当前","达瓦大群无多", "当前为多当前的群","当前为多无", "当前为多群无多","杜德伟七多"],"isValidate":true,"isCollected":true,],"end_time":"2017","start_time":"2018","positionAddress":["成都","重庆"],"content":"dqwdqwdqwddqwdqwdqwddqwdqwdqwddqwdqwdqwdqwdqwdwqdqwdqwdqw","outer":true,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              "majors":["土木工程","软件工程","其他"],"positions":["设计","测试","销售"],"link":"http://campus.51job.com/padx2018/index.html","isApply":false,"isValidate":true,"isCollected":true,"name":"网申测试"])!,
                           OnlineApplyModel(JSON: ["id":"fq-4320-dqwd","companyModel":["id":"dqw-dqwd","name":"公司名",
                                                                                       "college":"北京大学","describe":"大哇多无多首先想到的束减速的代理方法scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n","address":["地址1","地址2"],"icon":"sina","type":["教育","医疗","化工"],"webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的当前","当前为多","迭代器","群无多当前为多群当前","达瓦大群无多", "当前为多当前的群","当前为多无", "当前为多群无多","杜德伟七多"],"isValidate":true,"isCollected":true,],"end_time":"2017","start_time":"2018","positionAddress":["成都","重庆"],"content":"dqwdqwdqwddqwdqwdqwddqwdqwdqwddqwdqwdqwdqwdqwdwqdqwdqwdqw","outer":true,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              "majors":["土木工程","软件工程","其他"],"positions":["设计","测试","销售"],"link":"http://campus.51job.com/padx2018/index.html","isApply":false,"isValidate":true,"isCollected":true,"name":"网申测试"])! ]
            
            self?.onlineApply = onlines
            
            // 宣讲会
            
            let meetings = [CareerTalkMeetingModel(JSON: ["id":"dqw-dqwd","companyModel":["id":"com-dqwd-5dq",
                                                                                          "icon":"sina","name":"公司名字","describe":"达瓦大群-dqwd","isValidate":true,"isCollected":false],
                                                          "college":"北京大学","address":"教学室二"
                ,"isValidate":true,"isCollected":false,"icon":"car","start_time":Date().timeIntervalSince1970,
                 "name":"北京高华证券有限责任公司宣讲会但钱当前无多群","source":"上海交大",
                 "content":"举办方：电院举办时间：2018年4月25日 18:00~20:00  \n举办地点：上海交通大学 - 上海市东川路800号电院楼群3-100会议室 单位名称：北京高华证券有限责任公司 联系方式：专业要求：不限、信息安全类、自动化类、计算机类、电子类、软件工程类"])!,
                            CareerTalkMeetingModel(JSON: ["id":"dqw-dqwd","companyModel":["id":"com-dqwd-5dq",
                                                                                          "icon":"sina","name":"公司名字","describe":"达瓦大群-dqwd","isValidate":true,"isCollected":false],
                                                          "college":"北京大学","address":"教学室二"
                                ,"isValidate":true,"isCollected":false,"icon":"car","start_time":Date().timeIntervalSince1970,
                                 "name":"北京高华证券有限责任公司宣讲会但钱当前无多群","source":"上海交大",
                                 "content":"举办方：电院举办时间：2018年4月25日 18:00~20:00  \n举办地点：上海交通大学 - 上海市东川路800号电院楼群3-100会议室 单位名称：北京高华证券有限责任公司 联系方式：专业要求：不限、信息安全类、自动化类、计算机类、电子类、软件工程类"])!]
            
            
            self?.meeting = meetings
            
            // 职位 (没有显示图片)
            self?.mode.append(CompuseRecruiteJobs(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","address":"北京","create_time":Date().timeIntervalSince1970,"education":"本科","type":"graduate","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false])!)
            
            self?.mode.append(CompuseRecruiteJobs(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","address":"北京","create_time":Date().timeIntervalSince1970,"education":"本科","type":"graduate","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false])!)
            
            self?.mode.append(CompuseRecruiteJobs(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"apple-dqw-fefwe","name":"码农","address":"北京","salary":"150-190元/天","create_time":Date().timeIntervalSince1970,"education":"本科","type":"intern"
                ,"applyEndTime":Date().timeIntervalSince1970,"perDay":"4天/周","months":"5个月","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false])!)
            
            
            
            
            //
            
            
            //print(self?.mode)
            
            DispatchQueue.main.async(execute: {
                
                
                self?.filterJobs?.append(contentsOf: self?.mode ?? [])
                self?.filterJobs?.append(contentsOf: self?.onlineApply ?? [])
                self?.filterJobs?.append(contentsOf: self?.meeting ?? [])
 
                self?.didFinishloadData()
            })
            
        }
    }
}

extension CompanyJobsVC{
    
    @objc func filterJoblist(notify: Notification){
        // tag 名字
        if let name = notify.object as? String {
            self.filterJobs?.removeAll()
            if name  == "全部"{
                
                self.filterJobs?.append(contentsOf: self.mode)
                self.filterJobs?.append(contentsOf: self.onlineApply)
                self.filterJobs?.append(contentsOf: self.meeting)
                
            }else if name == "网申"{
                self.filterJobs?.append(contentsOf: self.onlineApply)
            }else if name == "宣讲会"{
                self.filterJobs?.append(contentsOf: self.meeting)
            }else{
                // tag匹配的jobs
                
                let jobs =  mode.filter({ (item) -> Bool in
                
                    return item.tag.contains(name)
                })
              
                self.filterJobs?.append(contentsOf: jobs)
                
                
            }
            self.joblistTable.reloadSections([1], animationStyle: .none)
            
        }
        
    }
}

extension CompanyJobsVC:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  sections
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return filterJobs?.count ??  0
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch indexPath.section{
        
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: JobTagsCell.identity(), for: indexPath) as! JobTagsCell
            cell.mode = tags
            return cell
        case 1:
            if let mode = filterJobs?[indexPath.row] as? CompuseRecruiteJobs{
                let cell = tableView.dequeueReusableCell(withIdentifier: CommonJobTableCell.identity(), for: indexPath) as! CommonJobTableCell
                cell.mode = mode
                return cell
                
            }else if let mode = filterJobs?[indexPath.row] as? OnlineApplyModel{
                let cell = tableView.dequeueReusableCell(withIdentifier: OnlineApplyCell.identity(), for: indexPath) as!  OnlineApplyCell
                cell.mode = mode
                cell.type.isHidden = false
                return cell
                
            }else if let mode = filterJobs?[indexPath.row] as? CareerTalkMeetingModel{
                let cell = tableView.dequeueReusableCell(withIdentifier: CareerTalkCell.identity(), for: indexPath) as! CareerTalkCell
                cell.mode = mode
                cell.type.isHidden = false
                return cell
            }
            
            //let cell = tableView.dequeueReusableCell(withIdentifier: companyJobCell.identity(), for: indexPath) as! companyJobCell
            //cell.mode = filterJobs?[indexPath.row]
           
        default:
            break
        }
        
        
        return UITableViewCell.init()
        
        
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
            if tags.isEmpty == false{
                return tableView.cellHeight(for: indexPath, model: tags, keyPath: "mode", cellClass: JobTagsCell.self, contentViewWidth: ScreenW)
            }
        case 1:
            
            
//            if let mode = filterJobs?[indexPath.row]{
//                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: companyJobCell.self, contentViewWidth: ScreenW)
//            }
            return 75
        default:
            break
        }
        
        return 0
        
    }
    
    
    
    //查看job
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1{
            if let mode =  filterJobs?[indexPath.row] as? CompuseRecruiteJobs{
                
                let jobDetail: JobDetailViewController = JobDetailViewController()
                guard let id = mode.id else { return }
                jobDetail.jobID = id
                jobDetail.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(jobDetail, animated: true)
            }
            else if let mode = filterJobs?[indexPath.row] as? OnlineApplyModel{
                if mode.outer == true && mode.content == nil{
                    guard let urlLink = mode.link else {return}
                    
                    //跳转外部连接
                    let wbView = baseWebViewController()
                    wbView.mode = urlLink
                    wbView.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(wbView, animated: true)
                }else{
                    // 内部网申数据 或 外部网申但是content有内容
                    let show = OnlineApplyShowViewController()
                    guard let id = mode.id else { return }
                    // 传递id
                    show.onlineApplyID = id
                    
                    show.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(show, animated: true)
                }
                
                
            }else if let mode = filterJobs?[indexPath.row] as? CareerTalkMeetingModel{
                let show = CareerTalkShowViewController()
                show.hidesBottomBarWhenPushed = true
                show.meetingID = mode.id
                self.navigationController?.pushViewController(show, animated: true)
            }
        }
        
    }
    
    
}


extension CompanyJobsVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0{
            delegate?.scrollUp(view: self.joblistTable, height: offsetY)
        }else{
            delegate?.scrollUp(view: self.joblistTable, height: 0)
        }
    }
    
    
}
