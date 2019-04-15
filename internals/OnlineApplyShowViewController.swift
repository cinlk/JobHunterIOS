//
//  OnlineApplyShowViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher



fileprivate let minTableRow:Int = 7
fileprivate let applyTitle:String = "申请"
fileprivate let collectedTitle:[String] = ["取消收藏", "收藏成功"]
fileprivate let headIconSize:CGSize = CGSize.init(width: 50, height: 50)

private class navBackView:UIView {
    
    private lazy var lb:UILabel = {
        
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(lb)
        _ = lb.sd_layout().centerXEqualToView(self)?.bottomSpaceToView(self,15)?.autoHeightRatio(0)
    }
    
    internal func setLabel(name:String){
        self.lb.text = name
    }
    
    
}

class OnlineApplyShowViewController: BaseShowJobViewController {
    
    private var richH:CGFloat = 0
    
    internal var uuid:String = ""{
        didSet{
             query.onNext(uuid)
            
        }
    }
    // 自定义头部
    private lazy var headerView: tableHeader = tableHeader()
    
    
    private lazy var  showJobsView: ShowApplyJobsView = { [unowned self] in
        let view = ShowApplyJobsView.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: 0))
        view.delegate = self
        return view
    }()
  


    private lazy var naviBackView:navBackView = {
        let view = navBackView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH))
        view.alpha = 0
        return view
    }()
    
    
    //rxSwift
    
    private let dispose = DisposeBag()
    private let vm:RecruitViewModel = RecruitViewModel()
    private let query:BehaviorSubject<String> = BehaviorSubject<String>.init(value: "")
    private let mode:BehaviorRelay<OnlineApplyModel> = BehaviorRelay<OnlineApplyModel>.init(value: OnlineApplyModel(JSON: [:])!)
    
    
    // webview 获取高度后在回调
    private var firstload:Bool = false
    private var richViewH:CGFloat = 0
    
    // 加载进度view
    internal var loadingView: RichLoadingView = {
        let loadingView = RichLoadingView()
        return loadingView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
    
       
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setViewState(show: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.setViewState(show: false)
    }
    
    override func setViews(){
        super.setViews()
        self.configTable()
        self.setToolBar()
        self.shareapps.delegate = self
        self.hidesBottomBarWhenPushed = true
        self.view.addSubview(loadingView)
        _ = loadingView.sd_layout()?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.table.tableHeaderView,0)?.bottomEqualToView(self.view)
        
 
    }
    

    
    override func showError() {
        super.showError()
        self.navigationController?.navigationBar.settranslucent(false)
    }
    
    override func reload() {
        super.reload()
        query.onNext(uuid)
    }
    
    
    @objc private func onlineApply(_ btn:UIButton){
        if !verifyLogin(){
            return
        }
        // 识别职位投递简历??
        guard  let jobs = mode.value.positions, jobs.count > 0 else {
            return
        }
        self.showJobsView.show()
    }
    
    
    
    // 收藏
    override func collected(_ btn:UIButton){
        
        if !verifyLogin(){
            return
        }
        
        // 用户收藏 数据 TODO
        let str  = collectedBtn.isSelected ? collectedTitle[0] : collectedTitle[1]
        collectedBtn.isSelected = !collectedBtn.isSelected
        self.view.showToast(title: str, customImage: nil, mode: .text)
        //showOnlyTextHub(message: str, view: self.view)
        // 发送数据到服务器 TODO
        mode.value.isCollected = collectedBtn.isSelected
        
        
    }
    
    deinit {
        print("deinit onlineApplyDetailVC \(String.init(describing: self))")
    }

    
  
}


extension OnlineApplyShowViewController: showApplyJobsDelegate{
    

    func apply(view: ShowApplyJobsView, jobIndex: Int) {
        // 发送网络请求 TODO
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
    
    // 如何填充慢toolbar TODO
    private func setToolBar(){
        
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width:  GlobalConfig.ScreenW - collectedBtn.width, height: GlobalConfig.toolBarH))
        apply.addTarget(self, action: #selector(onlineApply(_:)), for: .touchUpInside)
        apply.setTitle(applyTitle, for: .normal)
        apply.setTitleColor(UIColor.white, for: .normal)
        apply.backgroundColor = UIColor.blue
        //self.navigationController?.toolbar.contentMode = .scaleAspectFill
 
        self.toolbarItems?.append(UIBarButtonItem.init(customView: apply))
 
    }
    
