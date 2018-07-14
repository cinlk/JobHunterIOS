//
//  OnlineApplyShowViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


// test content string
fileprivate let content =  """
企业介绍：

腾讯成立于1998年11月，是目前中国领先的互联网增值服务提供商之一。成立10多年以来，腾讯一直秉承“一切以用户价值为依归”的经营理念，为亿级海量用户提供稳定优质的各类服务，始终处于稳健发展的状态。2004年6月16日，腾讯控股有限公司在香港联交所主板公开上市（股票代号700）。

在招职位：

技术类

软件开发

岗位描述：

从事腾讯产品服务后台的架构设计、开发、优化及运营工作；使用最优秀的架构设计及算法实现，在网络接入、业务运行逻辑、用户数据存储、业务数据挖掘等方向，为海量互联网用户提供稳定、安全、高效和可靠的专业后台支撑体系。

岗位要求：

编程基本功扎实，掌握C/C++/JAVA等开发语言、常用算法和数据结构；

熟悉TCP/UDP网络协议及相关编程、进程间通讯编程；

了解Python、Shell、Perl等脚本语言；

了解MYSQL及SQL语言、编程，了解NoSQL, key-value存储原理；

全面、扎实的软件知识结构，掌握操作系统、软件工程、设计模式、数据结构、数据库系统、网络安全等专业知识；

了解分布式系统设计与开发、负载均衡技术，系统容灾设计，高可用系统等知识。

注：招聘城市根据项目类型有所不同，其中，暑期实习招聘城市为下方除补录外全部“招聘城市”，mini实习招聘城市为：北京，成都，杭州，合肥，南京，上海，武汉，西安。校园招聘（2018届）招聘城市请选择：补录。该岗位“招聘城市”在简历投递截止日前会有部分调整，请密切关注，腾讯公司对招聘信息保留最终解释权。

工作地点：深圳总部 北京 上海 广州 成都

招聘城市：成都 西安 广州 哈尔滨 上海 杭州 重庆 北京 南京 深圳 长沙 大连 武汉 合肥 补录 San Francisco



技术运营

岗位描述：

负责如QQ、微信、腾讯云、腾讯游戏等腾讯海量业务的技术支撑和服务。与优秀的工程师一起，通过优秀的IDC机房规划建设、网络规划、CDN加速网络、高性能数据库和云存储管理、高可用高性能主机应用、运维自动化及监控系统建设等解决如：中国及海外互联网用户跨地域、跨运营商等复杂网络下稳定、低延迟的接入及访问我们的产品！高效管理、服务数以十万计的服务器及云端用户，通过架构优化和容错建设保障业务不间断运行！通过立体化监控系统快速发现和处理故障，以及让故障自愈。加盟腾讯技术运营、服务团队，您将亲身参与打造中国最优质的互联网产品平台，与中国最优秀的互联网人才共同成长！

岗位要求：

计算机、通信等相关专业本科及以上学历，熟悉计算机网络体系架构、Unix/Linux操作系统；

熟悉C/C++、python、php、shell等常见语言的一种或多种；

酷爱计算机软/硬件、系统、网络技术，具备强烈的钻研精神和自我学习能力；

乐于尝试新事物，具有迎接挑战、克服困难的勇气；

善于和他人合作，富有集体荣誉感；

具备良好的责任心与服务意识。

注：该岗位“招聘城市”在简历投递截止日前会有部分调整，请密切关注，腾讯公司对招聘信息保留最终解释权。

工作地点：深圳总部 北京 上海 天津

招聘城市：成都 西安 广州 上海 重庆 北京 南京 深圳 武汉



产品类

游戏策划培训生

岗位描述：

如果您是一名狂热的游戏爱好者，在无数个游戏伴随的日夜里，总是灵感迸发，脑洞大开，幻想着能按照您的想法做出一款游戏，那么，这里就是把你绝妙创意变成真实游戏的最佳舞台。

在这里，您是一名恢宏世界的架构师，整个游戏世界，和游戏中形形色色的生态系统都将由您构建，可能包括系统、交互、数值、文案等设计。

在这里，您也必须是一名精雕细琢的匠人，不断与玩家交流，反推其他游戏，在数据中找出问题，然后用匠人一般严谨的态度，协调与你一起工作的美术和程序团队，一点一滴的在游戏中实现，并不断改进。

随着公司的不断发展和您的持续积累，您也将会承担越来越重要的责任，发掘新的游戏类型，探索新的市场机会，成为一名游戏制作人，带领团队从无到有的去实现一款游戏。

加入我们，用心创造快乐。

岗位要求：

专业不限，综合素质扎实，学科成绩优秀；

具有优秀的学习能力、创造力、沟通能力、逻辑思维、系统分析与文字组织能力，能从思考事物规律中获得乐趣；

热爱互联网，对行业发展有清晰认识，对所使用过的互联网产品有独立和深入的见解，对用户需求有较好的识别能力和把控能力；

良好的团队协作能力、强烈的责任心、务实精神，工作脚踏实地，能够承受高强度的工作压力；

热爱游戏，有游戏策划案撰写、具有一定程序设计概念以及有各类网络游戏经验者优先。
热爱生活、关注人性。

注：该岗位“招聘城市”在简历投递截止日前会有部分调整，请密切关注，腾讯公司对招聘信息保留最终解释权。

工作地点：深圳总部 北京 上海 成都

招聘城市：成都 西安 广州 上海 杭州 北京 南京 深圳 武汉 San Francisco



产品策划/运营

岗位描述：

从事腾讯旗下某一个产品的设计/策划/运营工作，为亿万互联网用户设计最优秀的互联网在线生活服务，追求用户价值与公司经济效益的双赢。

岗位要求：

本科或以上学历；

对开发、测试、运营、设计有一定了解；

对互联网产品极度热爱，怀揣着做出最优秀互联网产品的梦想，具备敏捷的洞察和思维能力，并且有把思考变为现实以满足用户需求的勇气和能力；

优秀的创造力、想象力、逻辑思维与系统分析能力，突出的文字组织能力和沟通能力；

有以下经验者优先：开发设计过个人产品并有一定影响；全国互联网产品/创业大赛中获得三等奖及其以上；在互联网公司有产品策划或运营工作实习经历；在实验室或校园技术团队有互联网产品策划项目。

注：招聘城市根据项目类型有所不同，其中，暑期实习招聘城市为下方除补录外全部“招聘城市”。校园招聘（2018届）招聘城市请选择：补录。该岗位“招聘城市”在简历投递截止日前会有部分调整，请密切关注，腾讯公司对招聘信息保留最终解释权。

工作地点：深圳总部 北京 上海 广州 成都

招聘城市：成都 西安 广州 哈尔滨 上海 杭州 重庆 北京 南京 深圳 长沙 武汉 补录



市场/职能类

内容运营

岗位描述：

从事腾讯网资讯频道内容编辑工作，负责网站新闻内容发布、栏目更新、专题及线上活动的策划和制作、外出采访等工作，为全球用户提供服务，通过强大的实时新闻和全面深入的信息资讯，为数以亿计的互联网用户提供权威、主流、时尚的咨询信息及产品服务，开创富有创意的网上新生活。

岗位要求：

综合素质扎实，学科成绩优秀，新闻、中文、外语、财经等专业优先。

熟悉媒体行业现状和发展趋势，了解消费者行为分析，知识面广文笔出色，具有媒体实习或网页制作设计经验者优先。

具有优秀的学习能力、创造力、沟通能力、逻辑思维、系统分析与文字组织能力。
热爱互联网，对互联网内容资讯和产品有独立和深入的见解。

注：招聘城市根据项目类型有所不同，其中，暑期实习招聘城市为下方除补录外全部“招聘城市”。校园招聘（2018届）招聘城市请选择：补录该岗位“招聘城市”在简历投递截止日前会有部分调整，请密切关注，腾讯公司对招聘信息保留最终解释权。

工作地点：深圳总部 北京

招聘城市：北京 武汉 补录

注：更多职位详情请点击“网申入口”查看
"""

