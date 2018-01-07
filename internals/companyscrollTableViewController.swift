//
//  companyscrollTableViewController.swift
//  internals
//
//  Created by ke.liang on 2017/12/22.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class companyscrollTableViewController: UIViewController {
    
    
    
    // 获取数据 MARK
    var companyInfo:Dictionary<String,Any?>? = ["tags":["标签1","标签1测试","标签89我的打到我","好id多多多多多无多无多付付","有多长好长","没有嘛yiu哦郁闷yiu","标签1","标签12","标签1等我大大哇","分为发违法标签99"],
        "introduce":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n",
        "address":"北京市昌平区二拨子村甲13号"]
    // 时间 今天 显示时间，其他显示 月和日
    var joblistData:Dictionary<String,Any?>? = ["jobTag":["全部","研发","产品","市场","智能","AI","IOS","销售","实习","我看六个字的"],
                                                "jobs":[["jobName":"在线讲师","address":"北京","type":"校招","degree":"不限","create_time":"09:45","salary":"面议","tag":"市场"],["jobName":"后期助理","address":"厦门","type":"实习","degree":"本科","create_time":"12-06","salary":"100-200/天","tag":"实习"],["jobName":"IOS开发","address":"北京","type":"校招","degree":"研究生","create_time":"12-24","salary":"15K-20K","tag":"研发"],["jobName":"在线讲师","address":"北京","type":"校招","degree":"不限","create_time":"09:45","salary":"面议","tag":"市场"]]
                                                    ]
    
    
    var filterJobs:[Dictionary<String,String>]?
    
    

    lazy var headerView:CompanyHeaderView = {
       let header = CompanyHeaderView.init(frame: CGRect.zero)
       header.backgroundColor = UIColor.white
       return header
    }()

    
    
    lazy var scrollerView:UIScrollView = {
       let sc = UIScrollView.init()
       sc.showsHorizontalScrollIndicator = false
       sc.showsVerticalScrollIndicator = false
       sc.backgroundColor = UIColor.clear
       sc.delegate = self
       sc.bounces = false
       sc.isPagingEnabled = true
       return sc
    }()
    
    lazy var joblistTable:UITableView = {
       let tb = UITableView.init(frame: CGRect.zero)
       tb.tableFooterView = UIView.init()
       tb.backgroundColor = UIColor.white
       tb.delegate = self
       tb.dataSource = self
       tb.separatorStyle = .singleLine
       tb.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 120, right: 0)
       //
       tb.register(JobTagsCell.self, forCellReuseIdentifier: JobTagsCell.identity())
       tb.register(companyJobCell.self, forCellReuseIdentifier: companyJobCell.identity())
       
       return tb
    }()
    
    lazy var detailTable:UITableView = {
       let tb = UITableView.init(frame: CGRect.zero)
       tb.tableFooterView = UIView.init()
       tb.backgroundColor = UIColor.white
       tb.delegate = self
       tb.dataSource = self
       tb.rowHeight = UITableViewAutomaticDimension
       tb.estimatedRowHeight = 100
       tb.separatorStyle = .none
       // 底部内容距离底部高120，防止回弹底部内容被影藏
       tb.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 120, right: 0)
       // cell
       tb.register(UINib.init(nibName: "tagsTableViewCell", bundle: nil), forCellReuseIdentifier: "tags")
       tb.register(UINib.init(nibName: "introduction", bundle: nil), forCellReuseIdentifier: "introduce")
       tb.register(UINib.init(nibName: "others", bundle: nil), forCellReuseIdentifier: "other")
        
        
       return tb
    }()
    
    
    // navigation 背景view
    lazy var navigationBackView:UIView = {
       let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 64))
       v.backgroundColor = UIColor.lightGray
       return v
    }()
    
    // 分享界面
    lazy var shareapps:shareView = { [unowned self] in
        //放在最下方
        let view =  shareView(frame: CGRect(x: 0, y: ScreenH, width: ScreenW, height: 150))
        // 加入最外层窗口
        //view.sharedata = self.infos?["jobName"] ?? ""
        UIApplication.shared.windows.last?.addSubview(view)
        return view
        }()
    
    lazy var darkView :UIView = { [unowned self] in
        let darkView = UIView()
        darkView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        darkView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
        darkView.isUserInteractionEnabled = true // 打开用户交互
        let singTap = UITapGestureRecognizer(target: self, action:#selector(self.handleSingleTapGesture)) // 添加点击事件
        singTap.numberOfTouchesRequired = 1
        darkView.addGestureRecognizer(singTap)
        return darkView
    }()
    
    
    var centerY:CGFloat = 0
    
    var remainHeight:CGFloat = 10
    var headerHeight:CGFloat = 100
    
    // 位置
    var endScrollOffsetX:CGFloat = 0
    var startScrollOffsetX:CGFloat = 0
    var willEndOffsetX:CGFloat = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        detailTable.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH)
        joblistTable.frame = CGRect.init(x: ScreenW, y: 0, width: ScreenW, height: ScreenH)
        
        scrollerView.addSubview(detailTable)
        scrollerView.addSubview(joblistTable)
        scrollerView.contentSize = CGSize.init(width: ScreenW * 2, height: 0)
        
        self.view.addSubview(scrollerView)
        self.view.addSubview(headerView)
        self.view.backgroundColor = UIColor.lightGray
        //假headerview 和section
        let h1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 100))
        h1.backgroundColor = UIColor.lightGray
        detailTable.tableHeaderView = h1
        let h2 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 100))
        h2.backgroundColor = UIColor.lightGray
        joblistTable.tableHeaderView = h2
        
        headerView.icon.image = UIImage.init(named: "sina")
        headerView.companyName.text = "新浪"
        headerView.des.text = "新浪微博个性化"
        headerView.tags.text = "北京 |2000人以上|互联网"
        headerView.btn1.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        headerView.btn2.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        self.centerY = shareapps.centerY

        self.addShareBarItem()
        // MARK 获取数据 刷新table
        // as 会转化成 不可修改类型
        var tmp = self.joblistData?["jobs"] as? [Dictionary<String,String>]
        for _ in 0..<10 {
            tmp?.append(["jobName":"在线讲师","address":"北京","type":"校招","degree":"不限","create_time":"09:45","salary":"面议","tag":"市场"])
        }
        self.joblistData?["jobs"] = tmp
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            self.filterJobs  = self.joblistData?["jobs"]  as? [Dictionary<String, String>]
           
            self.joblistTable.reloadSections([1], animationStyle: .none)
        }
        
        // 监听tag 变化 刷新table
        NotificationCenter.default.addObserver(self, selector: #selector(filterJoblist(notify:)), name: NSNotification.Name.init("whichTag"), object: nil)
        
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "公司详情"
        self.navigationController?.view.insertSubview(navigationBackView, at: 1)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
        navigationBackView.removeFromSuperview()
        self.navigationController?.view.willRemoveSubview(navigationBackView)
        
    }
    override func viewWillLayoutSubviews() {
        
        _ = headerView.sd_layout().yIs(64)?.rightEqualToView(self.view)?.leftEqualToView(self.view)?.heightIs(remainHeight + headerHeight)
        _ = scrollerView.sd_layout().topEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        
        // 不在headerview里设置layout约束, 不然动画时会被约束限制
        headerView.underLine.frame = CGRect.init(x: headerView.btn1.center.x + 15, y: headerView.frame.height - 1 , width: 30, height: 1)
        
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension companyscrollTableViewController{
    
    @objc func click(_ sender:UIButton){
        
        UIView.animate(withDuration: 0.3, animations: {  [unowned self] in
            
            // tableview 在 navigationbar 下方
            self.adjustHeighTable()
            self.scrollerView.setContentOffset(CGPoint.init(x: CGFloat(sender.tag - 1) * UIScreen.main.bounds.width , y: -64), animated: false)
            self.headerView.underLine.center.x = sender.center.x
            self.headerView.chooseBtn1 = sender.tag == 1 ? true : false
            
        })
        
        
    }
    private func addShareBarItem(){
        var up =  UIImage.barImage(size: CGSize.init(width: 25, height: 25), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "upload")
      
        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        
        b1.addTarget(self, action: #selector(share), for: .touchUpInside)
        b1.setImage(up, for: .normal)
        b1.clipsToBounds = true
        
        self.navigationItem.setRightBarButton(UIBarButtonItem.init(customView: b1), animated: false)
    }
    
    @objc func share(){
        self.navigationController?.view.addSubview(darkView)
        //self.view.addSubview(darkView)
        UIView.animate(withDuration: 0.5, animations: {
            
            self.shareapps.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 150, width: UIScreen.main.bounds.width, height: 150)
        }, completion: nil)
        
    }
    
    @objc func handleSingleTapGesture() {
        // 点击移除半透明的View
        darkView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, animations: {
            
            self.shareapps.centerY =  self.centerY
        }, completion: nil)
        
    }
    
}

