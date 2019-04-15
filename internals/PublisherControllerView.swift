//
//  publisherControllerView.swift
//  internals
//
//  Created by ke.liang on 2017/12/27.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


private let tHeaderHeight:CGFloat = 200

private class navBackgroundView:UIView {
    
    
    private lazy var title:UILabel = {
        
        let title =  UILabel.init(frame: CGRect.zero)
        title.textAlignment = .center
        title.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        title.font = UIFont.boldSystemFont(ofSize: 16)
        return title
    }()
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.navigationBarColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(title)
        _ = title.sd_layout().topSpaceToView(self,25)?.bottomSpaceToView(self,10)?.centerXEqualToView(self)?.autoHeightRatio(0)
        title.setMaxNumberOfLinesToShow(1)
        
    }
    
    internal func setTitle(t:String){
        self.title.text = t
    }
    
}

class PublisherControllerView: BaseViewController {

   
    //用id 查询信息
    var userID:String = ""{
        didSet{
            query.onNext(userID)
        }
    }
    
    
    private lazy var headerView:PersonTableHeader = {
        let h = PersonTableHeader.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: tHeaderHeight - GlobalConfig.NavH))
        h.isHR = true 
        return h
    }()
    
    private lazy var table:UITableView = { [unowned self] in
        
        let tb = UITableView.init(frame: CGRect.zero)
        tb.rx.setDelegate(self).disposed(by: self.dispose)
        
        tb.backgroundColor = UIColor.viewBackColor()
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tb.tableFooterView = UIView.init()
        tb.register(CompanySimpleCell.self, forCellReuseIdentifier: CompanySimpleCell.identity())
        tb.register(CompanySimpleJobCell.self, forCellReuseIdentifier: CompanySimpleJobCell.identity())
        tb.register(singleTextCell.self, forCellReuseIdentifier: singleTextCell.identity())
        
        return tb
    }()
    
    
    private lazy var navigationBack:navBackgroundView = {
        
        let v = navBackgroundView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.NavH))
        v.alpha = 0
        return v
    }()
    
    
    
    // header 图片背景
    private lazy var bImg:UIImageView = {
       let image = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: tHeaderHeight))
       image.clipsToBounds = true
       image.contentMode = .scaleAspectFill
       image.image = UIImage.init(named: "pbackimg")
       return image
    }()
    // tableview 背景view
    private var  bview:UIView = UIView.init(frame: CGRect.zero)
    
    

    
    
    private var dataSource:RxTableViewSectionedReloadDataSource<RecruiterSectionModel>!
    
    private let dispose = DisposeBag()
    private lazy var vm:RecruitViewModel = RecruitViewModel()
    private let query:BehaviorSubject<String> = BehaviorSubject<String>.init(value: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.table.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.navigationController?.navigationBar.settranslucent(true)
        self.navigationController?.view.insertSubview(navigationBack, at: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationBack.removeFromSuperview()
    }
    
    
    
    override func setViews(){
        
    
        self.setHeader()
        self.view.addSubview(self.table)
        self.hiddenViews.append(bview)
        self.hiddenViews.append(self.table)
        //self.handleViews.append(self.tableView)
        super.setViews()
        
    }
    
    
    func didFinishloadData(mode: HRPersonModel?){
        
        super.didFinishloadData()
        guard  let mode = mode  else {
            return
        }
        let introduce = mode.company! + "@" + (mode.title ?? "")
        
        headerView.mode = (image:  mode.icon, name: mode.name!, introduce: introduce)
        navigationBack.setTitle(t: introduce)
    }
    
    
    
    
    
    override func reload(){
        
        super.reload()
        self.query.onNext(userID)
        
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = self.table.sd_layout()?.leftEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)?.rightEqualToView(self.view)
        
    }
    
    deinit {
        print("deinit recruiterVC \(String.init(describing: self))")
    }
    
    private func setHeader(){
        
        let th = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: tHeaderHeight))
        th.backgroundColor = UIColor.clear
        //  站位的view
        self.table.tableHeaderView = th
        // 用bview来管理headerview，并根据滑动拉伸headerview
        bview.frame = self.view.frame
        bview.addSubview(bImg)
        bview.addSubview(headerView)
        self.table.backgroundView = bview
        
    }
    

}





