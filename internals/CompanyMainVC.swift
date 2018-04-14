//
//  CompanyMainVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let headerViewH:CGFloat =  100
fileprivate let cellIdentity:String = "cell"
fileprivate let headerThreld:CGFloat = 70


class CompanyMainVC: BaseViewController {
    
    
    
    private var mode:CompanyDetailModel?

    // 本地数据库 companytable
    private lazy var companyTable = DBFactory.shared.getCompanyDB()
    
    var companyID:String?{
        didSet{
            loadData()
        }
    }
    
    
    
    private lazy var flowLayout:UICollectionViewFlowLayout = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        // 与顶部留出间隔
        layout.itemSize = CGSize.init(width: ScreenW, height: ScreenH -  NavH)
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
    private lazy var collectionView:UICollectionView = {  [unowned self] in
        let coll = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        coll.delegate = self
        coll.dataSource = self
        coll.bounces = false
        coll.scrollsToTop = false
        coll.isPagingEnabled = true
        coll.backgroundColor = UIColor.viewBackColor()
        //coll.autoresizingMask  = [.flexibleWidth,.flexibleHeight]
        coll.showsVerticalScrollIndicator = false
        coll.showsHorizontalScrollIndicator = false
        coll.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentity)
        return coll
    }()
    
    
    private var ShareViewCenterY:CGFloat = 0
    // 分享界面
    private lazy var shareapps:shareView = { [unowned self] in
        //放在最下方
        let view =  shareView(frame: CGRect(x: 0, y: ScreenH, width: ScreenW, height: shareViewH))
        view.delegate = self
        // 加入最外层窗口
        UIApplication.shared.keyWindow?.addSubview(view)
        ShareViewCenterY = view.centerY
        return view
    }()
    
    private lazy var darkView :UIView = { [unowned self] in
        let darkView = UIView()
        darkView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        darkView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
        darkView.isUserInteractionEnabled = true // 打开用户交互
        let singTap = UITapGestureRecognizer(target: self, action:#selector(self.handleSingleTapGesture)) // 添加点击事件
        singTap.numberOfTouchesRequired = 1
        darkView.addGestureRecognizer(singTap)
        return darkView
        
    }()
    
    
    private lazy var headerView:CompanyHeaderView = {
        let header = CompanyHeaderView.init(frame: CGRect.zero)
        header.backgroundColor = UIColor.white
        return header
    
    }()
    
    
    
    private var subVC:[UIViewController] = []
    private lazy var companyDetail:CompanyDetailVC = CompanyDetailVC()
    private lazy var companyJobs:CompanyJobsVC = CompanyJobsVC()
    
    private var barItems:[UIButton] = []
    private var isCollected:Bool = false
    
    //
    // scorllerStartX
    private var startScrollerOffsetX:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "公司详情"
        self.navigationController?.insertCustomerView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        shareapps.removeFromSuperview()
        
        
    }
    
    override func setViews() {
        self.view.backgroundColor = UIColor.viewBackColor()
        self.addChildViewController(companyDetail)
        self.addChildViewController(companyJobs)
        subVC.append(companyDetail)
        subVC.append(companyJobs)
        // 顺序
        self.view.addSubview(collectionView)
        self.view.addSubview(headerView)
        
        self.addSharedBarItem()
        
        companyDetail.delegate = self
        companyJobs.delegate = self
        
        headerView.btn1.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        headerView.btn2.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        
        _ = headerView.sd_layout().yIs(NavH)?.rightEqualToView(self.view)?.leftEqualToView(self.view)?.heightIs(headerViewH)
        headerView.underLine.frame = CGRect.init(x: headerView.btn1.center.x + 15, y: headerView.frame.height - 1 , width: 30, height: 1)
        _ = collectionView.sd_layout().topSpaceToView(self.view,NavH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
       
        
        self.handleViews.append(collectionView)
        self.handleViews.append(headerView)
        
        barItems.forEach{
            self.handleViews.append($0)
        }
        
        
        super.setViews()
    }
    
    override func didFinishloadData() {
        if let mode = mode{
            self.headerView.mode = mode
            // 加载公司数据
            self.companyDetail.detailModel = mode
            // 收藏数据从服务器获取??
            
            isCollected = companyTable.isCollectedBy(id: companyID!)
            barItems.last?.isSelected = isCollected
        }
        
        
        super.didFinishloadData()
        
    }

    override func reload() {
        super.reload()
        self.loadData()
        
    }
}



extension CompanyMainVC{
    
