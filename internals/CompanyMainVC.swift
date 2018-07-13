//
//  CompanyMainVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let cellIdentity:String = "cell"

class CompanyMainVC: BaseViewController {
    

    static var headerViewH:CGFloat = 0
    static var headerThreld:CGFloat = 0
    
    // 从job 页面跳转过来
    var companyID:String?{
        didSet{
            loadData()
        }
    }
    
    private  var mode:CompanyModel?
    
    
    private lazy var collectedBtn:UIButton = {
        // 收藏
        
      

        let collected = UIImage.init(named: "heart")!.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        btn.addTarget(self, action: #selector(collectedCompany(btn:)), for: .touchUpInside)
        btn.setImage(collected, for: .normal)
        
       
        
        let selectedCollection =  UIImage.init(named: "selectedHeart")!.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        
        
        btn.setImage(selectedCollection, for: .selected)
        btn.clipsToBounds = true
        
        return btn
    }()
    
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
    
// 分享界面
    private lazy var shareapps:shareView = { [unowned self] in
        //放在最下方
        let view =  shareView(frame: CGRect(x: 0, y: ScreenH, width: ScreenW, height: shareViewH))
        view.delegate = self
        return view
    }()
    
    
    
    private lazy var headerView:CompanyHeaderView = {
        let header = CompanyHeaderView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: 0))
        header.backgroundColor = UIColor.white
        header.delegate = self
        return header
    
    }()
    
    
    private var isClick:Bool = false
    
    private var subVC:[UIViewController] = []
    private lazy var companyDetail:CompanyDetailVC = CompanyDetailVC()
    private lazy var companyJobs:CompanyJobsVC = CompanyJobsVC()
    private lazy var companyCarrerTalk:CompanyCareerTalkVC = CompanyCareerTalkVC()
    
    
    private var barItems:[UIButton] = []
    
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
        //self.navigationItem.title = "公司详情"
        self.navigationController?.insertCustomerView()
        UIApplication.shared.keyWindow?.addSubview(shareapps)

        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        shareapps.removeFromSuperview()
        
        
    }
    
    override func setViews() {
        
        self.title = "公司详情"
        self.view.backgroundColor = UIColor.viewBackColor()
        self.addChildViewController(companyDetail)
        self.addChildViewController(companyJobs)
        self.addChildViewController(companyCarrerTalk)
        
        subVC.append(companyDetail)
        subVC.append(companyJobs)
        subVC.append(companyCarrerTalk)
        
        // 顺序
        self.view.addSubview(collectionView)
        self.view.addSubview(headerView)
        
        self.addSharedBarItem()
        
        companyDetail.delegate = self
        companyJobs.delegate = self
        companyCarrerTalk.delegate = self
        
        _ = collectionView.sd_layout().topSpaceToView(self.view,NavH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
       
        
        self.handleViews.append(collectionView)
        self.handleViews.append(headerView)
        
        barItems.forEach{
            self.handleViews.append($0)
        }
        
        
        super.setViews()
    }
    
    override func didFinishloadData() {
        
        self.headerView.mode = mode
        
        headerView.layoutSubviews()
        CompanyMainVC.headerViewH = headerView.frame.height
 
        
        //  30 是计算的固定值
        CompanyMainVC.headerThreld = CompanyMainVC.headerViewH - 30
        // 调整子vc 的tableheader高度
        companyJobs.joblistTable.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height:  CompanyMainVC.headerViewH)
        companyDetail.detailTable.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: CompanyMainVC.headerViewH)
        companyCarrerTalk.table.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: CompanyMainVC.headerViewH)
        
        
   
        
        // 加载公司数据
        self.companyDetail.detailModel = mode
        self.companyJobs.companyMode =  mode
        self.companyCarrerTalk.mode = mode 
        // 收藏数据从服务器获取??
        
        collectedBtn.isSelected =  (mode?.isCollected)!
     
       
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
            Thread.sleep(forTimeInterval: 1)
            
            DispatchQueue.main.async {
                
                if let data = CompanyModel(JSON:  ["id":"dqw-dqwd","name":"公司名",
                                                   "describe":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面当前为多群无多当前为多群无多群无 当前为多群无多群无当前为多群无多群无多群无当前为多群无多群 \n 当前为多 \n dqwdwq 达瓦大群无、你、\n   dqwdqwdqw当前为多群无多无群多无群多群 当前为多无群当前为多群无多当前为多群无多当前为多群无多当前为多群无当前为多群无多群无","simpleDes":"一家有个性滑动公司当前为多群无多当前为多群无多当前为多群无","address":["地址1","地址2","当前为多群无多","当前为多"],"staffs":"100-200人","icon":"sina","industry":["教育","医疗","化工"],"webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的当前","当前为多","迭代器","群无多当前为多群当前","达瓦大群无多", "当前为多当前的群","当前为多无", "当前为多群无多","杜德伟七多"],"isValidate":true,"isCollected":false]){
                    
                     self?.mode =  data
                     self?.didFinishloadData()
                }else{
                    self?.showError()
                }
                
               
                
            }
            
        }
        
       
    }
    

    
}




