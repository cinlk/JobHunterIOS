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
import Kingfisher


fileprivate let minTableRow:Int = 7

class OnlineApplyShowViewController: BaseShowJobViewController {
    
    
    internal var uuid:String = ""{
        didSet{
             query.onNext(uuid)
        }
    }
    private var mode:OnlineApplyModel?{
        
        didSet{
            didFinishloadData()
        }
    }
    
    // 自定义头部
    private lazy var headerView: tableHeader = tableHeader()
    
    private lazy var apply:UIButton = { [unowned self] in
        
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width:  ScreenW - collectedBtn.width + 20, height: TOOLBARH))
        apply.addTarget(self, action: #selector(onlineApply(_:)), for: .touchUpInside)
        apply.setTitle("申请", for: .normal)
        apply.setTitleColor(UIColor.white, for: .normal)
        apply.backgroundColor = UIColor.blue
        return apply
        
    }()
    
    
    private lazy var  showJobsView: ShowApplyJobsView = {
        let view = ShowApplyJobsView.init(frame: CGRect.init(x: 0, y: ScreenH, width: ScreenW, height: 0))
        view.delegate = self
        return view
    }()
  


    private lazy var naviBackView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: NavH))
        view.backgroundColor = UIColor.green
        view.alpha = 0
        
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.tag = 10
        view.addSubview(label)
        _ = label.sd_layout().centerXEqualToView(view)?.bottomSpaceToView(view,15)?.autoHeightRatio(0)
        
        return view
    }()
    
    
    //rxSwift
    
    private let dispose = DisposeBag()
    private let vm:RecruitViewModel = RecruitViewModel()
    private let query:BehaviorSubject<String> = BehaviorSubject<String>.init(value: "")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
       
        // Do any additional setup after loading the view.
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
        
        self.errorView.reload = reload
        
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
        self.finishLoadData()
        
    }
    
    override func reload() {
        super.reload()
        // 重新建立观察序列
        setViewModel()
        query.onNext(uuid)
    }
    
    
    
    // 收藏
    override func collected(_ btn:UIButton){
        
        if anonymous {
            showAlert(error: "请登录", vc: self)
            return
        }
        // 用户收藏 数据
        let str  = collectedBtn.isSelected ? "取消收藏" : "收藏成功"
        collectedBtn.isSelected = !collectedBtn.isSelected
        
        showOnlyTextHub(message: str, view: self.view)
        mode?.isCollected = collectedBtn.isSelected
        
        
    }

}


extension OnlineApplyShowViewController: showApplyJobsDelegate{
    

    func apply(view: ShowApplyJobsView, jobIndex: Int) {
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
    
    
    private func finishLoadData(){
        
        (naviBackView.viewWithTag(10) as! UILabel).text = mode?.name
        showJobsView.jobs = mode?.positions ?? []
        
        headerView.mode = mode
        headerView.layoutSubviews()
        table.tableHeaderView = headerView
        table.reloadData()
        
        collectedBtn.isSelected =  mode!.isCollected!
        
        self.navigationController?.setToolbarHidden(false, animated: true)
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
        if anonymous{
            showAlert(error: "请登录", vc: self)
            return
        }
        // 识别职位投递简历??
        guard  let jobs = mode?.positions, jobs.count > 0 else {
            return
        }
        self.showJobsView.show()
    }
    
}

extension OnlineApplyShowViewController{
    
    private func setViewModel(){
        
        
        query.subscribeOn(MainScheduler.instance).share().flatMapLatest { (id) -> Observable<OnlineApplyModel> in
            
            self.vm.getOnlineApplyBy(id: id)
            }.subscribe(onNext: { (mode) in
                self.mode = mode
            }, onError: { (err) in
                print("get error \(err)")
                self.showError()
                
            }, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
        
        
    }
   
}

extension OnlineApplyShowViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: applyJobsCell.identity(), for: indexPath) as! applyJobsCell
        guard let mode = mode  else {
            return UITableViewCell()
        }
        cell.mode = mode
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: applyJobsCell.self, contentViewWidth: ScreenW)
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
            
            let url = URL.init(string: mode.companyIcon)
            self.icon.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            self.address.text = mode.address?.joined(separator: " ")
            self.time.text = "截止时间: " + mode.endTimeStr
            self.name.text = mode.companyName
            self.positions.text = mode.positions?.joined(separator: " ")
            self.setupAutoHeight(withBottomViewsArray: [icon,time], bottomMargin: 5)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(r: 100, g: 149, b: 237)
     
        
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