    private func configTable(){
        
        table.backgroundColor = UIColor.viewBackColor()
        table.contentInsetAdjustmentBehavior = .never
        table.rx.setDelegate(self).disposed(by: self.dispose)
        table.register(ApplyJobsCell.self, forCellReuseIdentifier: ApplyJobsCell.identity())
       
        
    }
    
    
    // 控制其他view的状态
    private func setViewState(show:Bool){
        
        if show{
            self.navigationController?.setToolbarHidden(mode.value.id == nil, animated: false)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.view.insertSubview(naviBackView, at: 1)
            UIApplication.shared.keyWindow?.addSubview(showJobsView)
            (self.navigationController as? JobHomeNavigation)?.currentStyle = .lightContent
            
        }else{
            self.navigationController?.setToolbarHidden(true, animated: false)
            naviBackView.removeFromSuperview()
            self.navigationController?.navigationBar.tintColor = UIColor.black
            (self.navigationController as? JobHomeNavigation)?.currentStyle = .default
            showJobsView.removeFromSuperview()
        }
    }
    
    
    
}


// share分享代理实现  TODO
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




extension OnlineApplyShowViewController{
    
    private func setViewModel(){
        
        
        self.errorView.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.reload()
        }).disposed(by: self.dispose)
        
       _ = query.flatMapLatest { [unowned self] id in
            // TODO 处理http请求错误
        
            self.vm.getOnlineApplyBy(id: id).asDriver(onErrorJustReturn: ResponseModel<OnlineApplyModel>(JSON: [:])!)
        
            }.debug().takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (resp) in
                
                if !HttpCodeRange.filterSuccessResponse(target: resp.code ?? -1){
                        // 出错
                    self?.view.showToast(title: "error\(resp.returnMsg ?? "")", customImage: nil, mode: .text)
                    self?.showError()
                    return
                  }
                if let  data = resp.body{
                    self?.mode.accept(data)
                }
            })
        
        
        mode.subscribe(onNext: { [weak self] m in
            guard let `self` = self else{
                return
            }
            
            self.didFinishloadData()
            self.naviBackView.setLabel(name: m.name ?? "")
            self.showJobsView.jobs = m.positions ?? []
            self.headerView.mode = m
            self.headerView.layoutSubviews()
            self.table.tableHeaderView = self.headerView
            self.table.reloadData()
            self.collectedBtn.isSelected =  m.isCollected ?? false
            self.navigationController?.setToolbarHidden(false, animated: true)
            
        }).disposed(by: self.dispose)
        
        mode.map({ (m)  in
            [m]
        }).bind(to: self.table.rx.items(cellIdentifier: ApplyJobsCell.identity(), cellType: ApplyJobsCell.self)){ [weak self]  (row, mode, cell) in
            if mode.id == nil{
                return
            }
            
            cell.mode = mode
            if mode.contentType == "html"{
                cell.richView.webHeight = { [weak self] height in
                     print("--->",height)
                    //_ = cell.richView.sd_layout()?.heightIs(height)
                    self?.richViewH = height
                    if self?.firstload == false {
                        self?.table.reloadData()
                        self?.firstload = true
                        self?.loadingView.removeFromSuperview()
                    }
                }
            }else{
                self?.loadingView.removeFromSuperview()
            }

        }.disposed(by: self.dispose)

        
    }
   
}

extension OnlineApplyShowViewController: UITableViewDelegate{
    
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: ApplyJobsCell.identity()) as? ApplyJobsCell{
//            cell.mode = mode.value
//
//            cell.richView.webHeight = { [weak self] height in
//                self?.richViewH = height
//                _ = cell.richView.sd_layout()?.heightIs(height)
//                if self?.firstload == false {
//                     self?.table.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
//                    self?.firstload = true
//                }
//
//            }
//
//            return cell
//        }
//
//        return UITableViewCell()
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mode.value.id == nil{
            return 0
        }
        if mode.value.contentType == "html" && self.firstload{
            // 第二次获取值
            // 50 算上cell里其他view 的高度
            return  self.richViewH +  50
        }
        
        return tableView.cellHeight(for: indexPath, model: mode.value, keyPath: "mode", cellClass: ApplyJobsCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
        

     
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
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
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
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
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
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
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
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var mode:OnlineApplyModel?{
        didSet{
            
            guard  let mode = mode  else {
                return
            }
        
            if let url = mode.iconURL{
                self.icon.kf.indicatorType = .activity
                self.icon.kf.setImage(with: Source.network(url), placeholder: #imageLiteral(resourceName: "picture"), options: nil, progressBlock: nil, completionHandler: nil)
            }
             self.name.text = mode.name ?? ""
            
            self.address.text = mode.citys?.joined(separator: " ")
            self.time.text = "截止时间: " + mode.endTimeStr
             self.positions.text = mode.positions?.joined(separator: " ")
            self.setupAutoHeight(withBottomViewsArray: [icon,time], bottomMargin: 5)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(r: 100, g: 149, b: 237)
     
        
        let views:[UIView] = [icon, name, addressIcon, address,timeIcon, time, positions, positionIcon]
        self.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self, GlobalConfig.NavH)?.widthIs(headIconSize.width)?.heightIs(headIconSize.height)
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
