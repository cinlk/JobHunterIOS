//
//  CompanyCollectedVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let notifiyName:String = "CompanyCollectedVC"

class CompanyCollectedVC: BaseViewController {

    
    // 收藏的公司数据
    private var datas:[CompanyModel] = []
    
    
    internal lazy var table:UITableView = { [unowned self] in
        let tb = UITableView.init(frame: self.view.frame)
        tb.dataSource = self
        tb.delegate = self
        tb.allowsMultipleSelectionDuringEditing = true
        tb.tableFooterView = UIView()
        tb.register(companyCollectedCell.self, forCellReuseIdentifier: companyCollectedCell.identity())
        tb.backgroundColor = UIColor.viewBackColor()
        tb.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)

        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(operation), name: NSNotification.Name.init(notifiyName), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source

    override func setViews() {
        
        
        self.view.addSubview(table)
           _ = table.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
        
        self.handleViews.append(table)
        super.setViews()
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
}






extension CompanyCollectedVC: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: companyCollectedCell.identity(), for: indexPath) as! companyCollectedCell
        let item = datas[indexPath.row]
        cell.mode = item
        return cell
        
    }
    
    // 设置cell样式
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = datas[indexPath.row]
        
        return tableView.cellHeight(for: indexPath, model: item, keyPath: "mode", cellClass: companyCollectedCell.self, contentViewWidth: ScreenW)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing{
            return
        }
        let item = datas[indexPath.row]
        // MARK TODO company数据给界面展示
        let vc = CompanyMainVC()
        vc.companyID =  item.id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension CompanyCollectedVC{
    @objc private func operation(_ sender: Notification){
        
        let info = sender.userInfo as? [String:String]
        if let action = info?["action"]{
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
                    selected.forEach { indexPath in
                        deletedRows.append(indexPath.row)
                    }
                    // 扩展 批量删除元素
                    self.datas.remove(indexes: deletedRows)
                    // 服务器删除
                    self.table.reloadData()
                    
                }
            }
        }
        
        
        
    }
}

extension CompanyCollectedVC{
    
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            for _ in 0..<20{
                self?.datas.append(CompanyModel(JSON: ["id":"dqw-dqwd","name":"公司名",
                                                       "describe":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n","address":["地址1","地址2"],"icon":"sina","simpleDes":"当前为多群无多群当前为多群无多群当前为多群无多群无当前为多群无","industry":["教育","医疗","化工"],"webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的当前","当前为多","迭代器","群无多当前为多群当前","达瓦大群无多", "当前为多当前的群","当前为多无", "当前为多群无多","杜德伟七多"],"isValidate":true,"isCollected":false,"follows": arc4random()%10000])!)
                
                
                
            }
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
        
    }
    
}




@objcMembers fileprivate class companyCollectedCell: UITableViewCell {
    
    
    private lazy var icon:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    
    
    private lazy var companyName:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textAlignment = .left
        return name
    }()
    
    

    
    private lazy var describe:UILabel = {
        let name = UILabel()
        name.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        name.font = UIFont.systemFont(ofSize: 12)
        name.textAlignment = .left
        name.textColor = UIColor.lightGray
        return name
    }()
    
    
    dynamic var mode:CompanyModel?{
        didSet{
            
            guard  let mode = mode  else {
                return
            }
            self.icon.image = UIImage.init(named: mode.icon)
            self.companyName.text = mode.name
            // 必须的 参数
            self.describe.text = mode.simpleDes
            
            self.setupAutoHeight(withBottomViewsArray: [describe,icon], bottomMargin: 5)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [icon, companyName, describe]
        self.contentView.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.widthIs(45)?.heightIs(45)
        _ = companyName.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = describe.sd_layout().topSpaceToView(companyName,5)?.leftEqualToView(companyName)?.autoHeightRatio(0)
        
        companyName.setMaxNumberOfLinesToShow(1)
        describe.setMaxNumberOfLinesToShow(2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func identity()->String{
        return "jobCollectedCell"
    }
    
    // MARK 区分cell 投递 和非
    
    
}