extension CompanyMainVC{
    
    // 分享barItem
    private func addSharedBarItem(){
        
        // 分享
  
        
        let up =  UIImage.init(named: "upload")!.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        
        let shareBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        
        shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        shareBtn.setImage(up, for: .normal)
        shareBtn.clipsToBounds = true
        
 
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem.init(customView: shareBtn), UIBarButtonItem.init(customView: collectedBtn)], animated: false)
        
        barItems.append(shareBtn)
        barItems.append(collectedBtn)
        
        
    }
    
    @objc private func share(){
        shareapps.showShare()
    }

    
    @objc func collectedCompany(btn:UIButton){
        // MARK 修改公司状态 已经为收藏
        
        let str =  (mode?.isCollected)! ? "取消收藏" : "收藏成功"
        showOnlyTextHub(message: str, view: self.view)
        btn.isSelected = !(mode?.isCollected)!
        
        mode?.isCollected = !(mode?.isCollected)!
        
    }
    
}


extension CompanyMainVC: CompanyHeaderViewDelegate{
    
    func ScrollContentAtIndex(index: Int) {
        isClick = true
        syncOffset()
        let offsetX = CGFloat(index) * self.collectionView.frame.width
        self.collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        
    }
    
    
}



// shareView代理
extension CompanyMainVC: shareViewDelegate{
  
    
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
        if isClick  {
            return
        }
        
        
        if scrollView == collectionView{
            
            let currentOffsetX = scrollView.contentOffset.x
            var progress:CGFloat = 0
            var sourceIndex =  0
            var targetIndex = 0
            
            let sWidth = scrollView.frame.width
            
            if currentOffsetX > startScrollerOffsetX{
                progress = currentOffsetX / sWidth  - floor( currentOffsetX / sWidth)
                sourceIndex = Int(currentOffsetX / sWidth )
                targetIndex = sourceIndex + 1 >=  subVC.count ? subVC.count - 1 : sourceIndex + 1
                
                if currentOffsetX - startScrollerOffsetX == sWidth{
                    progress = 1
                    targetIndex = sourceIndex
                }
                
                
            }else{
                progress = 1 - (currentOffsetX / sWidth - floor(currentOffsetX / sWidth))
                targetIndex = Int(currentOffsetX / sWidth)
                sourceIndex = targetIndex + 1 >= subVC.count ? subVC.count - 1 : targetIndex  + 1
                
            }
            
            self.headerView.changeTitle(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
            
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isClick = false
        
        if scrollView == collectionView{
            startScrollerOffsetX = scrollView.contentOffset.x
            syncOffset()
        }
    }
    
    
    private func moveSubline(progress:Int,start:CGFloat, distance:CGFloat){
 
    }
    
    //tableview 最大偏移判断
    private func syncOffset(){
        let maxoffset = max(companyDetail.detailTable.contentOffset.y, companyJobs.joblistTable.contentOffset.y, companyCarrerTalk.table.contentOffset.y)
        if maxoffset >= CompanyMainVC.headerThreld{
            if companyDetail.detailTable.contentOffset.y < CompanyMainVC.headerThreld{
                companyDetail.detailTable.contentOffset = CGPoint.init(x: 0, y: CompanyMainVC.headerThreld)
            }
            if companyJobs.joblistTable.contentOffset.y < CompanyMainVC.headerThreld{
                companyJobs.joblistTable.contentOffset = CGPoint.init(x: 0, y: CompanyMainVC.headerThreld)

            }
            if companyCarrerTalk.table.contentOffset.y < CompanyMainVC.headerThreld{
                companyCarrerTalk.table.contentOffset = CGPoint.init(x: 0, y: CompanyMainVC.headerThreld)
            }
        }
    }
}

// table 滑动
extension CompanyMainVC: CompanySubTableScrollDelegate{
    
    func scrollUp(view:UITableView,height:CGFloat){
        
        
        if height >= CompanyMainVC.headerThreld{
            // 改变头部视图
            self.headerView.frame = CGRect.init(x: 0, y: NavH - CompanyMainVC.headerThreld, width: ScreenW, height: CompanyMainVC.headerViewH)
            self.navigationItem.title = mode?.name
            return
            
        }else if height > 0 && height < CompanyMainVC.headerThreld{
            self.headerView.frame = CGRect.init(x: 0, y: NavH - height, width: ScreenW, height: CompanyMainVC.headerViewH)
            
        }else{
            self.headerView.frame = CGRect.init(x: 0, y: NavH, width: ScreenW, height: CompanyMainVC.headerViewH)
            self.navigationItem.title = "公司详情"
            
        }
        
        //低于阈值 需要保证tablevie 偏移保持同步，headerview高度一直显示才正确
        //某个table高于阈值，在切换tableview时，syncOffset保证其它table的偏移最大为阈值，headerview 保证最高处
        
        companyDetail.detailTable.contentOffset = view.contentOffset
        companyJobs.joblistTable.contentOffset = view.contentOffset
        companyCarrerTalk.table.contentOffset = view.contentOffset
        

        
        
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



// 代理
fileprivate protocol CompanyHeaderViewDelegate: class {
    func ScrollContentAtIndex(index:Int)
    
}

fileprivate class CompanyHeaderView:UIView{
    
    var kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
    var kSelectColor : (CGFloat, CGFloat, CGFloat) = (65, 105, 225)
    
    weak var delegate:CompanyHeaderViewDelegate?
    
    private lazy var icon:UIImageView = {
        let img = UIImageView.init()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private lazy var companyName:UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 100)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var des:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 100)
        return label
    }()
    
