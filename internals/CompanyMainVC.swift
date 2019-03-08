//
//  CompanyMainVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Kingfisher

fileprivate let cellIdentity:String = "cell"
fileprivate let vcTitle:String = "公司详情"
fileprivate var headerThreld:CGFloat = 0
fileprivate let shareViewH = SingletoneClass.shared.shareViewH




private class contentCollection:UICollectionView, UICollectionViewDelegate {
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    private var vcs:BehaviorRelay<[UIViewController]> = BehaviorRelay<[UIViewController]>.init(value: [])
    private weak var vc:CompanyMainVC?
    private var startScrollerOffsetX:CGFloat = 0
    
    convenience  init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout,  vcs: [UIViewController], vc:CompanyMainVC) {
        self.init(frame: frame, collectionViewLayout: layout)
        self.vcs.accept(vcs)
        self.vc = vc
        
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
  
        self.rx.setDelegate(self).disposed(by: self.dispose)
        //coll.dataSource = self
        self.bounces = false
        self.scrollsToTop = false
        self.isPagingEnabled = true
        self.backgroundColor = UIColor.viewBackColor()
        //coll.autoresizingMask  = [.flexibleWidth,.flexibleHeight]
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentity)
        
        setViewModel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setViewModel(){
        self.vcs.bind(to: self.rx.items(cellIdentifier: cellIdentity, cellType: UICollectionViewCell.self)){
            index, model, cell in
            
            model.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(model.view)
            
        }.disposed(by: self.dispose)
        
        self.rx.itemSelected.subscribe(onNext: { indexPath in
            self.deselectItem(at: indexPath, animated: true)
        }).disposed(by: self.dispose)
        
        self.rx.didScroll.subscribe(onNext: { _ in
            if self.vc?.isClick ?? true  {
                return
            }
            
            
            let currentOffsetX = self.contentOffset.x
            var progress:CGFloat = 0
            var sourceIndex =  0
            var targetIndex = 0
            
            let sWidth = self.frame.width
            
            if currentOffsetX > self.startScrollerOffsetX{
                progress = currentOffsetX / sWidth  - floor( currentOffsetX / sWidth)
                sourceIndex = Int(currentOffsetX / sWidth )
                targetIndex = sourceIndex + 1 >=  self.vcs.value.count ? self.vcs.value.count - 1 : sourceIndex + 1
                
                if currentOffsetX - self.startScrollerOffsetX == sWidth{
                    progress = 1
                    targetIndex = sourceIndex
                }
                
                
            }else{
                progress = 1 - (currentOffsetX / sWidth - floor(currentOffsetX / sWidth))
                targetIndex = Int(currentOffsetX / sWidth)
                sourceIndex = targetIndex + 1 >= self.vcs.value.count ? self.vcs.value.count - 1 : targetIndex  + 1
                
            }
            
            self.vc?.changeTitle(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
            
            
            
        }).disposed(by: self.dispose)
        
        
        self.rx.willBeginDragging.subscribe(onNext: { _ in
            self.vc?.isClick = false
            self.startScrollerOffsetX = self.contentOffset.x
            self.vc?.syncOffset()
        }).disposed(by: self.dispose)
    }
    
    
}



private class collectingBtn:UIButton {
    
    
    private lazy var collectImg:UIImage = {
       return UIImage.init(named: "heart")!.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
    }()
    
