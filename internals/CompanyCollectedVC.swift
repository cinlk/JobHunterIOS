//
//  CompanyCollectedVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh
import Kingfisher

//fileprivate let notifiyName:String = "CompanyCollectedVC"

class CompanyCollectedVC: BaseViewController {

    
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    private var offset = 0
    private let limit = 10
    // 收藏的公司数据
    private var datas:[CollectedCompanyModel] = []
    
    
    internal lazy var table:UITableView = { [unowned self] in
        let tb = UITableView.init(frame: self.view.frame)
        tb.rx.setDelegate(self).disposed(by: self.dispose)
        //tb.dataSource = self
        //tb.delegate = self
        tb.allowsMultipleSelectionDuringEditing = true
        tb.tableFooterView = UIView()
        tb.register(companyCollectedCell.self, forCellReuseIdentifier: companyCollectedCell.identity())
        tb.backgroundColor = UIColor.viewBackColor()
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)

        return tb
    }()
    
    
    private lazy var refreshHeader:MJRefreshNormalHeader = {
        let h = MJRefreshNormalHeader.init { [weak self] in
            guard let s = self else {
                return
            }
            s.offset = 0
            s.vm.collectedCompanyReq.onNext((s.offset, s.limit))
            
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
        
    }()
    
    private lazy var refreshFooter:MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let s = self else {
                return
            }
            s.offset += s.limit
            s.vm.collectedCompanyReq.onNext((s.offset, s.limit))
            
        })
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        
        return f!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        //self.loadData()
        setViewModel()
        
       // NotificationCenter.default.addObserver(self, selector: #selector(operation), name: NotificationName.collecteItem[2], object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
  
    // MARK: - Table view data source

    override func setViews() {
        
        
        self.view.addSubview(table)
           _ = table.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        
        self.hiddenViews.append(table)
        super.setViews()
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        //self.table.reloadData()
    }
    
    override func reload() {
        super.reload()
        //self.loadData()
        self.offset = 0
        self.vm.collectedCompanyReq.onNext((self.offset, self.limit))
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
        print("deinit companyCollectedVC \(self)")
    }
   
}




