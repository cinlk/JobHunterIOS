////
////  companyscrollTableViewController.swift
////  internals
////
////  Created by ke.liang on 2017/12/22.
////  Copyright © 2017年 lk. All rights reserved.
////
//
//import UIKit
//
//
//
//
//
//fileprivate let headerViewH:CGFloat =  100
//
//
//class companyscrollTableViewController: BaseViewController {
//
//    // 获取数据 MARK
//
//    // 时间 今天 显示时间，其他显示 月和日
//
//    private lazy var filterJobs:[CompuseRecruiteJobs]? = []
//
//    private lazy var jobDetail: JobDetailViewController = JobDetailViewController()
//
//    // 本地数据库 companytable
//    private lazy var companyTable = DBFactory.shared.getCompanyDB()
//
//
//
//    private lazy var headerView:CompanyHeaderView = {
//       let header = CompanyHeaderView.init(frame: CGRect.zero)
//       header.backgroundColor = UIColor.white
//       return header
//    }()
//
//
//    private lazy var scrollerView:UIScrollView = {
//       let sc = UIScrollView.init()
//       sc.showsHorizontalScrollIndicator = false
//       sc.showsVerticalScrollIndicator = false
//       sc.backgroundColor = UIColor.clear
//       sc.delegate = self
//       sc.bounces = false
//       sc.contentInsetAdjustmentBehavior = .never
//       sc.isPagingEnabled = true
//       return sc
//    }()
//
//    private lazy var joblistTable:UITableView = {
//       let tb = UITableView.init(frame: CGRect.init(x: ScreenW, y: 0, width: ScreenW, height: ScreenH))
//       tb.tableFooterView = UIView.init()
//       tb.backgroundColor = UIColor.viewBackColor()
//       tb.delegate = self
//       tb.dataSource = self
//       tb.separatorStyle = .singleLine
//       //tb.bounces = false
//       tb.contentInsetAdjustmentBehavior = .never
//       tb.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 60, right: 0)
//       let head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: headerViewH + NavH))
//       head.backgroundColor = UIColor.viewBackColor()
//       tb.tableHeaderView = head
//       //
//       tb.register(JobTagsCell.self, forCellReuseIdentifier: JobTagsCell.identity())
//       tb.register(companyJobCell.self, forCellReuseIdentifier: companyJobCell.identity())
//
//       return tb
//    }()
//
//
//
//    // navigation 背景view
//    private lazy var navigationBackView:UIView = {
//       let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 64))
//       v.backgroundColor = UIColor.navigationBarColor()
//       return v
//    }()
//
//     private var ShareViewCenterY:CGFloat = 0
//
//    // 分享界面
//    private lazy var shareapps:shareView = { [unowned self] in
//        //放在最下方
//        let view =  shareView(frame: CGRect(x: 0, y: ScreenH, width: ScreenW, height: 150))
//        // 加入最外层窗口
//        //view.sharedata = self.infos?["jobName"] ?? ""
//        UIApplication.shared.windows.last?.addSubview(view)
//        ShareViewCenterY = view.centerY
//        return view
//        }()
//
//    private lazy var darkView :UIView = { [unowned self] in
//        let darkView = UIView()
//        darkView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
//        darkView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
//        darkView.isUserInteractionEnabled = true // 打开用户交互
//        let singTap = UITapGestureRecognizer(target: self, action:#selector(self.handleSingleTapGesture)) // 添加点击事件
//        singTap.numberOfTouchesRequired = 1
//        darkView.addGestureRecognizer(singTap)
//        return darkView
//    }()
//
//
//    // itemBarBtn
//    private var itemBtns:[UIButton] = []
//
//
//    // scrollerview位置
//    private var endScrollOffsetX:CGFloat = 0
//    private var startScrollOffsetX:CGFloat = 0
//    private var willEndOffsetX:CGFloat = 0
//
//    // 是否被收藏
//    private var isCollected:Bool = false
//
//
//    var CompanyID:String?{
//        didSet{
//            loadData()
//        }
//    }
//
//
//    // company mode
//    private var comp:CompanyDetail?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setViews()
//
//    }
//
//
//    override func setViews() {
//
//        scrollerView.addSubview(detailTable)
//        scrollerView.addSubview(joblistTable)
//        scrollerView.contentSize = CGSize.init(width: ScreenW * 2, height: ScreenH)
//
//        self.view.addSubview(scrollerView)
//        self.view.addSubview(headerView)
//        self.view.backgroundColor = UIColor.viewBackColor()
//
//        self.addShareBarItem()
//
//        headerView.btn1.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
//        headerView.btn2.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
//
//
//        // 监听job 的tag 变化 刷新第二个table
//        //NotificationCenter.default.addObserver(self, selector: #selector(filterJoblist(notify:)), name: NSNotification.Name.init("whichTag"), object: nil)
//
//        self.handleViews.append(scrollerView)
//        self.handleViews.append(headerView)
//        itemBtns.forEach{
//            self.handleViews.append($0)
//        }
//        super.setViews()
//    }
//
//    override func didFinishloadData() {
//         super.didFinishloadData()
//         headerView.mode = comp
//         // 公司详情table 刷新
//         self.detailTable.reloadData()
//
//        // 是否被收藏
//        isCollected = companyTable.isCollectedBy(id: CompanyID!)
//        itemBtns.last?.isSelected = isCollected
//
//
//    }
//
//    override func reload() {
//        super.reload()
//        self.loadData()
//
//    }
//
//
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.title = "公司详情"
//        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.view.insertSubview(navigationBackView, at: 1)
//
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationItem.title = ""
//        navigationBackView.removeFromSuperview()
//        self.navigationController?.view.willRemoveSubview(navigationBackView)
//
//    }
//    override func viewWillLayoutSubviews() {
//
//        _ = headerView.sd_layout().yIs(NavH)?.rightEqualToView(self.view)?.leftEqualToView(self.view)?.heightIs(headerViewH)
//        _ = scrollerView.sd_layout().topEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
//        // 不在headerview里设置layout约束, 不然第二个tableview 滑动时会被约束限制
//        headerView.underLine.frame = CGRect.init(x: headerView.btn1.center.x + 15, y: headerView.frame.height - 1 , width: 30, height: 1)
//
//
//
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//}
//
//extension companyscrollTableViewController{
//
//    @objc func click(_ sender:UIButton){
//
//        UIView.animate(withDuration: 0.3, animations: {  [unowned self] in
//
//            // tableview 在 navigationbar 下方
//            self.adjustHeighTable()
//            self.scrollerView.setContentOffset(CGPoint.init(x: CGFloat(sender.tag - 1) * UIScreen.main.bounds.width , y: 0), animated: false)
//            self.headerView.underLine.center.x = sender.center.x
//            self.headerView.chooseBtn1 = sender.tag == 1 ? true : false
//
//        })
//
//    }
//
//    //  异步获取网络数据， UI 线程更新
//    private func loadData(){
//
//        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
//
//            Thread.sleep(forTimeInterval: 3)
//            let json:[String:Any] = ["address":"地址 北京 - 定位","webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的打到我","好id多多多多多无多无多付付","有多长好长","没有嘛yiu哦郁闷yiu","标签1","标签12","标签1等我大大哇","分为发违法标签99"]
//                ,"name":"sina","describe":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n","simpleDes":"新浪微博个性化","simpleTag":["北京","2000人以上","互联网"],"iconURL":"sina","joblist":
//                    ["jobtag":["全部","研发","产品","市场","智能","AI","IOS","销售","实习","我看六个字的"],
//                     "jobs":[["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["市场"]],["company":"sina","picture":"","jobName":"后期助理","address":"厦门","type":"compuse","education":"本科","create_time":"12-06","salary":"100-200/天","tag":["实习"]],["company":"sina","picture":"","jobName":"IOS开发","address":"北京","type":"compuse","education":"研究生","create_time":"12-24","salary":"15K-20K","tag":["研发"]],["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["市场"]],
//                             ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["市场"]],
//                             ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["市场"]],
//                             ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["市场"]],
//                             ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["市场"]],
//                             ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["市场"]],
//                             ["company":"sina","picture":"","jobName":"在线讲师","address":"北京","type":"compuse","education":"不限","create_time":"09:45","salary":"面议","tag":["市场","研发"]]]]]
//
//            self?.comp = CompanyDetail(JSON: json)
//
//            DispatchQueue.main.async(execute: {
//
//
//
//                if let  jobs =  self?.comp?.joblist?.jobs{
//                    self?.filterJobs?.append(contentsOf: jobs)
//                }
//                self?.didFinishloadData()
//
//                // 错误
//                //self?.showError()
//
//            })
//
//        }
//
//
//        // 头部视图
//
//        //self.detailTable.reloadData()
//        //self.joblistTable.reloadData()
//
////        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////
////        }
//
//            //self.joblistTable.reloadSections([1], animationStyle: .none)
//    }
//
//
//
//    private func addShareBarItem(){
//        // 分享
//        let up =  UIImage.barImage(size: CGSize.init(width: 25, height: 25), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "upload")
//
//        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
//
//        b1.addTarget(self, action: #selector(share), for: .touchUpInside)
//        b1.setImage(up, for: .normal)
//        b1.clipsToBounds = true
//
//        // 收藏
//
//        let collected = UIImage.barImage(size: CGSize.init(width: 25, height: 25), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "heart")
//
//        let b2 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
//        b2.addTarget(self, action: #selector(collectedCompany(btn:)), for: .touchUpInside)
//        b2.setImage(collected, for: .normal)
//
//        let selectedCollection = UIImage.barImage(size: CGSize.init(width: 25, height: 25), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "selectedHeart")
//
//        b2.setImage(selectedCollection, for: .selected)
//
//        b2.clipsToBounds = true
//
//        b2.isSelected = isCollected
//
//
//
//
//        self.navigationItem.setRightBarButtonItems([UIBarButtonItem.init(customView: b1), UIBarButtonItem.init(customView: b2)], animated: false)
//
//        itemBtns.append(b1)
//        itemBtns.append(b2)
//
//    }
//
//    @objc func share(){
//        self.navigationController?.view.addSubview(darkView)
//        //self.view.addSubview(darkView)
//        UIView.animate(withDuration: 0.5, animations: {
//
//            self.shareapps.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 150, width: UIScreen.main.bounds.width, height: 150)
//        }, completion: nil)
//
//    }
//
//    @objc func collectedCompany(btn:UIButton){
//        // MARK 修改公司状态 已经为收藏
//
//
//        let json:[String:Any] = ["id":"123","icon":"sina","name":"sina","describe":"互联网老兵",
//                                 "address":"北京","staffs":"1000以上","industry":"互联网",
//                                 "tags":["标签1","标签2"]]
//
//
//        if !isCollected{
//            showOnlyTextHub(message: "收藏成功", view: self.view)
//            //jobManageRoot.addCompanyItem(item: comapnyInfo(JSON: json)!)
//            isCollected = true
//            btn.isSelected = true
//            companyTable.setCollectedBy(id: CompanyID!)
//        }else{
//            //jobManageRoot.removeCollectedCompany(item: comapnyInfo(JSON: json)!)
//            showOnlyTextHub(message: "取消收藏", view: self.view)
//            isCollected = false
//            btn.isSelected = false
//            companyTable.unCollected(id: CompanyID!)
//        }
//
//
//
//
//
//    }
//
//    @objc func handleSingleTapGesture() {
//        // 点击移除半透明的View
//        darkView.removeFromSuperview()
//        UIView.animate(withDuration: 0.5, animations: {
//
//            self.shareapps.centerY =  self.ShareViewCenterY
//        }, completion: nil)
//
//    }
//
//}
//
//extension companyscrollTableViewController: UITableViewDelegate,UITableViewDataSource{
//
//
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return  tableView == self.detailTable ? 3 : 2
//
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if tableView == joblistTable && section == 1{
//            return filterJobs?.count ??  0
//        }
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if tableView == detailTable{
//            switch indexPath.section{
//            case 0:
//                let cell  = tableView.dequeueReusableCell(withIdentifier: "tagsTableViewCell", for: indexPath) as! tagsTableViewCell
//                cell.tags = comp?.tags  ?? [""]
//                return cell
//            case 1:
//                let cell  = tableView.dequeueReusableCell(withIdentifier: "introductionCell", for: indexPath) as! introductionCell
//                cell.des = comp?.describe  ?? ""
//                return cell
//            case 2:
//                //let comp = CompanyDetail(address: "地址 北京 - 定位", webSite: "https://www.baidu.com")
//
//                let cell  = tableView.dequeueReusableCell(withIdentifier: "CompanyDetailCell", for: indexPath) as! CompanyDetailCell
//                cell.comp = comp
//                return cell
//            default:
//                let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
//                return cell
//
//            }
//
//        }else{
//            switch indexPath.section{
//            case 0:
//
//                let cell = tableView.dequeueReusableCell(withIdentifier: JobTagsCell.identity(), for: indexPath) as! JobTagsCell
//                cell.mode = comp?.joblist?.jobtag
//                return cell
//            case 1:
//                let cell = tableView.dequeueReusableCell(withIdentifier: companyJobCell.identity(), for: indexPath) as! companyJobCell
//                cell.mode = filterJobs?[indexPath.row]
//                return cell
//            default:
//                return UITableViewCell.init()
//            }
//
//        }
//
//    }
//
//    // section 高度
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView.init()
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return remainHeight
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == detailTable{
//            if  indexPath.section == 0 {
//                let tags =  comp?.tags ?? []
//                return tableView.cellHeight(for: indexPath, model: tags, keyPath: "tags", cellClass: tagsTableViewCell.self, contentViewWidth: ScreenW)
//            }else if indexPath.section == 1{
//                let des  = comp?.describe ?? ""
//                return tableView.cellHeight(for: indexPath, model: des, keyPath: "des", cellClass: introductionCell.self, contentViewWidth: ScreenW)
//            }else{
//                if let cMode = comp{
//                    return tableView.cellHeight(for: indexPath, model: cMode, keyPath: "comp", cellClass: CompanyDetailCell.self, contentViewWidth: ScreenW)
//                }
//            }
//
//        }
//        else if tableView == joblistTable {
//            if  indexPath.section == 0{
//                if let mode =  comp?.joblist?.jobtag{
//                    return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: JobTagsCell.self, contentViewWidth: ScreenW)
//                }
//            }else{
//
//                if let mode = filterJobs?[indexPath.row]{
//                    return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: companyJobCell.self, contentViewWidth: ScreenW)
//                }
//            }
//
//        }
//
//        return 0
//
//    }
//
//
//
//    //查看job
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        if tableView == self.joblistTable && indexPath.section == 1{
//            if let info =  filterJobs?[indexPath.row]{
//                jobDetail.jobID = info.id!
//                self.navigationController?.pushViewController(jobDetail, animated: true)
//            }
//        }
//
//    }
//
//
//}
//
//// 滑动
//extension  companyscrollTableViewController: UIScrollViewDelegate {
//
//
//
//    // 内部tableview 滑动和同步偏移
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//
//        let stopHeight =  headerViewH - 30
//
//        if scrollView.isKind(of: UITableView.self){
//
//            let offsetY = scrollView.contentOffset.y
//            // headerView 停止滑动
//            if offsetY >= stopHeight {
//                headerView.frame.origin.y = 64 -  stopHeight
//
//            }
//                // 没有滑动
//            else  if offsetY <= 0 {
//                // 恢复最初位置
//                headerView.frame.origin.y = 64
//                // tableview 保持同步
//                self.detailTable.contentOffset = scrollView.contentOffset
//                self.joblistTable.contentOffset = scrollView.contentOffset
//                // headerView 和tableview 一起滑动
//            }else{
//                headerView.frame.origin.y =  64 - offsetY
//                // tableview 保持同步
//                self.detailTable.contentOffset = scrollView.contentOffset
//                self.joblistTable.contentOffset = scrollView.contentOffset
//
//            }
//
//        }else  if  scrollView == self.scrollerView{
//            //  线滑动进度progress
//            var progress:CGFloat = 0
//            let currentOffsetX = scrollView.contentOffset.x
//            let scroviewW = ScreenW
//            let left = self.headerView.btn1.center.x
//            let right = self.headerView.btn2.center.x
//            let btndistance  =  right -  left
//            //print(startScrollOffsetX, endScrollOffsetX, willEndOffsetX,currentOffsetX)
//            // 左滑动
//            if  currentOffsetX > startScrollOffsetX {
//
//                progress = currentOffsetX / scroviewW
//                moveLine(progress:progress,start:left, distance:btndistance)
//
//            }else{
//
//                progress =   (currentOffsetX / scroviewW) - 1
//                moveLine(progress:progress,start:right, distance:btndistance)
//
//            }
//
//        }
//
//    }
//
//    // btn下划线滑动进度
//    private func moveLine(progress:CGFloat, start:CGFloat, distance:CGFloat){
//
//        self.headerView.underLine.center.x =  start  +  distance * progress
//
//        if progress == 1{
//            self.headerView.chooseBtn1 = false
//        }else if progress == -1{
//            self.headerView.chooseBtn1 = true
//        }
//
//
//    }
//
//
//    // tableview offset 同步
//    private func adjustHeighTable(){
//        let stopHeight = headerViewH - 30
//        let maxOffsetY = max(self.detailTable.contentOffset.y, self.joblistTable.contentOffset.y)
//        if maxOffsetY >= stopHeight{
//            if self.detailTable.contentOffset.y < stopHeight{
//                self.detailTable.contentOffset = CGPoint.init(x: 0, y: stopHeight)
//            }
//            if self.joblistTable.contentOffset.y < stopHeight{
//                self.joblistTable.contentOffset = CGPoint.init(x: 0, y: stopHeight)
//            }
//        }
//    }
//
//
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView == self.scrollerView{
//            startScrollOffsetX = scrollView.contentOffset.x
//            adjustHeighTable()
//        }
//
//
//    }
//
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//        if scrollView == self.scrollerView{
//            endScrollOffsetX = scrollView.contentOffset.x
//        }
//    }
//
//
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView == self.scrollerView{
//            willEndOffsetX = scrollView.contentOffset.x
//        }
//
//    }
//}
//
//extension companyscrollTableViewController{
//    // 刷新joblist
//    @objc func filterJoblist(notify: Notification){
//        // tag 名字
//        if let name = notify.object as? String {
//            self.filterJobs?.removeAll()
//            if name  == "全部"{
//
//                if let jobs  = comp?.joblist?.jobs{
//                    self.filterJobs?.append(contentsOf: jobs)
//                }
//            }else{
//                // tag匹配的jobs
//                if let json =  (comp?.joblist?.jobs)?.filter({ (item) -> Bool in
//
//                    return item.tag.contains(name)
//                }){
//                    for item in json{
//                        self.filterJobs?.append(item)
//                    }
//                }
//
//            }
//            self.joblistTable.reloadSections([1], animationStyle: .none)
//
//        }
//
//    }
//
//}
//
//
//// companyHeader view
//fileprivate class CompanyHeaderView:UIView{
//
//    private lazy var icon:UIImageView = {
//       let img = UIImageView.init()
//       img.clipsToBounds = true
//       img.contentMode = .scaleAspectFit
//       return img
//    }()
//
//    private lazy var companyName:UILabel = {
//        let label = UILabel.init()
//        label.text = ""
//        label.textAlignment = .left
//        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
//        label.font = UIFont.boldSystemFont(ofSize: 15)
//        return label
//    }()
//
//    private lazy var des:UILabel = {
//       let label = UILabel.init()
//       label.text = ""
//       label.font = UIFont.systemFont(ofSize: 12)
//       label.textAlignment = .left
//       label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
//       return label
//    }()
//
//    private lazy var tags:UILabel = {
//        let label = UILabel.init()
//        label.text = ""
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textAlignment = .left
//        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
//        return label
//    }()
//
//    lazy var btn1:UIButton = {
//       let btn = UIButton.init()
//       btn.setTitleColor(UIColor.lightGray, for: .normal)
//       btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//       btn.setTitleColor(UIColor.blue, for: .selected)
//       btn.setTitle("公司详情", for: .normal)
//       //btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
//       btn.tag = 1
//       btn.isSelected = true
//
//       return btn
//    }()
//
//    lazy var btn2:UIButton = {
//        let btn = UIButton.init()
//        btn.setTitleColor(UIColor.lightGray, for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        btn.setTitleColor(UIColor.blue, for: .selected)
//        btn.setTitle("在招职位", for: .normal)
//        //btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
//        btn.tag = 2
//
//        return btn
//    }()
//
//    var chooseBtn1 = true{
//        willSet{
//            btn1.isSelected = newValue
//            btn2.isSelected = !newValue
//        }
//    }
//    // btn 下划线
//    lazy var underLine:UIView = {  [unowned self] in
//        let line = UIView.init(frame: CGRect.zero)
//        line.backgroundColor = UIColor.blue
//        return line
//    }()
//    // 分割线
//    private let line = UIView.init()
//
//    var mode:CompanyDetail?{
//        didSet{
//            self.icon.image = UIImage.init(named: mode?.iconURL ?? "default")
//            self.companyName.text = mode?.name
//            self.des.text = mode?.simpleDes
//            var tags  = ""
//            for (index,item) in (mode!.simpleTag?.enumerated())!{
//
//                tags += item +  (index == mode?.tags?.count ? "" : "|")
//            }
//            self.tags.text = tags
//
//        }
//    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // MARK 修改
//        //underLine.frame = CGRect.init(x: self.btn1.center.x, y: 109 , width: 30, height: 1)
//        let views:[UIView] = [icon, companyName,des,tags, line,btn1, btn2, underLine]
//        self.sd_addSubviews(views)
//
//        line.backgroundColor = UIColor.lightGray
//
//        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.widthIs(50)?.heightIs(60)
//        _ = companyName.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
//        _ = des.sd_layout().leftEqualToView(companyName)?.topSpaceToView(companyName,2)?.autoHeightRatio(0)
//        _ = tags.sd_layout().leftEqualToView(companyName)?.topSpaceToView(des,2)?.autoHeightRatio(0)
//        _ = line.sd_layout().topSpaceToView(icon,5)?.leftEqualToView(icon)?.rightEqualToView(self)?.heightIs(1)
//        _ = btn1.sd_layout().leftSpaceToView(self,30)?.topSpaceToView(line,5)?.widthIs(120)?.heightIs(20)
//        _ = btn2.sd_layout().rightSpaceToView(self,30)?.topSpaceToView(line,5)?.widthIs(120)?.heightIs(20)
//        //_ = underLine.sd_layout().centerXEqualToView(btn1)?.widthIs(30)?.heightIs(1)?.bottomEqualToView(self)
//        companyName.setMaxNumberOfLinesToShow(1)
//        des.setMaxNumberOfLinesToShow(1)
//        tags.setMaxNumberOfLinesToShow(1)
//        //underLine.frame =  CGRect.init(x: btn1.center.x + 15, y: self.frame.height - 1 , width: 30, height: 1)
//        // 约束关系，父类view frame 改变 会重新应用最初的约束关系
//        //_ = underLine.sd_layout().bottomEqualToView(self)?.centerXEqualToView(btn1)?.widthIs(30)?.heightIs(1)
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}
//
//
//