    private lazy var selectedCollectImg:UIImage = {
       return  UIImage.init(named: "selectedHeart")!.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(collectImg, for: .normal)
        self.setImage(selectedCollectImg, for: .selected)
        self.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class CompanyMainVC: BaseViewController {
    
    // 共同的headview高度
    static var headerViewH:CGFloat = 0
    
    // 从job 页面跳转过来
    internal var companyID:String?{
        didSet{
            query.onNext(companyID!)
        }
    }
    
    private  var mode:CompanyModel?{
        didSet{
            self.didFinishloadData()
        }
    }
    
    
    private lazy var collectedBtn:collectingBtn = {
        // 收藏
        let btn = collectingBtn.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        btn.addTarget(self, action: #selector(collectedCompany(btn:)), for: .touchUpInside)
        return btn
    }()
    
   
    private lazy var collectionView:contentCollection = {  [unowned self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        // 与顶部留出间隔
        layout.itemSize = CGSize.init(width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH -  GlobalConfig.NavH)
        layout.scrollDirection = .horizontal
        let coll = contentCollection.init(frame: CGRect.zero, collectionViewLayout: layout, vcs: self.subVC, vc: self)
        return coll
    }()
    
// 分享界面
    private lazy var shareapps:ShareView = { [unowned self] in
        //放在最下方
        let view =  ShareView(frame: CGRect(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: shareViewH))
        view.delegate = self
        return view
    }()
    
    
    
    private lazy var headerView:companyHeaderView = {
        let header = companyHeaderView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: 0))
        header.backgroundColor = UIColor.white
        header.delegate = self
        return header
    
    }()
    
    // 记录点击
    internal var isClick:Bool = false
    
    private var subVC:[UIViewController] = []
    private lazy var companyDetail:CompanyDetailVC = {
       let c = CompanyDetailVC()
       self.subVC.append(c)
       c.delegate = self
       return c
    }()
    
    private lazy var companyJobs:CompanyJobsVC = {
       let c = CompanyJobsVC()
       self.subVC.append(c)
       c.delegate = self
       return c
    }()
    private lazy var companyCarrerTalk:CompanyCareerTalkVC = {
       let c = CompanyCareerTalkVC()
       self.subVC.append(c)
       c.delegate = self
       return c
    }()
    
   
    
    
    
    //rxSwift
    let dispose = DisposeBag()
    let vm:RecruitViewModel = RecruitViewModel()
    let query:BehaviorSubject<String> = BehaviorSubject<String>.init(value: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        setViewModel()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        self.navigationController?.insertCustomerView()
        UIApplication.shared.keyWindow?.addSubview(shareapps)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.removeCustomerView()
        shareapps.removeFromSuperview()
        
        
    }
    
    override func setViews() {
        
        self.addSharedBarItem()
        self.title = vcTitle
        self.view.backgroundColor = UIColor.viewBackColor()
        
        self.addChild(companyDetail)
        self.addChild(companyJobs)
        self.addChild(companyCarrerTalk)
        
        
        // 顺序
        self.view.addSubview(collectionView)
        self.view.addSubview(headerView)
        self.hiddenViews.append(collectionView)
        self.hiddenViews.append(headerView)
        
        
        super.setViews()
    }
    
    override func didFinishloadData() {
        
        self.headerView.mode = mode
        headerView.layoutSubviews()
        CompanyMainVC.headerViewH = headerView.frame.height
 
        
        //  line 到
       
        headerThreld = CompanyMainVC.headerViewH - self.headerView.getLineToBottonDistance()
        // 调整子vc 的tableheader高度
        companyJobs.joblistTable.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height:  CompanyMainVC.headerViewH)
        companyDetail.detailTable.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: CompanyMainVC.headerViewH)
        companyCarrerTalk.table.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: CompanyMainVC.headerViewH)
        
        
   
        
        // 加载公司数据
        self.companyDetail.detailModel = mode
        self.companyJobs.companyMode =  mode
        self.companyCarrerTalk.mode = mode 
        // 收藏数据从服务器获取??
        