extension PublisherControllerView: UITableViewDelegate{
 
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch  self.dataSource[indexPath] {
        case .CompanyItem(_):
            return 60
        case .Label(_):
            return 30
        case .JobItem(let mode):
             return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CompanySimpleJobCell.self, contentViewWidth: GlobalConfig.ScreenW)
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 10))
        v.backgroundColor = UIColor.viewBackColor()
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 2 ? 0 : 10
    }
    
    
}





extension PublisherControllerView{
    
    // MARK:
    private func setViewModel(){
        
        
        self.errorView.tap.asDriver().drive(onNext: { [weak self]  _ in
            self?.reload()
        }).disposed(by: self.dispose)
        
        self.query.debug().subscribe(onNext: { [weak self] id in
            self?.vm.getRecruiterById(id: id)
        }).disposed(by: self.dispose)
        
        // datasource
        dataSource = RxTableViewSectionedReloadDataSource<RecruiterSectionModel>.init(configureCell:{ (dataSource, table, indexPath, _) -> UITableViewCell in
            
            switch dataSource[indexPath]{
                case .CompanyItem(let mode):
                    let cell = table.dequeueReusableCell(withIdentifier: CompanySimpleCell.identity(), for: indexPath) as! CompanySimpleCell
                    cell.mode = mode
                    
                    return cell
                case .Label(let mode):
                    let cell = table.dequeueReusableCell(withIdentifier: singleTextCell.identity(), for: indexPath) as!
                    singleTextCell
                    cell.mode = mode
                    
                    return cell
                
                case .JobItem(let mode):
                    let cell = table.dequeueReusableCell(withIdentifier: CompanySimpleJobCell.identity(), for: indexPath) as! CompanySimpleJobCell
                    cell.selectionStyle = .none
                    cell.mode =  mode
                    //cell.useCellFrameCache(with: indexPath, tableView: table)
                    return cell
            }
        })
        
        self.vm.recruiterMultiSection.asDriver(onErrorJustReturn: []).drive(self.table.rx.items(dataSource: dataSource)).disposed(by: self.dispose)
        
        
        self.vm.recruitMeetingMultiSection.asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (res) in
            if res.isEmpty{
                self?.showError()
            }
        }).disposed(by: self.dispose)
        
        self.vm.recruiterMode.subscribe(onNext: { [weak self] recruiter in
            guard let _ = recruiter.userID else {
                return
            }
            self?.didFinishloadData(mode: recruiter)
            
            
        }).disposed(by: self.dispose)
        
        self.table.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let `self` = self else{
                return
            }
            
            switch  self.dataSource[indexPath] {
            case .CompanyItem(let mode):
                let com = CompanyMainVC()
                com.companyID = mode.companyID
                self.navigationController?.pushViewController(com, animated: true)
            case .JobItem(let mode):
                
                let jd = JobDetailViewController()
                jd.job = (mode.id!, mode.kind ?? .none)
                self.navigationController?.pushViewController(jd, animated: true)
            default:
                break
            }
            
        }).disposed(by: self.dispose)
        
    }
}

// 滑动效果
extension PublisherControllerView{
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var frame = self.bImg.frame
        var hframe = self.headerView.frame
        
        // 0 到 tHeaderHeight直接距离，headerview 向上移动
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < tHeaderHeight{
            hframe.origin.y = GlobalConfig.NavH - scrollView.contentOffset.y
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
            if scrollView.contentOffset.y < 64{
                  navigationBack.alpha = scrollView.contentOffset.y / CGFloat(64)
                
            }else if scrollView.contentOffset.y >= 64{
                 navigationBack.alpha  = 1
            }
        }else if scrollView.contentOffset.y >= tHeaderHeight{
            // 取消header section 悬浮
            scrollView.contentInset = UIEdgeInsets(top: -tHeaderHeight, left: 0, bottom: 0, right: 0)
        }
            // 下拉 图片放大，固定y坐标
        else{
            frame.origin.y = 0
            frame.size.height = tHeaderHeight - scrollView.contentOffset.y
            navigationBack.alpha = 0
            // 变化速度
            hframe.origin.y = GlobalConfig.NavH - scrollView.contentOffset.y / 2
        }
        self.bImg.frame = frame
        self.headerView.frame = hframe
       
    }
}



private class singleTextCell:UITableViewCell{
    
    internal var mode:String = ""{
        didSet{
            self.content.text = mode
        }
    }
    private lazy var content:UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        return label
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(content)
        _ = content.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.autoHeightRatio(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "singleTextCell"
    }
}