class OnlineApplyShowViewController: BaseShowJobViewController {
    
    // 自定义头部
    private lazy var headerView: tableHeader = tableHeader()
    
    // 根据 id  查询数据
    var onlineApplyID:String?{
        didSet{
            self.loadData()
        }
    }
    // 消息体
    private var mode:OnlineApplyModel?
    
    
    private lazy var apply:UIButton = { [unowned self] in
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width:  ScreenW - collectedBtn.width + 20, height: TOOLBARH))
        
        apply.addTarget(self, action: #selector(onlineApply(_:)), for: .touchUpInside)
        apply.setTitle("申请", for: .normal)
        apply.setTitleColor(UIColor.white, for: .normal)
        apply.backgroundColor = UIColor.blue
        return apply
        
    }()
    
    
    
    private lazy var showJobsBackGround:UIButton = {
        let btn = UIButton(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        btn.backgroundColor = UIColor.lightGray
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(hiddenJobs), for: .touchUpInside)
        
        return btn
        
    }()
    private lazy var  showJobsView: ShowApplyJobsView = {
        let view = ShowApplyJobsView.init(frame: CGRect.init(x: 0, y: ScreenH, width: ScreenW, height: 0))
        view.delegate = self
        return view
    }()
  
    
    private lazy var navTitle:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    private lazy var naviBackView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        view.backgroundColor = UIColor.green
        view.alpha = 0
        view.addSubview(navTitle)
        _ = navTitle.sd_layout().centerXEqualToView(view)?.bottomSpaceToView(view,15)?.autoHeightRatio(0)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(mode == nil, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.view.insertSubview(naviBackView, at: 1)
         UIApplication.shared.keyWindow?.addSubview(showJobsView)

        (self.navigationController as? JobHomeNavigation)?.currentStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
        naviBackView.removeFromSuperview()
        self.navigationController?.navigationBar.tintColor = UIColor.black
 
        (self.navigationController as? JobHomeNavigation)?.currentStyle = .default
        
        showJobsView.removeFromSuperview()
        

        
    }
    
    override func setViews(){
        super.setViews()
        
        
        table.backgroundColor = UIColor.viewBackColor()
        table.contentInsetAdjustmentBehavior = .never
        
        table.dataSource = self
        table.delegate = self
        table.register(applyJobsCell.self, forCellReuseIdentifier: applyJobsCell.identity())
        
        // share 分享界面代理
        shareapps.delegate = self
        
        // 加入申请按钮，按钮长度填充toolbar长度，不产生空隙
        let rightSpace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        rightSpace.width = 20
        
        
        
        self.toolbarItems?.append(rightSpace)
        self.toolbarItems?.append(UIBarButtonItem.init(customView: apply))
        let last = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        last.width = -20
        self.toolbarItems?.append(last)
        // 先影藏底部bar
        
        
    }
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
        navTitle.text = mode?.name
        showJobsView.jobs = mode?.positions ?? []
        
        headerView.mode = mode
        headerView.layoutSubviews()
        table.tableHeaderView = headerView
        table.reloadData()

        collectedBtn.isSelected =  mode!.isCollected!
        
        self.navigationController?.setToolbarHidden(false, animated: true)

    }
    
    override func reload() {
        super.reload()
        
    }
    
    // 收藏
    override func collected(_ btn:UIButton){
        let str  = collectedBtn.isSelected ? "取消收藏" : "收藏成功"
        collectedBtn.isSelected = !collectedBtn.isSelected
        showOnlyTextHub(message: str, view: self.view)
        
        mode?.isCollected = collectedBtn.isSelected
        
        
    }

}