        collectedBtn.isSelected =  mode?.isCollected ?? false 
     
       
        super.didFinishloadData()
        
    }

    override func reload() {
        super.reload()
        self.query.onNext(self.companyID!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        _ = collectionView.sd_layout().topSpaceToView(self.view,GlobalConfig.NavH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }
    
    @objc override internal  func login(){
        //print("login")
        let loginvc = UIStoryboard.init(name: GlobalConfig.StoryBordVCName.Main, bundle: nil).instantiateViewController(withIdentifier: GlobalConfig.StoryBordVCName.LoginVC) as! UserLogginViewController
        loginvc.navBack = true
        self.present(loginvc, animated: true, completion: nil)
    }
    
}





extension CompanyMainVC{
    
    private func setViewModel(){
        
        self.errorView.tap.asDriver().drive(onNext: { _ in
            self.reload()
        }).disposed(by: self.dispose)
        query.flatMapLatest { id  in
            self.vm.getCompanyById(id: id).asDriver(onErrorJustReturn: ResponseModel<CompanyModel>(JSON: [:])! )
            }.share().subscribe(onNext: { (res) in
                guard HttpCodeRange.filterSuccessResponse(target: res.code ?? -1), let body = res.body else {
                    self.showError()
                    return
                }
                self.mode = body
                
            }).disposed(by: self.dispose)

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
        
        
    }
    
    @objc private func share(){
        shareapps.showShare()
    }

    private func verifyLogin() -> Bool{
        if !GlobalUserInfo.shared.isLogin {
            
            self.view.presentAlert(type: UIAlertController.Style.alert, title: "请先登录", message: nil, items: [actionEntity.init(title: "确定", selector: #selector(login), args: nil)], target: self) { (ac) in
                self.present(ac, animated: true, completion: nil)
            }
            // 跳转到登录界面
            return false
        }
        return true
    }
    
  
    
    @objc private func collectedCompany(btn:UIButton){
        // 判断用户登录
        if !verifyLogin(){
            return
        }
        
        // MARK 修改公司状态 已经为收藏
        let str =  (mode?.isCollected)! ? "取消收藏" : "收藏成功"
        self.view.showToast(title: str, customImage: nil, mode: .text)
        //showOnlyTextHub(message: str, view: self.view)
        btn.isSelected = !(mode?.isCollected)!
        mode?.isCollected = !(mode?.isCollected)!
    }
}


extension CompanyMainVC: companyHeaderViewDelegate{
    
    func scrollContentAtIndex(index: Int) {
        isClick = true
        syncOffset()
        let offsetX = CGFloat(index) * self.collectionView.frame.width
        self.collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        
    }
    
    func changeTitle(_ progress:CGFloat, sourceIndex:Int, targetIndex : Int){
        self.headerView.changeTitle(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}



// shareView代理
extension CompanyMainVC: shareViewDelegate{
  
    
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

extension CompanyMainVC{
  
    //tableview 最大偏移判断
    internal func syncOffset(){
        let maxoffset = max(companyDetail.detailTable.contentOffset.y, companyJobs.joblistTable.contentOffset.y, companyCarrerTalk.table.contentOffset.y)
        if maxoffset >= headerThreld{
            if companyDetail.detailTable.contentOffset.y < headerThreld{
                companyDetail.detailTable.contentOffset = CGPoint.init(x: 0, y: headerThreld)
            }
            if companyJobs.joblistTable.contentOffset.y < headerThreld{
                companyJobs.joblistTable.contentOffset = CGPoint.init(x: 0, y: headerThreld)

            }
            if companyCarrerTalk.table.contentOffset.y < headerThreld{
                companyCarrerTalk.table.contentOffset = CGPoint.init(x: 0, y: headerThreld)
            }
        }
    }
}

// table 滑动
extension CompanyMainVC: CompanySubTableScrollDelegate{
    
    func scrollUp(view:UITableView,height:CGFloat){
        
        
        if height >= headerThreld{
            // 改变头部视图
            self.headerView.frame = CGRect.init(x: 0, y: GlobalConfig.NavH - headerThreld, width: GlobalConfig.ScreenW, height: CompanyMainVC.headerViewH)
            self.navigationItem.title = mode?.name
            return
            
        }else if height > 0 && height < headerThreld{
            self.headerView.frame = CGRect.init(x: 0, y: GlobalConfig.NavH - height, width: GlobalConfig.ScreenW, height: CompanyMainVC.headerViewH)
            
        }else{
            self.headerView.frame = CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: CompanyMainVC.headerViewH)
            self.navigationItem.title = vcTitle
            
        }
        
        //低于阈值 需要保证tablevie 偏移保持同步，headerview高度一直显示才正确
        //某个table高于阈值，在切换tableview时，syncOffset保证其它table的偏移最大为阈值，headerview 保证最高处
        
        companyDetail.detailTable.contentOffset = view.contentOffset
        companyJobs.joblistTable.contentOffset = view.contentOffset
        companyCarrerTalk.table.contentOffset = view.contentOffset
        
    }
}



// 代理
fileprivate protocol companyHeaderViewDelegate: class {
    func scrollContentAtIndex(index:Int)
    func changeTitle(_ progress:CGFloat, sourceIndex:Int, targetIndex : Int)
    
}

fileprivate class companyHeaderView:UIView{
    
    private var kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
    private var kSelectColor : (CGFloat, CGFloat, CGFloat) = (65, 105, 225)
    
    weak var delegate:companyHeaderViewDelegate?
    
    private lazy var icon:UIImageView = {
        let img = UIImageView.init()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private lazy var companyName:UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 100)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var des:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 100)
        return label
    }()
    
    private lazy var kinds:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 100)
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
            if let url = mode.iconURL{
                icon.kf.setImage(with: Source.network(url), placeholder: UIImage.init(named: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            self.companyName.text = mode.name
            self.des.text = mode.simpleDes
            let address = mode.citys?.joined(separator: " ") ?? "-"
            let industry = mode.businessField?.joined(separator: " ") ?? "-"
            let staff = "人员数: \(mode.staff)"
            self.kinds.text = address + "|" + industry + "\n" + staff
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
        
        let labelW:CGFloat = (GlobalConfig.ScreenW - 20 - 15*2) / 3
        _ = detail.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(line,5)?.widthIs(labelW)?.heightIs(20)
        _ = jobs.sd_layout().leftSpaceToView(detail, 15)?.topSpaceToView(line,5)?.widthIs(labelW)?.heightIs(20)
        _ = talk.sd_layout().leftSpaceToView(jobs, 15)?.topSpaceToView(line,5)?.widthIs(labelW)?.heightIs(20)

   
        
        companyName.setMaxNumberOfLinesToShow(2)
        des.setMaxNumberOfLinesToShow(2)
        kinds.setMaxNumberOfLinesToShow(2)

        
    }
    
    internal func getLineToBottonDistance()->CGFloat{
        return self.frame.height - self.line.frame.origin.y - self.line.frame.height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        underLine.frame = CGRect.init(x: labels[currentIndexBtn].center.x - 15, y: self.frame.height - 1 , width: 30, height: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension companyHeaderView{
    
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
        
        self.delegate?.scrollContentAtIndex(index: currentIndex)
        
    }
    
}