    private func loadData(){
        
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            
            DispatchQueue.main.async {
                
                self?.mode =  CompanyDetailModel(JSON:  ["address":"地址 北京 - 定位","webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的打到我","好id多多多多多无多无多付付","有多长好长","没有嘛yiu哦郁闷yiu","标签1","标签12","标签1等我大大哇","分为发违法标签99"]
                    ,"name":"sina","describe":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n","simpleDes":"新浪微博个性化","simpleTag":["北京","2000人以上","互联网"]])
                self?.didFinishloadData()
            }
            
        }
        
       
    }
    
    
    
    
}


extension CompanyMainVC{
    
    @objc func click(_ sender:UIButton){
        
        
        syncOffset()
        
        let offsetX = CGFloat(sender.tag - 1) * self.collectionView.frame.width
        self.collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        self.headerView.underLine.center.x = sender.center.x
        self.headerView.chooseBtn1 = sender.tag == 1 ? true : false
        
    }
}


extension CompanyMainVC{
    
    // 分享barItem
    private func addSharedBarItem(){
        
        // 分享
        let up =  UIImage.barImage(size: CGSize.init(width: 25, height: 25), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "upload")
        
        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        
        b1.addTarget(self, action: #selector(share), for: .touchUpInside)
        b1.setImage(up, for: .normal)
        b1.clipsToBounds = true
        
        // 收藏
        let collected = UIImage.barImage(size: CGSize.init(width: 25, height: 25), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "heart")
        
        let b2 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b2.addTarget(self, action: #selector(collectedCompany(btn:)), for: .touchUpInside)
        b2.setImage(collected, for: .normal)
        
        let selectedCollection = UIImage.barImage(size: CGSize.init(width: 25, height: 25), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "selectedHeart")
        
        b2.setImage(selectedCollection, for: .selected)
        b2.clipsToBounds = true
        b2.isSelected = self.isCollected
        
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem.init(customView: b1), UIBarButtonItem.init(customView: b2)], animated: false)
        
        barItems.append(b1)
        barItems.append(b2)
        
        
    }
    
    
    @objc func share(){
        
        self.navigationController?.view.addSubview(darkView)
                UIView.animate(withDuration: 0.5, animations: {
        
                    self.shareapps.frame = CGRect(x: 0, y: ScreenH - shareViewH, width: ScreenW, height: shareViewH)
                }, completion: nil)
        
    }
    
    @objc func collectedCompany(btn:UIButton){
        // MARK 修改公司状态 已经为收藏
        
        
        if !isCollected{
            showOnlyTextHub(message: "收藏成功", view: self.view)
            //jobManageRoot.addCompanyItem(item: comapnyInfo(JSON: json)!)
            isCollected = true
            btn.isSelected = true
            companyTable.setCollectedBy(id: companyID!)
        }else{
            //jobManageRoot.removeCollectedCompany(item: comapnyInfo(JSON: json)!)
            showOnlyTextHub(message: "取消收藏", view: self.view)
            isCollected = false
            btn.isSelected = false
            companyTable.unCollected(id: companyID!)
        }
        
    }
    
        @objc func handleSingleTapGesture() {
            // 点击移除半透明的View
            darkView.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
    
                self.shareapps.centerY =  self.ShareViewCenterY
            }, completion: nil)
    
        }
}


// shareView代理
extension CompanyMainVC: shareViewDelegate{
    func hiddenShareView(view:UIView){
        self.handleSingleTapGesture()
    }
    func handleShareType(type: UMSocialPlatformType) {
        if type.rawValue == 1002{
            let activiController = UIActivityViewController.init(activityItems: ["dwdwqd"], applicationActivities: nil)
            activiController.excludedActivityTypes = [UIActivityType.postToTencentWeibo, UIActivityType.postToWeibo]
            self.present(activiController, animated: true, completion: nil)
        }
    }
    
}

extension CompanyMainVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView{
            
            let currentOffsetX = scrollView.contentOffset.x
            var progress:CGFloat = 0
            let left = self.headerView.btn1.center.x
            let right = self.headerView.btn2.center.x
            let distance = right - left
            
            
            
            if currentOffsetX > startScrollerOffsetX{
                    progress = currentOffsetX / scrollView.width
                    self.moveSubline(progress: progress, start: left, distance: distance)
            }else{
                
                    progress = (currentOffsetX / scrollView.width) - 1
                    self.moveSubline(progress: progress, start: right, distance: distance)
                
            }
            
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionView{
            startScrollerOffsetX = scrollView.contentOffset.x
            syncOffset()
        }
    }
    
    
    private func moveSubline(progress:CGFloat,start:CGFloat, distance:CGFloat){
        self.headerView.underLine.center.x = start + distance*progress
        if progress == 1{
            self.headerView.chooseBtn1 =  false
        }else if progress == -1{
            self.headerView.chooseBtn1 = true
        }
    }
    
    //tableview 最大偏移判断
    private func syncOffset(){
        let maxoffset = max(companyDetail.detailTable.contentOffset.y, companyJobs.joblistTable.contentOffset.y)
        if maxoffset >= headerThreld{
            if companyDetail.detailTable.contentOffset.y < headerThreld{
                companyDetail.detailTable.contentOffset = CGPoint.init(x: 0, y: headerThreld)
            }
            if companyJobs.joblistTable.contentOffset.y < headerThreld{
                companyJobs.joblistTable.contentOffset = CGPoint.init(x: 0, y: headerThreld)

            }
        }
    }
}