extension OnlineApplyShowViewController: showApplyJobsDelegate{
    
    func cancel(view: ShowApplyJobsView) {
        self.hiddenJobs()
    }
    
    func apply(view: ShowApplyJobsView, jobIndex: Int) {
        self.hiddenJobs()
        print("投递职位 \(jobIndex)")
    }
    
    
}

extension OnlineApplyShowViewController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY:CGFloat = scrollView.contentOffset.y
        
        if scrollView == self.table{
            
            if offSetY > 0 && offSetY < 64{
                naviBackView.alpha = offSetY / 64
            }else if offSetY >= 64 {
                naviBackView.alpha = 1
            }else{
                naviBackView.alpha = 0
            }
        }
    }
}
// share分享代理实现
extension OnlineApplyShowViewController:shareViewDelegate{
    
    func handleShareType(type: UMSocialPlatformType, view: UIView) {
        
        
        switch type {
        case .copyLink:
            self.copyToPasteBoard(text: "这是文本内容")
            
        case .more:
            // 文本
            self.openMore(text: "打开的内容", site: URL.init(string: "http://www.baidu.com"))
            
        
        
        case .wechatTimeLine, .wechatSession, .QQ, .qzone, .sina:
            self.shareToApp(type: type, view: view, title: "分享标题", des: "分享描述", url: "http://www.hangge.com/blog/cache/detail_641.html", image: UIImage.init(named: "chrome"))
          
            
        default:
           break
            
        }
        // 影藏shareview
        shareapps.dismiss()
        
    }
}


