//
//  companyDetailVC.swift
//  internals
//
//  Created by ke.liang on 2018/4/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


// 与companyMainVC 一致
fileprivate var sectionHeight:CGFloat = 10
fileprivate let companyAddress = "公司网址"


class CompanyDetailVC: UIViewController {
    
    lazy var detailTable:UITableView = { [unowned self] in
        
        let tb = UITableView.init(frame: CGRect.zero)
        tb.tableFooterView = UIView.init()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.rx.setDelegate(self).disposed(by: self.dispose)
        tb.contentInsetAdjustmentBehavior = .never
        tb.separatorStyle = .none
        //tb.bounces = false
        // 底部内容距离底部高60，防止回弹底部内容被影藏
        let head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: CompanyMainVC.headerViewH))
        head.backgroundColor = UIColor.viewBackColor()
        tb.tableHeaderView = head
        // 添加手势, 覆盖cell 的点击
        tb.addGestureRecognizer(self.tap)
        tb.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        // cell
        tb.register(FeedBackTypeCell.self, forCellReuseIdentifier: FeedBackTypeCell.identity())
        tb.register(CompanyDetailCell.self, forCellReuseIdentifier: CompanyDetailCell.identity())
        tb.register(WorklocateCell.self, forCellReuseIdentifier: WorklocateCell.identity())
        tb.register(SubIconAndTitleCell.self, forCellReuseIdentifier: SubIconAndTitleCell.identity())
        return tb
        
    }()
    
    // deleagte
    weak var delegate:CompanySubTableScrollDelegate?
    
    private lazy var tap :UIGestureRecognizer  = { [unowned self] in
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(open))
        //tap.delegate = self
        
        return tap
    }()
    
    private let sections: BehaviorRelay<[CompanyDetailMultiSection]> = BehaviorRelay<[CompanyDetailMultiSection]>.init(value: [])
    
    private var dataSource:RxTableViewSectionedReloadDataSource<CompanyDetailMultiSection>!
    private lazy var  dispose:DisposeBag = DisposeBag()
    
    var detailModel:CompanyModel?{
        didSet{
            guard  let mode = detailModel, mode.id != nil else {
                return
            }
            var sections:[CompanyDetailMultiSection] = []
            if let tags = mode.tags{
                sections.append(CompanyDetailMultiSection.companyTagSection(title: "", items: [CompanyDetailItem.tags(mode: tags)]))
            }
            if let detail = mode.describe{
                sections.append(CompanyDetailMultiSection.companyDetailSection(title: "", items: [CompanyDetailItem.detail(mode: detail)]))
            }
            if let locations = mode.citys{
                sections.append(CompanyDetailMultiSection.companyLocation(title: "", items: [CompanyDetailItem.location(mode: locations)]))
            }
            if let link = mode.link{
                sections.append(CompanyDetailMultiSection.companyLink(title: "", items: [CompanyDetailItem.link(mode: link.absoluteString)]))
            }
            self.sections.accept(sections)
            //self.detailTable.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        
        
    }

    deinit {
        print("deinit companyDetialVC \(String.init(describing: self))")
    }
    
    private func setViews() {
        
        self.view.addSubview(detailTable)
        _ = detailTable.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }
    
    
    
    private func setViewModel(){
        
        self.dataSource = RxTableViewSectionedReloadDataSource<CompanyDetailMultiSection>.init(configureCell: { (dataSource, table, indexPath, _) -> UITableViewCell in
            switch dataSource[indexPath]{
            case .tags(let mode):
                let cell  = table.dequeueReusableCell(withIdentifier: FeedBackTypeCell.identity(), for: indexPath) as! FeedBackTypeCell
                cell.collectionView.isUserInteractionEnabled = false
                cell.mode = mode
                return cell
                
            case .detail(let mode):
                let cell  = table.dequeueReusableCell(withIdentifier: CompanyDetailCell.identity(), for: indexPath) as! CompanyDetailCell
                cell.mode = mode
                return cell
                
            case .location(let mode):
                let cell  = table.dequeueReusableCell(withIdentifier: WorklocateCell.identity(), for: indexPath) as! WorklocateCell
                cell.mode = mode
                
                return cell
            case .link(let mode):
                
                let cell = table.dequeueReusableCell(withIdentifier: SubIconAndTitleCell.identity(), for: indexPath) as! SubIconAndTitleCell
                
                cell.content.isUserInteractionEnabled = true
                cell.content.attributedText = NSAttributedString.init(string: mode, attributes: [NSAttributedString.Key.foregroundColor:UIColor.blue, NSAttributedString.Key.link: link])
                // 添加没反应!
                //cell.content.removeGestureRecognizer(self.tap)
                //cell.content.addGestureRecognizer(self.tap)
                cell.mode = mode
                cell.icon.image  = #imageLiteral(resourceName: "link")
                cell.iconName.text = companyAddress
                return cell
                
            }
        })
        
        self.sections.asDriver(onErrorJustReturn: []).drive(self.detailTable.rx.items(dataSource: self.dataSource)).disposed(by: self.dispose)
        
        self.detailTable.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            self?.detailTable.deselectRow(at: indexPath, animated: false)
        }).disposed(by: self.dispose)
        

        
    }
    
    
    

}



extension CompanyDetailVC: UITableViewDelegate{

    
    // section 高度
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.dataSource[indexPath] {
        case .tags(let mode):
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: FeedBackTypeCell.self, contentViewWidth: GlobalConfig.ScreenW)
        case .detail(let mode):
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CompanyDetailCell.self, contentViewWidth: GlobalConfig.ScreenW)
        case .location(let mode):
             return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: WorklocateCell.self, contentViewWidth: GlobalConfig.ScreenW)
        case .link(let mode):
             return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: SubIconAndTitleCell.self, contentViewWidth: GlobalConfig.ScreenW) + 20
        }
        
    }
    
    
}


extension CompanyDetailVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 向上滑动
        let offsetY = scrollView.contentOffset.y
        offsetY > 0 ? delegate?.scrollUp(view: self.detailTable, height: offsetY) :  delegate?.scrollUp(view: self.detailTable, height: 0)
    }
}

//extension CompanyDetailVC:UIGestureRecognizerDelegate{
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        return false
//    }
//}

extension CompanyDetailVC{
    
    @objc private func open(tap: UITapGestureRecognizer){
        // 判断点击的位置
        let location = tap.location(in: self.detailTable)
        guard let indexPath = self.detailTable.indexPathForRow(at: location) else{
            return
        }
        // 判断link 的cell
        guard  let cell = self.detailTable.cellForRow(at: indexPath) as? SubIconAndTitleCell, let link = cell.mode else {
            return
        }
        
        // url
        openApp(appURL: link, completion:{ [weak self]
            bool in
            if bool == false{
                self?.view.showToast(title: "网页打开失败", customImage: nil, mode: .text)
            }
        })
    }
}
