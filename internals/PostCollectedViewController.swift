//
//  PostCollectedViewController.swift
//  internals
//
//  Created by ke.liang on 2018/7/1.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
fileprivate let all = "全部"

//fileprivate let notifiyName:String = "PostCollectedViewController"


class PostCollectedViewController: BaseViewController {

 
    
    private var groupTitles:[String] = [all]
    
    private lazy var datas:[CollectedPostModel] = []
    private lazy var filterData: [CollectedPostModel] = []
    
    
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    
    private lazy var headerRefrsh:UIRefreshControl = { [unowned self] in
        let refresh = UIRefreshControl.init()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }()
    
    private lazy var topGroup:groupView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        
        let t = groupView.init(frame: CGRect.zero, collectionViewLayout: layout)
        t.contentInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        
        t.chooseTag = { [weak self]  tag in
            // 选择某个tag
            // 显示过滤的数据
            
            self?.filterData.removeAll()
            
            if tag == all{
                self?.filterData = self?.datas ?? []
            }else{
                self?.datas.forEach({
                    if $0.group.contains(tag){
                        self?.filterData.append($0)
                    }
                })
            }
            
           
            self?.table.reloadData()
        }
        
       
        
        
        return t
        
    }()
    
    internal lazy var table:UITableView = { [unowned self] in
        let tb = UITableView.init(frame: self.view.frame)
        tb.dataSource = self
        tb.delegate = self
        tb.allowsMultipleSelectionDuringEditing = true
        tb.tableFooterView = UIView()
        tb.register(postCollectedCell.self, forCellReuseIdentifier: postCollectedCell.identity())
        tb.backgroundColor = UIColor.viewBackColor()
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        tb.refreshControl = self.headerRefrsh
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        loadData()
        
        //self.loadData()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(operation), name: NSNotification.Name.init(notifiyName), object: nil)
        
    }
    
    
    override func setViews() {
        
        
        self.view.addSubview(topGroup)
        self.view.addSubview(table)
        _ = topGroup.sd_layout()?.topEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.heightIs(45)
        _ = table.sd_layout()?.topSpaceToView(self.topGroup,0)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        self.hiddenViews.append(topGroup)
        self.hiddenViews.append(table)
        super.setViews()
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.topGroup.mode = groupTitles
        self.headerRefrsh.endRefreshing()
        self.table.reloadData()
    }
    
    override func reload() {
        super.reload()
        //self.loadData()
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
        print("deinit postCollectedViewController \(self)")
    }
    
    
}



extension PostCollectedViewController{
    
    
    private func  loadData(){
        
        
        
        self.vm.collectedPost().asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            guard let `self` = self else {
                return
            }
            
            self.datas = modes
            self.filterData = modes
            
            self.getAllTags(completed: { flag in
                if flag{
                     self.didFinishloadData()
                }
            })
            
           
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        
    }
    
    @objc private func  refreshData(){
    
        self.loadData()
        
    }
}

extension PostCollectedViewController {
    
    private func getAllTags(completed:@escaping (Bool)->Void){
        
        // 获取 所有分组
        NetworkTool.request(.userPostGroups, successCallback: {  data in
            
            guard  let d = data as? [String:Any],let target =  d["body"] as? [[String:Any]] else {
                return
            }
            
            self.groupTitles.removeAll()
            self.groupTitles.append(all)
            
            
            let res = Mapper<UserRelateGroup>().mapArray(JSONArray: target)
            var tags:[String] = []
            res.forEach({
                if let n = $0.name{
                   tags.append(n)
                }
                
            })
            SingletoneClass.shared.postGroups = tags
            SingletoneClass.shared.postGroups.forEach({
                if !self.groupTitles.contains($0){
                    self.groupTitles.append($0)
                }
            })
            completed(true)
            
        }) { (err) in
            completed(false)
        }
        
    }
}