// 公司主页网申
extension OnlineApplyShowViewController{
    @objc private func onlineApply(_ btn:UIButton){
        // 识别职位投递简历??
        guard  let jobs = mode?.positions, jobs.count > 0 else {
            return
        }
        
        let height = CGFloat(min(jobs.count, 7) * 40) + 80
        self.navigationController?.view.addSubview(showJobsBackGround)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.showJobsView.frame = CGRect.init(x: 0, y: ScreenH - height, width: ScreenW, height: height)
        }, completion: nil)
        
    }
    
    @objc private func hiddenJobs(){
        
        showJobsBackGround.removeFromSuperview()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.showJobsView.frame = CGRect.init(x: 0, y: ScreenH, width: ScreenW, height: 0)
        }, completion: nil)
    }
}

extension OnlineApplyShowViewController{
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 1)
            // 1 获取网申信息
            guard let data = OnlineApplyModel(JSON: ["id":"sdqwd","isValidate":true,"isCollected":false,
                                                     "name":"某某莫小元招聘网申","create_time":Date().timeIntervalSince1970 - TimeInterval(54364),"end_time":Date().timeIntervalSince1970 + TimeInterval(54631),"outer":false,"address":["地点1","地点2"],"companyIcon":"sina",
                                                     "companyName":"公司名称","positions":["职位1","当前为多","当前为多无群","当前为多"],"content":content]) else {
                
                DispatchQueue.main.async(execute: {
                    print("获取数据失败")
                })
                
                return
            }
            self?.mode = data
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self?.didFinishloadData()
            })
        }
       
        
    }
}

extension OnlineApplyShowViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: applyJobsCell.identity(), for: indexPath) as! applyJobsCell
        cell.mode = mode?.content
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.cellHeight(for: indexPath, model: mode?.content, keyPath: "mode", cellClass: applyJobsCell.self, contentViewWidth: ScreenW)
    }
    
}



private class tableHeader:UIView{
    
    
    private lazy var icon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var name:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var addressIcon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.image = #imageLiteral(resourceName: "marker")
        return img
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var timeIcon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.image = #imageLiteral(resourceName: "month")
        return img
    }()
    private lazy var time:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var positionIcon:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.image = #imageLiteral(resourceName: "briefcase")
        return img
    }()
    
    private lazy var positions:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var mode:OnlineApplyModel?{
        didSet{
            
            guard  let mode = mode  else {
                return
            }
            
            self.icon.image = UIImage.init(named: mode.companyIcon)
            self.address.text = mode.address?.joined(separator: " ")
            self.time.text = "截止时间: " + mode.endTimeStr
            self.name.text = mode.companyName
            self.positions.text = mode.positions?.joined(separator: " ")
            self.setupAutoHeight(withBottomViewsArray: [icon,time], bottomMargin: 5)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
        
        let views:[UIView] = [icon, name, addressIcon, address,timeIcon, time, positions, positionIcon]
        self.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self, NavH)?.widthIs(45)?.heightIs(45)
        _ = name.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = addressIcon.sd_layout().topSpaceToView(name,5)?.leftEqualToView(name)?.widthIs(15)?.heightIs(15)
        _ = address.sd_layout().leftSpaceToView(addressIcon,10)?.topEqualToView(addressIcon)?.autoHeightRatio(0)
        _ = positionIcon.sd_layout().topSpaceToView(addressIcon,5)?.leftEqualToView(addressIcon)?.widthRatioToView(addressIcon,1)?.heightRatioToView(addressIcon,1)
        _ = positions.sd_layout().leftSpaceToView(positionIcon,10)?.topEqualToView(positionIcon)?.autoHeightRatio(0)
        
        _ = timeIcon.sd_layout().topSpaceToView(positionIcon,5)?.leftEqualToView(positionIcon)?.widthRatioToView(positionIcon,1)?.heightRatioToView(positionIcon,1)
        _ = time.sd_layout().leftSpaceToView(timeIcon,10)?.topEqualToView(timeIcon)?.autoHeightRatio(0)
        
        address.setMaxNumberOfLinesToShow(2)
        name.setMaxNumberOfLinesToShow(2)
        positions.setMaxNumberOfLinesToShow(2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