// table 滑动
extension CompanyMainVC: CompanySubTableScrollDelegate{
    
    func scrollUp(view:UITableView,height:CGFloat){
        
        
        if height >= headerThreld{
            // 改变头部视图
            self.headerView.frame = CGRect.init(x: 0, y: NavH - headerThreld, width: ScreenW, height: headerViewH)
            self.navigationItem.title = mode?.name
            return
            
        }else if height > 0 && height < headerThreld{
            self.headerView.frame = CGRect.init(x: 0, y: NavH - height, width: ScreenW, height: headerViewH)
            
        }else{
            self.headerView.frame = CGRect.init(x: 0, y: NavH, width: ScreenW, height: headerViewH)
            
        }
        self.navigationItem.title = "公司详情"
        //低于阈值 需要保证tablevie 偏移保持同步，headerview高度一直显示才正确
        //某个table高于阈值，在切换tableview时，syncOffset保证其它table的偏移最大为阈值，headerview 保证最高处
        
        companyDetail.detailTable.contentOffset = view.contentOffset
        companyJobs.joblistTable.contentOffset = view.contentOffset
        

        
        
    }
}

extension CompanyMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subVC.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        return
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentity, for: indexPath)
        let vc = subVC[indexPath.row]
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)
        return cell
    }
    
  
    
}




fileprivate class CompanyHeaderView:UIView{
    
    private lazy var icon:UIImageView = {
        let img = UIImageView.init()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var companyName:UILabel = {
        let label = UILabel.init()
        label.text = ""
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var des:UILabel = {
        let label = UILabel.init()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
        return label
    }()
    
    private lazy var tags:UILabel = {
        let label = UILabel.init()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
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
    // btn 下划线
    lazy var underLine:UIView = {  [unowned self] in
        let line = UIView.init(frame: CGRect.zero)
        line.backgroundColor = UIColor.blue
        return line
        }()
    // 分割线
    private let line = UIView.init()
    
    var mode:CompanyDetailModel?{
        didSet{
            self.icon.image = UIImage.init(named: mode?.iconURL ?? "default")
            self.companyName.text = mode?.name
            self.des.text = mode?.simpleDes
            var tags  = ""
            for (index,item) in (mode!.simpleTag?.enumerated())!{
                
                tags += item +  (index == mode?.tags?.count ? "" : "|")
            }
            self.tags.text = tags
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // MARK 修改
        //underLine.frame = CGRect.init(x: self.btn1.center.x, y: 109 , width: 30, height: 1)
        let views:[UIView] = [icon, companyName,des,tags, line,btn1, btn2, underLine]
        self.sd_addSubviews(views)
        
        line.backgroundColor = UIColor.lightGray
        
        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.widthIs(50)?.heightIs(60)
        _ = companyName.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = des.sd_layout().leftEqualToView(companyName)?.topSpaceToView(companyName,2)?.autoHeightRatio(0)
        _ = tags.sd_layout().leftEqualToView(companyName)?.topSpaceToView(des,2)?.autoHeightRatio(0)
        _ = line.sd_layout().topSpaceToView(icon,5)?.leftEqualToView(icon)?.rightEqualToView(self)?.heightIs(1)
        _ = btn1.sd_layout().leftSpaceToView(self,30)?.topSpaceToView(line,5)?.widthIs(120)?.heightIs(20)
        _ = btn2.sd_layout().rightSpaceToView(self,30)?.topSpaceToView(line,5)?.widthIs(120)?.heightIs(20)
        //_ = underLine.sd_layout().centerXEqualToView(btn1)?.widthIs(30)?.heightIs(1)?.bottomEqualToView(self)
        companyName.setMaxNumberOfLinesToShow(1)
        des.setMaxNumberOfLinesToShow(1)
        tags.setMaxNumberOfLinesToShow(1)
        //underLine.frame =  CGRect.init(x: btn1.center.x + 15, y: self.frame.height - 1 , width: 30, height: 1)
        // 约束关系，父类view frame 改变 会重新应用最初的约束关系
        //_ = underLine.sd_layout().bottomEqualToView(self)?.centerXEqualToView(btn1)?.widthIs(30)?.heightIs(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