extension PostCollectedViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: postCollectedCell.identity(), for: indexPath) as? postCollectedCell{
            cell.mode = filterData[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = filterData[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: postCollectedCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        let post = PostContentViewController()
        let mode = filterData[indexPath.row]
        //post.mode = (data:mode, row: indexPath.row)
        //post.postID
        post.postID = mode.postId
        
        post.deleteSelf = { [weak self] row in
            self?.datas.remove(at: row)
            self?.table.reloadData()
        }
        
        post.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(post, animated: true)
        
    }
    
    
}



fileprivate class groupView: UICollectionView {
    
    
    private var itemWidth:[CGFloat] = []
    
    internal var chooseTag: ((_:String) -> Void)?
    
    
    var mode:[String]?{
        didSet{
            if let m = mode {
                m.forEach { [weak self] in
                    guard let `self` = self else {
                        return
                    }
                   let size =  $0.rect(withFont: UIFont.systemFont(ofSize: 14), size: CGSize.init(width: GlobalConfig.ScreenW, height: self.frame.height - 10))
                    self.itemWidth.append(size.width)
                    
                }
                // btn 状态更新
                
                
                
                //let width = self.collectionViewLayout.collectionView?.width
                
                //let width = self.collectionViewLayout.collectionViewContentSize.width + 5
                
                //_ = self.sd_layout()?.widthIs(width)
                
            }
            self.reloadData()
        }
    }
    
    
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(labelCollectionCell.self, forCellWithReuseIdentifier: "cell")
        self.backgroundColor = UIColor.lightGray
        self.bounces = false
        self.isPagingEnabled = false
        self.delegate = self
        self.dataSource = self
       // self.allowsMultipleSelection = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

extension groupView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mode?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! labelCollectionCell
        if let mode = mode{
            
            cell.btn.setTitle(mode[indexPath.row], for: .normal)
            //cell.btn.sizeToFit()
        }
        if indexPath.row == 0 {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
       //collectionView.sele
        cell.isSelected = indexPath.row == 0 ? true : false
        return cell
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? labelCollectionCell, let text =  cell.btn.titleLabel?.text{
            self.chooseTag?(text)
            cell.isSelected = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? labelCollectionCell{
            cell.isSelected = false
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: itemWidth[indexPath.row] + 20 , height: collectionView.frame.height - 10)
    }
    
    
    
    
}




@objcMembers fileprivate class postCollectedCell: UITableViewCell {
    
    
    private lazy var postName:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 20)
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textAlignment = .left
        return name
    }()
    
    

//    private lazy var times:UILabel = {
//        let name = UILabel()
//        name.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 20)
//        name.font = UIFont.systemFont(ofSize: 12)
//        name.textAlignment = .left
//        name.textColor = UIColor.lightGray
//        return name
//    }()
//
    
    
    dynamic var mode:CollectedPostModel?{
        didSet{
            
            guard  let mode = mode  else {
                return
            }
            self.postName.text = mode.name
            //self.times.text = mode.createTimeStr
            
            self.setupAutoHeight(withBottomView: postName, bottomMargin: 10)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [postName]
        self.accessoryType = .disclosureIndicator
        self.contentView.sd_addSubviews(views)
        _ = postName.sd_layout().topSpaceToView(self.contentView,10)?.leftSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        //_ = times.sd_layout().topSpaceToView(postName,10)?.leftEqualToView(postName)?.autoHeightRatio(0)
        
        postName.setMaxNumberOfLinesToShow(2)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func identity()->String{
        return "postCollectedCell"
    }
    
    // MARK 区分cell 投递 和非
    
    
}



private class labelCollectionCell:UICollectionViewCell{
    
    
    override var isSelected: Bool{
        didSet{
            
            let titleColor = isSelected ? UIColor.white : UIColor.black
            self.btn.setTitleColor(titleColor, for: .normal)
            self.btn.backgroundColor = isSelected ? UIColor.green : UIColor.white
        }
    }
    
    fileprivate lazy var btn:UIButton = {
        let b = UIButton.init(frame: CGRect.zero)
        b.setTitleColor(UIColor.black, for: .normal)
        //b.setTitleColor(UIColor.white, for: .selected)
        b.titleLabel?.textAlignment = .center
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.clipsToBounds = true
        b.backgroundColor = UIColor.white
        b.isUserInteractionEnabled = false
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.contentView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(btn)
        _ = btn.sd_layout()?.leftSpaceToView(self.contentView,5)?.rightSpaceToView(self.contentView,5)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
        
        btn.layer.cornerRadius = self.contentView.frame.height/2
        //btn.sd_cornerRadiusFromHeightRatio = 0.5
    }
    
}

