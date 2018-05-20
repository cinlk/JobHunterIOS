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
fileprivate let footViewH:CGFloat = ScreenH - headerViewH - (CGFloat(cellItem.count) * 45) - NavH
fileprivate let CelloffsetX:CGFloat = 16.0


class aboutUS: BaseViewController {

    
    // mode
    private var mode:AboutUsModel?
    
    // header
    private lazy var header:aboutUSHeaderView = {
        let v = aboutUSHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: headerViewH))
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    // footer
    private lazy var footer:aboutUSFootView = {
        let v = aboutUSFootView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: footViewH))
        v.backgroundColor = UIColor.lightGray
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
    
    //phone call Alert
    private lazy var phoneAlert:UIAlertController = { [unowned self] in
        let alert = UIAlertController.init(title: "呼叫电话 \(self.mode!.servicePhone)", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let call = UIAlertAction.init(title: "呼叫", style: .default, handler: { (action) in
            self.callPhone()
        })
        alert.addAction(cancel)
        alert.addAction(call)
        return alert
    }()
    
    // sharedView
    private lazy var share:shareView = {
        let v = shareView.init(frame: CGRect.init(x: 0, y: ScreenH, width: ScreenW, height: shareViewH))
        UIApplication.shared.keyWindow?.addSubview(v)
        v.delegate = self
        return v
    }()
    
     // shareView的背景
    lazy var sharebackBtn: UIButton = {  [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        btn.alpha = 0.5
        btn.backgroundColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(hiddenShare), for: .touchUpInside)
        return btn
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
      
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "关于我们"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    override func setViews() {
        
        self.view.addSubview(tableView)
        _ = tableView.sd_layout().topSpaceToView(self.view, NavH)?.rightEqualToView(self.view)?.leftEqualToView(self.view)?.bottomEqualToView(self.view)
        self.handleViews.append(tableView)
        super.setViews()
    }
    
    override func  didFinishloadData() {
        super.didFinishloadData()
        
        self.header.mode = (icon: UIImage.init(named: mode!.appIcon!)!,name:mode?.appName ?? "" , desc:mode!.appDes ?? "")
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
            cell.accessoryType = .disclosureIndicator
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
            _ = cell.detailTextLabel?.sd_layout().rightEqualToView(cell.contentView)?.widthIs(200)
            
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
            let serviceTerm = ServiceTerm()
            serviceTerm.serviceURL = mode?.serviceRuleURL ?? ""
            
            self.navigationController?.pushViewController(serviceTerm, animated: true)
        case .wechat:
            wechat()
        case .weibo:
            weibo()
        case .share:
            self.shared()
            
        case .serviceCall:
            self.present(phoneAlert, animated: true, completion: nil)
            
        }
    }
    
}


// 异步加载数据
extension aboutUS{
    private func loadData(){
     
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            
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
       
        
         // 使用tableview  和 view 点击后 cell frame 错误?
        // 换成 self.navigationController?.view 没问题
        let hub = MBProgressHUD.showAdded(to: (self.navigationController?.view)!, animated: false)
        hub.mode = .text
        hub.label.text = "微信账号已经复制, 跳转到微信"
        // 黑色半透明
        hub.bezelView.backgroundColor = UIColor.backAlphaColor()
        hub.margin = 5
        hub.label.textColor = UIColor.white
        hub.removeFromSuperViewOnHide = true

        hub.hide(animated: false, afterDelay: 2)
        
        
        let paste = UIPasteboard.general
        paste.string = mode?.wecaht ?? ""
        //showOnlyTextHub(message: "微信账号已经复制, 跳转到微信", view: self.tableView, second: 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
             openApp(appURL: "weixin://") { (res) in
                print("打开微信应用 \(res)")
                hub.hide(animated: true)
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
    private func callPhone(){
        guard let phone = mode?.servicePhone else {return}
        let phoneNumber =  phone.replacingOccurrences(of: "-", with: "")
        let phoneStr = "tel://" + phoneNumber
        
        openApp(appURL: phoneStr) { (bool) in
            print("call \(phoneStr)")
        }
    }
    // shared
    private func shared(){
        // navigation最外层
        self.navigationController?.view.addSubview(sharebackBtn)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.share.frame.origin.y = ScreenH - shareViewH
            
        }, completion: nil)
    
    }
    
    @objc private func hiddenShare(){
       
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.share.frame.origin.y = ScreenH
            
            self.navigationController?.view.willRemoveSubview(self.sharebackBtn)
            self.sharebackBtn.removeFromSuperview()
        }, completion: nil)
        
    }
    
    
    
}
// share view 代理
extension aboutUS: shareViewDelegate{
    
    func hiddenShareView(view: UIView) {
        self.hiddenShare()
    }
    
    func handleShareType(type: UMSocialPlatformType) {
        
    }
    
    
}

private class  aboutUSHeaderView:UIView{
    
    private lazy var  icon:UIImageView = {
        let icon = UIImageView.init(frame: CGRect.zero)
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        return icon
    }()
    
    private  lazy var name:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var describe:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    
    var mode:(icon:UIImage, name:String, desc:String)?{
        didSet{
            self.icon.image = mode?.icon
            self.name.text = mode?.name
            self.describe.text = mode?.desc
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
        
        self.addSubview(icon)
        self.addSubview(name)
        self.addSubview(describe)
        
        _ = icon.sd_layout().centerXEqualToView(self)?.centerYEqualToView(self)?.topSpaceToView(self,40)?.widthIs(50)?.heightIs(50)
        _ = name.sd_layout().topSpaceToView(icon,2)?.centerXEqualToView(icon)?.leftSpaceToView(self,10)?.rightSpaceToView(self,10)?.heightIs(20)
        _ = describe.sd_layout().topSpaceToView(name,2)?.centerXEqualToView(icon)?.leftEqualToView(name)?.rightEqualToView(name)?.heightIs(20)
        
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
