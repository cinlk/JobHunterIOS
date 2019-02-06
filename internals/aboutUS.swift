//
//  aboutUS.swift
//  internals
//
//  Created by ke.liang on 2018/2/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import MBProgressHUD


fileprivate let headerViewH:CGFloat = 160
fileprivate let cellIdentiy:String = "default"
fileprivate let cellItem:[AboutUsModel.item] = [.serviceLaw, .wechat, .weibo, .serviceCall, .share]
fileprivate let footViewH:CGFloat = GlobalConfig.ScreenH - headerViewH - (CGFloat(cellItem.count) * 45) - GlobalConfig.NavH
fileprivate let shareViewH = SingletoneClass.shared.shareViewH


class aboutUS: BaseViewController {

    // mode
    private var mode:AboutUsModel?
    
    // header
    private lazy var header:personTableHeader = {
        let v = personTableHeader.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: headerViewH))
        v.isHR = false
        return v
    }()
    // footer
    private lazy var footer:aboutUSFootView = {
        let v = aboutUSFootView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: footViewH))
        v.backgroundColor = UIColor.viewBackColor()
        return v
    }()
    
    private lazy var tableView:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.isScrollEnabled = false
        tb.tableHeaderView = header
        tb.tableFooterView = footer
        tb.separatorStyle = .singleLine
        tb.showsVerticalScrollIndicator = false
        tb.showsHorizontalScrollIndicator = false
        tb.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentiy)
        
        return tb
    }()
    
   
    
    // sharedView
    private lazy var share:ShareView = {
        let v = ShareView.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: shareViewH))
        v.delegate = self
        return v
    }()
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.addSubview(share)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        share.removeFromSuperview()
    }
    
    override func setViews() {
        self.title = "关于我们"
        
        self.view.addSubview(tableView)
        _ = tableView.sd_layout().topSpaceToView(self.view, GlobalConfig.NavH)?.rightEqualToView(self.view)?.leftEqualToView(self.view)?.bottomEqualToView(self.view)
        self.hiddenViews.append(tableView)
        super.setViews()
    }
    
    override func  didFinishloadData() {
        super.didFinishloadData()
        
        self.header.mode = (image: mode?.appIcon ?? "default", name:mode?.appName ?? "" , introduce: mode?.appDes ?? "")
        self.header.backgroundColor = UIColor.viewBackColor()
        
        self.footer.mode =  (company:mode!.company ?? "",version: mode!.version ?? "", copyRight:mode!.copyRight ?? "")
        self.tableView.reloadData()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    

    

}


extension aboutUS:UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        let item = cellItem[indexPath.row]
        switch item {
        case .wechat, .serviceCall:
           
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
            cell.textLabel?.text = item.des
            if item == .wechat{
                cell.detailTextLabel?.text =  mode?.wecaht ?? ""
            }else{
                cell.detailTextLabel?.text =  mode?.servicePhone ?? ""
            }
            cell.detailTextLabel?.textAlignment = .right
            cell.detailTextLabel?.textColor = UIColor.lightGray
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
            
        default:
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text =  item.des
            cell.textLabel?.textAlignment = .left
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = cellItem[indexPath.row]
        switch item {
        case .serviceLaw:
            guard let url = mode?.serviceRuleURL else {
                return
            }
            
            let serviceTerm = ServiceTerm()
            serviceTerm.serviceURL =  url
            self.navigationController?.pushViewController(serviceTerm, animated: true)
        case .wechat:
            wechat()
        case .weibo:
            weibo()
        case .share:
            self.shared()
            
        case .serviceCall:
            let cell = tableView.cellForRow(at: indexPath)
            cell?.presentAlert(type: .alert, title: "呼叫电话\(mode!.servicePhone!)", message: nil, items: [actionEntity.init(title: "呼叫", selector: #selector(callPhone), args: nil)], target: self, complete: { alert in
                    self.present(alert, animated: true, completion: nil)
            })
            
        }
    }
    
}


// 异步加载数据
extension aboutUS{
    private func loadData(){
     
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 1)
            
            self?.mode = AboutUsModel(JSON: ["wecaht":"wechat12345","servicePhone":"400-546-6754","appId":"1234566","appIcon":"evil",
                                             "appName":"校招","appDes":"中国最好的校招平台","company":"xxxxx 版权所有","version":"Version 1.1.0","copyRight":"xxx.com @CopyRight 2018 ","serviceRuleURL":"http://www.baidu.com"])
            
            DispatchQueue.main.async(execute: {
               self?.didFinishloadData()
            })
            
        }
    }
    
}

extension aboutUS{
    private func wechat(){
        // 复制到粘贴版
       
        
        // nav 的view 没问题！
        //showOnlyTextHub(message: "微信账号已经复制, 跳转到微信", view: (self.navigationController?.view)!)
        self.navigationController?.view.showToast(title: "微信账号已经复制, 跳转到微信", customImage: nil, mode: .text)
        let paste = UIPasteboard.general
        paste.string = mode?.wecaht ?? ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             openApp(appURL: "weixin://") { (res) in
                print("打开微信应用 \(res)")
            }
        }

    }
    
    // 浏览器打开微博
    private func weibo(){
        openApp(appURL: "https://m.weibo.cn/u/3632539935") { (bool) in
            print("打开微博网页 \(bool)")
        }
    }
    
    
    // 客服电话拨打
    @objc private func callPhone(){
        guard let phone = mode?.servicePhone else {return}
        let phoneNumber =  phone.replacingOccurrences(of: "-", with: "")
        let phoneStr = "tel://" + phoneNumber
        
        openApp(appURL: phoneStr) { (bool) in
            print("call \(phoneStr)")
        }
    }
    // shared
    private func shared(){
        share.showShare()
        

    }
    

    
    
    
}
// share view 代理
extension aboutUS: shareViewDelegate{
    
    
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
        share.dismiss()
        
    }
    
    
}

private class aboutUSFootView:UIView{
    
    
    private lazy var company:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var version:UILabel = {
        let version = UILabel.init(frame: CGRect.zero)
        version.font = UIFont.systemFont(ofSize: 14)
        version.textColor = UIColor.black
        version.textAlignment = .center
        return version
    }()
    
    private lazy var copoyright:UILabel = {
        let copyRight = UILabel.init(frame: CGRect.zero)
        copyRight.font = UIFont.systemFont(ofSize: 14)
        copyRight.textColor = UIColor.black
        copyRight.textAlignment = .center
        return copyRight
    }()
    
    var mode:(company:String, version:String, copyRight:String)?{
        didSet{
            self.company.text = mode?.company
            self.version.text = mode?.version
            self.copoyright.text = mode?.copyRight
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        self.addSubview(company)
        self.addSubview(version)
        self.addSubview(copoyright)
        _ = copoyright.sd_layout().centerXEqualToView(self)?.leftSpaceToView(self,10)?.rightSpaceToView(self,10)?.bottomSpaceToView(self,10)?.heightIs(20)
        _ = version.sd_layout().centerXEqualToView(self)?.bottomSpaceToView(copoyright,2.5)?.rightEqualToView(copoyright)?.leftEqualToView(copoyright)?.heightIs(20)
        _ = company.sd_layout().centerXEqualToView(self)?.bottomSpaceToView(version,2.5)?.rightEqualToView(version)?.leftEqualToView(version)?.heightIs(20)
        
    }
    
}
