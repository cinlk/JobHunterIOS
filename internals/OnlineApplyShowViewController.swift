//
//  OnlineApplyShowViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let section:Int = 2

class OnlineApplyShowViewController: BaseShowJobViewController {
    
    // 自定义头部
    private lazy var headerView: tableHeader = tableHeader()
    
    // 查询数据
    var onlineApplyID:String?{
        didSet{
            self.loadData()
        }
    }
    // 消息体
    private var mode:OnlineApplyModel?
    
    
    private lazy var apply:UIButton = { [unowned self] in
        let apply = UIButton.init(frame: CGRect.init(x: 0, y: 0, width:  ScreenW - collectedBtn.width + 20, height: (self.navigationController?.toolbar.height)!))
        
        apply.addTarget(self, action: #selector(onlineApply(_:)), for: .touchUpInside)
        apply.setTitle("申请", for: .normal)
        apply.setTitleColor(UIColor.white, for: .normal)
        apply.backgroundColor = UIColor.blue
        return apply
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView()
        self.navigationController?.setToolbarHidden(mode == nil, animated: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        self.navigationController?.setToolbarHidden(true, animated: false)

        
    }
    
    override func setViews(){
        super.setViews()
        
        table.dataSource = self
        table.delegate = self
        table.register(TableContentCell.self, forCellReuseIdentifier: TableContentCell.identity())
        
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
        
        headerView.mode = mode
        self.navigationItem.title = mode?.companyModel?.name
        headerView.layoutSubviews()
        table.tableHeaderView = headerView
        table.reloadData()
        if mode!.isCollected == true {
            collectedBtn.isSelected = true
            
        }
        self.navigationController?.setToolbarHidden(false, animated: true)

    }
    
    override func reload() {
        super.reload()
        
    }
    
    // 收藏
    override func collected(_ btn:UIButton){
        if mode?.isCollected == true{
            // 更新服务器数据
            collectedBtn.isSelected = false
            
            showOnlyTextHub(message: "取消收藏", view: self.view)
        }else{
            // 更新服务器数据
            collectedBtn.isSelected = true
            
            showOnlyTextHub(message: "收藏成功", view: self.view)
        }
        mode?.isCollected = !(mode?.isCollected)!
        
        
        // 取消收藏
        
    }

}


//


// share分享代理实现
extension OnlineApplyShowViewController:shareViewDelegate{
    
    func hiddenShareView(view:UIView){
        self.handleSingleTapGesture()
    }
    func handleShareType(type: UMSocialPlatformType) {
    }
}


// 公司主页网申
extension OnlineApplyShowViewController{
    @objc private func onlineApply(_ btn:UIButton){
        // 跳转到网申界面？？ (url)
        let web = baseWebViewController()
        web.mode = "http://www.baidu.com"
        self.navigationController?.pushViewController(web, animated: true)
        
    }
}

extension OnlineApplyShowViewController{
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            // 1 获取网申信息
            self?.mode = OnlineApplyModel(JSON: ["id":"fq-4320-dqwd","companyModel":["id":"dqw-dqwd","name":"公司名",
                "college":"北京大学","describe":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n","address":["地址1","地址2"],"icon":"sina","type":["教育","医疗","化工"],"webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的当前","当前为多","迭代器","群无多当前为多群当前","达瓦大群无多", "当前为多当前的群","当前为多无", "当前为多群无多","杜德伟七多"],"isValidate":true,"isCollected":true,],"end_time":"2017","start_time":"2018","positionAddress":["成都","重庆"],"content":"dqwdqwdqwddqwdqwdqwddqwdqwdqwddqwdqwdqwdqwdqwdwqdqwdqwdqw","outer":true,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 "majors":["土木工程","软件工程","其他"],"positions":["设计","测试","销售"],"link":"http://campus.51job.com/padx2018/index.html","isApply":false,"isValidate":true,"isCollected":true,"name":"网申测试"])!
            
            //print(self?.mode)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self?.didFinishloadData()
            })
        }
       
        
    }
}

extension OnlineApplyShowViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.viewBackColor()
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableContentCell.identity(), for: indexPath) as! TableContentCell
        cell.name.text = "招聘内容"
        cell.mode = mode?.content
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.cellHeight(for: indexPath, model: mode?.content, keyPath: "mode", cellClass: TableContentCell.self, contentViewWidth: ScreenW)
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
        img.contentMode = .scaleToFill
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
        img.contentMode = .scaleToFill
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
    
    var mode:OnlineApplyModel?{
        didSet{
            
            self.icon.image = UIImage.init(named: mode!.companyModel!.icon)
            self.address.text = mode?.positionAddress?.joined(separator: " ")
            self.time.text = mode?.endTimeStr
            self.name.text = mode?.companyModel?.name
            self.setupAutoHeight(withBottomViewsArray: [icon,time], bottomMargin: 10)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let views:[UIView] = [icon, name, addressIcon, address,timeIcon, time]
        self.sd_addSubviews(views)
        _ = icon.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,10)?.widthIs(45)?.heightIs(45)
        _ = name.sd_layout().leftSpaceToView(icon,10)?.topEqualToView(icon)?.autoHeightRatio(0)
        _ = addressIcon.sd_layout().topSpaceToView(name,5)?.leftEqualToView(name)?.widthIs(15)?.heightIs(15)
        _ = address.sd_layout().leftSpaceToView(addressIcon,5)?.topEqualToView(addressIcon)?.autoHeightRatio(0)
        _ = timeIcon.sd_layout().topSpaceToView(addressIcon,5)?.leftEqualToView(addressIcon)?.widthIs(15)?.heightIs(15)
        _ = time.sd_layout().leftSpaceToView(timeIcon,5)?.topEqualToView(timeIcon)?.autoHeightRatio(0)
        
        address.setMaxNumberOfLinesToShow(2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