extension CompanyCollectedVC{
    private func setViewModel(){
        
        self.errorView.tap.asDriver().drive(onNext: { [weak self] in
            self?.reload()
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        NotificationCenter.default.rx.notification(NotificationName.collecteItem[2], object: nil).subscribe(onNext: { [weak self] (notify) in
            self?.operation(notify)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.vm.collectedCompany.share().subscribe(onNext: { [weak self] (modes) in
            self?.datas = modes
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.vm.collectedCompany.share().bind(to: self.table.rx.items(cellIdentifier: companyCollectedCell.identity(), cellType: companyCollectedCell.self)){
            (row, mode, cell) in
            cell.mode = mode
        }.disposed(by: self.dispose)
        
        
        self.vm.companyRefreshStatus.asDriver(onErrorJustReturn: .none).drive(onNext:  { [weak self] (status) in
            guard let `self` = self else {
                return
            }
            switch status{
            case .endHeaderRefresh:
                self.table.mj_footer.resetNoMoreData()
                self.table.mj_header.endRefreshing()
                self.didFinishloadData()
            case .endFooterRefresh:
                self.table.mj_footer.endRefreshing()
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
            case .error(let err):
                self.table.mj_footer.endRefreshing()
                self.table.mj_header.endRefreshing()
                self.view.showToast(title: "err \(err)", customImage: nil, mode: .text)
            //showOnlyTextHub(message: "err \(err)", view: self.view)
            default:
                break
            }
            
        }).disposed(by: dispose)
        
        
        
        self.table.rx.itemSelected.subscribe(onNext: {  [weak self] (indexPath) in
            guard let `self` = self else {
                return
            }
            
            if self.table.isEditing{
                return
            }
            self.table.deselectRow(at: indexPath, animated: true)
            let item = self.datas[indexPath.row]
            // MARK TODO company数据给界面展示
            let vc = CompanyMainVC()
            vc.companyID =  item.companyId!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.refreshHeader.beginRefreshing()
        
    
    }
}


extension CompanyCollectedVC:  UITableViewDelegate{
    
    
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return datas.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: companyCollectedCell.identity(), for: indexPath) as! companyCollectedCell
//        let item = datas[indexPath.row]
//        cell.mode = item
//        return cell
//
//    }
    
    // 设置cell样式
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = datas[indexPath.row]
        
        return tableView.cellHeight(for: indexPath, model: item, keyPath: "mode", cellClass: companyCollectedCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.isEditing{
//            return
//        }
//        let item = datas[indexPath.row]
//        // MARK TODO company数据给界面展示
//        let vc = CompanyMainVC()
//        vc.companyID =  item.id
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }
}


extension CompanyCollectedVC{
     private func operation(_ sender: Notification){
        
        let info = sender.userInfo as? [String: Any]
        
        
        if let mode = info?["mode"] as? CollectedCompanyModel{
            self.datas.insert(mode, at: 0)
            self.vm.collectedCompany.accept(self.datas)
            return
        }
        
        // 删除数据
        if let mode = info?["remove"] as? CollectedCompanyModel{
            var targetIndex = -1
            for (index, item) in self.datas.enumerated(){
                if item.companyId! == mode.companyId!{
                    targetIndex = index
                    break
                }
            }
            if targetIndex >= 0 {
                self.datas.remove(at: targetIndex)
                self.vm.collectedCompany.accept(self.datas)
            }
            
            return
        }
        
        
        if let action = info?["action"] as? String{
            if action == "edit"{
                self.table.setEditing(true, animated: false)
            }else if action == "cancel"{
                self.table.setEditing(false, animated: false)
            }else if action == "selectAll"{
                for index in 0..<datas.count{
                    self.table.selectRow(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .bottom)
                }
                
            }else if action == "unselect"{
                self.table.selectRow(at: nil, animated: false, scrollPosition: .top)
            }else if action == "delete"{
                if let selected = self.table.indexPathsForSelectedRows{
                    var deletedRows:[Int] = []
                    var cids:[String] = []
                    selected.forEach { [weak self] indexPath in
                        deletedRows.append(indexPath.row)
                        if let id = self?.datas[indexPath.row].companyId{
                            cids.append(id)
                        }
                    }
                    self.vm.unCollectedCompany(ids: cids).subscribe(onNext: { [weak self] (res) in
                        guard let `self` = self else {
                            return
                        }
                        guard let code = res.code, HttpCodeRange.filterSuccessResponse(target: code) else{
                            self.table.showToast(title: "删除失败", customImage: nil, mode: .text)
                            return
                        }
                        self.datas.remove(indexes: deletedRows)
                        self.vm.collectedCompany.accept(self.datas)
                        
                    }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                    // 扩展 批量删除元素
                    // self.datas.remove(indexes: deletedRows)
                    // 服务器删除
                    // self.table.reloadData()
                    
                }
            }
        }
        
        
        
    }
}

//extension CompanyCollectedVC{
//
//    private func loadData(){
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            Thread.sleep(forTimeInterval: 3)
//            for _ in 0..<20{
//                self?.datas.append(CompanyModel(JSON: ["id":"dqw-dqwd","name":"公司名",
//                                                       "describe":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n","address":["地址1","地址2"],"icon":"sina","simpleDes":"当前为多群无多群当前为多群无多群当前为多群无多群无当前为多群无","industry":["教育","医疗","化工"],"webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的当前","当前为多","迭代器","群无多当前为多群当前","达瓦大群无多", "当前为多当前的群","当前为多无", "当前为多群无多","杜德伟七多"],"isValidate":true,"isCollected":false,"follows": arc4random()%10000])!)
//
//
//
//            }
//            DispatchQueue.main.async(execute: {
//                self?.didFinishloadData()
//            })
//        }
//
//    }
//
//}




@objcMembers fileprivate class companyCollectedCell: UITableViewCell {
    
    
    private lazy var icon:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    
    
    private lazy var companyName:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 80)
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textAlignment = .left
        return name
    }()
    
    

    
    private lazy var type:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 80)
        name.font = UIFont.systemFont(ofSize: 12)
        name.textAlignment = .left
        name.textColor = UIColor.lightGray
        return name
    }()
    
    private lazy var city:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 80)
        name.font = UIFont.systemFont(ofSize: 12)
        name.textAlignment = .left
        name.textColor = UIColor.lightGray
        return name
    }()
    
    
    dynamic var mode:CollectedCompanyModel?{
        didSet{
            
            guard  let mode = mode  else {
                return
            }
            if let url = mode.iconURL{
                self.icon.kf.setImage(with: Source.network(url), placeholder: UIImage.init(named: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                self.icon.image = #imageLiteral(resourceName: "sina")
            }
            
            self.companyName.text = mode.name
            // 必须的 参数
            self.type.text = mode.type
            self.city.text = mode.citys?.joined(separator: " ")
            self.setupAutoHeight(withBottomViewsArray: [city,icon], bottomMargin: 10)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, companyName, type, city]
        self.contentView.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.widthIs(45)?.heightIs(45)
        _ = companyName.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = type.sd_layout().topSpaceToView(companyName,5)?.leftEqualToView(companyName)?.autoHeightRatio(0)
        _ = city.sd_layout()?.topSpaceToView(type,5)?.leftEqualToView(type)?.autoHeightRatio(0)
        
        
        companyName.setMaxNumberOfLinesToShow(1)
        type.setMaxNumberOfLinesToShow(1)
        city.setMaxNumberOfLinesToShow(2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func identity()->String{
        return "jobCollectedCell"
    }
    
    // MARK 区分cell 投递 和非
    
    
}