    private lazy var kinds:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 100)
        return label
    }()
    
    private lazy var detail:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.text = "公司详情"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(click(_:)))
        lb.addGestureRecognizer(tap)
        lb.tag = 0
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var jobs:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.text = "在招职位"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(click(_:)))
        lb.addGestureRecognizer(tap)
        lb.tag = 1
        lb.textAlignment = .center
        return lb
    }()
    
    
    private lazy var talk:UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.lightGray
        lb.text = "宣讲会"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(click(_:)))
        lb.addGestureRecognizer(tap)
        lb.tag = 2
        lb.textAlignment = .center
        return lb
    }()
    
    // btn 下划线
    lazy var underLine:UIView = {  [unowned self] in
        let line = UIView.init(frame: CGRect.zero)
        line.backgroundColor = UIColor.blue
        return line
    }()
    
    // 分割线
    private let line = UIView.init()
    
    private var currentIndexBtn:Int = 0
    
    private var labels:[UILabel] = []
    
    var mode:CompanyModel?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            
            self.icon.image = UIImage.init(named: mode.icon)
            self.companyName.text = mode.name
            self.des.text = mode.simpleDes
            let address = mode.address?.joined(separator: " ") ?? "-"
            let industry = mode.industry?.joined(separator: " ") ?? "-"
            let staff = mode.staffs ?? "-"
            self.kinds.text = address + "|" + industry + "|" + staff
            self.setupAutoHeight(withBottomViewsArray: [detail,jobs], bottomMargin: 5)
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // MARK 修改
        let views:[UIView] = [icon, companyName,des,kinds, line,detail, jobs, underLine,talk]
        self.sd_addSubviews(views)
        labels.append(contentsOf: [detail,jobs,talk])
        // 初始颜色
        detail.textColor = UIColor.init(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        
        line.backgroundColor = UIColor.lightGray
        
        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.widthIs(70)?.heightIs(70)
        _ = companyName.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = kinds.sd_layout().topSpaceToView(companyName,10)?.leftEqualToView(companyName)?.autoHeightRatio(0)
        _ = des.sd_layout().leftEqualToView(companyName)?.topSpaceToView(kinds,5)?.autoHeightRatio(0)
        _ = line.sd_layout().topSpaceToView(des,5)?.leftEqualToView(icon)?.rightEqualToView(self)?.heightIs(1)
        _ = detail.sd_layout().leftSpaceToView(self,20)?.topSpaceToView(line,5)?.widthIs(100)?.heightIs(20)
        _ = jobs.sd_layout().leftSpaceToView(detail, 15)?.topSpaceToView(line,5)?.widthIs(100)?.heightIs(20)
        _ = talk.sd_layout().leftSpaceToView(jobs, 15)?.topSpaceToView(line,5)?.widthIs(100)?.heightIs(20)

   
        
        companyName.setMaxNumberOfLinesToShow(2)
        des.setMaxNumberOfLinesToShow(2)
        kinds.setMaxNumberOfLinesToShow(2)

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        underLine.frame = CGRect.init(x: labels[currentIndexBtn].center.x - 15, y: self.frame.height - 1 , width: 30, height: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension CompanyHeaderView{
    
    open func changeTitle(_ progress:CGFloat, sourceIndex:Int, targetIndex : Int){
        
        let soureBtn = labels[sourceIndex]
        let targetBtn = labels[targetIndex]
        
        let centerDistance = targetBtn.center.x - soureBtn.center.x
        self.underLine.center.x = soureBtn.center.x + centerDistance*CGFloat(progress)
        
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        soureBtn.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetBtn.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        
        
        currentIndexBtn = targetIndex
        
        
    }
    

    @objc private func click(_ sender:UITapGestureRecognizer){
        
        if sender.state != .ended{
            return
        }
        guard let label = sender.view as? UILabel else {
            return
        }
        
        let currentIndex = label.tag
        if currentIndex == currentIndexBtn{
            return
        }
        
        let oldBtn  = labels[currentIndexBtn]
        let centerDistance =  labels[currentIndex].center.x - oldBtn.center.x
        
        self.labels[currentIndex].textColor = UIColor.init(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        oldBtn.textColor = UIColor.init(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        
        UIView.animate(withDuration: 0.3) {
            self.underLine.center.x = oldBtn.center.x + centerDistance
        }
        
        currentIndexBtn = currentIndex
        
        self.delegate?.ScrollContentAtIndex(index: currentIndex)
        
    }
    
}