extension companyscrollTableViewController: UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  tableView == self.detailTable ? 3 : 2
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == joblistTable && section == 1{
            return filterJobs?.count ??  0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == detailTable{
            switch indexPath.section{
            case 0:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "tags", for: indexPath) as! tagsTableViewCell
                cell.tags = companyInfo?["tags"] as? [String] ?? [""]
                return cell
            case 1:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "introduce", for: indexPath) as! introduction
                cell.desc.text = companyInfo?["introduce"] as? String ?? ""
                return cell
            case 2:
                let cell  = tableView.dequeueReusableCell(withIdentifier: "other", for: indexPath) as! others
                cell.adressDetail.text = companyInfo?["address"] as? String ?? ""
                return cell
            default:
                let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
                return cell
            
            }
            
        }else{
            switch indexPath.section{
            case 0:
                print("refresh ")
                let cell = tableView.dequeueReusableCell(withIdentifier: JobTagsCell.identity(), for: indexPath) as! JobTagsCell
                cell.interTagView(joblistData?["jobTag"] as? [String])
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: companyJobCell.identity(), for: indexPath) as! companyJobCell
                cell.setLabel(item: filterJobs?[indexPath.row])
                return cell
            default:
                return UITableViewCell.init()
            }
            
        }
      
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        v.backgroundColor = UIColor.lightGray
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return remainHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == detailTable && indexPath.section == 0 {
            if let count = (companyInfo?["tags"] as? [String])?.count{
                return CGFloat((count/3) * 50 + 50)
            }
        }
        else if tableView == joblistTable && indexPath.section == 0 {
            if let count = (joblistData?["jobTag"] as? [String])?.count{
                return CGFloat(count/4) * 40 + 40 
            }else{
                return 0
            }
        }else if tableView == joblistTable && indexPath.section == 1{
            return companyJobCell.cellHeight()
        }
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    //selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.joblistTable && indexPath.section == 1{
            if let info =  filterJobs?[indexPath.row]{
                let detail = JobDetailViewController()
                detail.infos = info
                self.navigationController?.pushViewController(detail, animated: true)
            }
        }
        
    }
    
    
    
    // 内部tableview 滑动和同步偏移
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let stopHeight =  headerHeight+remainHeight - 30
        if scrollView.isKind(of: UITableView.self){
            let offsetY = scrollView.contentOffset.y
            if offsetY >= stopHeight {
                 headerView.frame.origin.y = 64 -  stopHeight
                
            }
            else  if offsetY <= 0 {
                headerView.frame.origin.y = 64
                self.detailTable.contentOffset = scrollView.contentOffset
                self.joblistTable.contentOffset = scrollView.contentOffset
            }else{
                 headerView.frame.origin.y =  64 - offsetY
                 self.detailTable.contentOffset = scrollView.contentOffset
                 self.joblistTable.contentOffset = scrollView.contentOffset
                
            }
            
            
        }else  if  scrollView == self.scrollerView{
            //  线滑动进度progress
            var progress:CGFloat = 0
            let currentOffsetX = scrollView.contentOffset.x
            let scroviewW = scrollerView.bounds.width
            let left = self.headerView.btn1.center.x
            let right = self.headerView.btn2.center.x
            let btndistance  =  right -  left
            var direction = false
            
            // 左滑动
            if currentOffsetX > startScrollOffsetX {
                progress = currentOffsetX / scroviewW - floor(currentOffsetX / scroviewW)

                if currentOffsetX - startScrollOffsetX == scroviewW{
                    progress = 1.0
                }
                direction = true
                
            }else{
                progress = 1 - (currentOffsetX / scroviewW - floor(currentOffsetX / scroviewW))
                if startScrollOffsetX - currentOffsetX == scroviewW{
                    progress = 1
                }
                direction = false
               
            }
            UIView.animate(withDuration: 0.2, animations: {
                switch direction{
                case false:
                    UIView.animate(withDuration: 0.2, animations: {
                        self.headerView.underLine.center.x =  right  -  btndistance * progress
                        self.headerView.chooseBtn1 = true
                    })
                case true:
                    UIView.animate(withDuration: 0.2, animations: {
                        self.headerView.underLine.center.x =  left + btndistance * progress
                        self.headerView.chooseBtn1 = false
                    })
                }
            })
           
            
        }
       
        
    }
    
    
    
    private func adjustHeighTable(){
        let stopHeight = headerHeight+remainHeight - 30
        let maxOffsetY = max(self.detailTable.contentOffset.y, self.joblistTable.contentOffset.y)
        if maxOffsetY >= stopHeight{
            if self.detailTable.contentOffset.y < stopHeight{
                self.detailTable.contentOffset = CGPoint.init(x: 0, y: stopHeight)
            }
            if self.joblistTable.contentOffset.y < stopHeight{
                self.joblistTable.contentOffset = CGPoint.init(x: 0, y: stopHeight)
            }
        }
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let stopHeight = headerHeight+remainHeight - 30
        if scrollView == self.scrollerView{
            startScrollOffsetX = scrollView.contentOffset.x
            let maxOffsetY = max(self.detailTable.contentOffset.y, self.joblistTable.contentOffset.y)
            if maxOffsetY >= stopHeight{
                if self.detailTable.contentOffset.y < stopHeight{
                    self.detailTable.contentOffset = CGPoint.init(x: 0, y: stopHeight)
                }
                if self.joblistTable.contentOffset.y < stopHeight{
                    self.joblistTable.contentOffset = CGPoint.init(x: 0, y: stopHeight)
                }
            }
        }
        
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == self.scrollerView{
            endScrollOffsetX = scrollView.contentOffset.x
        }
    }
   
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.scrollerView{
            willEndOffsetX = scrollView.contentOffset.x
        }
        
    }
    
    
    
}


extension companyscrollTableViewController{
    @objc func filterJoblist(notify: Notification){
        if let name = notify.object as? String {
            
            if name  == "全部"{
                self.filterJobs  = self.joblistData?["jobs"]  as? [Dictionary<String, String>]
            }else{
                self.filterJobs = (self.joblistData?["jobs"] as? [Dictionary<String, String>])?.filter({ (item) -> Bool in
                    return (item["tag"]?.contains(name))!
                })
            }
            self.joblistTable.reloadSections([1], animationStyle: .none)

        }

    }
    
}


// companyHeader
class CompanyHeaderView:UIView{
    
    lazy var icon:UIImageView = {
       let img = UIImageView.init()
       img.clipsToBounds = true
       img.contentMode = .scaleAspectFit
       return img
    }()
    
    lazy var companyName:UILabel = {
        let label = UILabel.init()
        label.text = ""
        
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var des:UILabel = {
       let label = UILabel.init()
       label.text = ""
       label.font = UIFont.systemFont(ofSize: 12)
       return label
    }()
    
    lazy var tags:UILabel = {
        let label = UILabel.init()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var btn1:UIButton = {
       let btn = UIButton.init()
       btn.setTitleColor(UIColor.lightGray, for: .normal)
       btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
       btn.setTitleColor(UIColor.blue, for: .selected)
       btn.setTitle("公司详情", for: .normal)
       //btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
       btn.tag = 1
       btn.isSelected = true
        
       return btn
    }()
    
    lazy var btn2:UIButton = {
        let btn = UIButton.init()
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.blue, for: .selected)
        btn.setTitle("在招职位", for: .normal)
        //btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        btn.tag = 2

        return btn
    }()
    
    var chooseBtn1 = true{
        willSet{
            btn1.isSelected = newValue
            btn2.isSelected = !newValue
        }
    }
    lazy var bottomView:UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    lazy var underLine:UIView = {  [unowned self] in
        let line = UIView.init(frame: CGRect.zero)
        line.backgroundColor = UIColor.blue
        return line
    }()
    
    let line = UIView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // MARK 修改
        //underLine.frame = CGRect.init(x: self.btn1.center.x, y: 109 , width: 30, height: 1)

        self.addSubview(icon)
        self.addSubview(companyName)
        self.addSubview(des)
        self.addSubview(tags)
        self.addSubview(line)
        self.addSubview(btn1)
        self.addSubview(btn2)
        self.addSubview(underLine)
        //self.addSubview(bottomView)
        
        line.backgroundColor = UIColor.lightGray
        
        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.widthIs(50)?.heightIs(60)
        _ = companyName.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.widthIs(200)?.heightIs(25)
        _ = des.sd_layout().leftEqualToView(companyName)?.topSpaceToView(companyName,2)?.rightEqualToView(self)?.heightIs(20)
        _ = tags.sd_layout().leftEqualToView(companyName)?.topSpaceToView(des,2)?.rightEqualToView(self)?.heightIs(20)
        _ = line.sd_layout().bottomSpaceToView(self,30)?.leftEqualToView(icon)?.rightEqualToView(self)?.heightIs(1)
        _ = btn1.sd_layout().leftSpaceToView(self,30)?.topSpaceToView(line,5)?.widthIs(120)?.heightIs(20)
        _ = btn2.sd_layout().rightSpaceToView(self,30)?.topSpaceToView(line,5)?.widthIs(120)?.heightIs(20)
        // 约束关系，父类view frame 改变 会重新应用最初的约束关系
        //_ = underLine.sd_layout().bottomEqualToView(self)?.centerXEqualToView(btn1)?.widthIs(30)?.heightIs(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}



