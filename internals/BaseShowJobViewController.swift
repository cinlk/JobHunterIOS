//
//  BaseShowJobViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let shareViewH = SingletoneClass.shared.shareViewH
fileprivate let collect:String = "收藏"
fileprivate let collected:String = "已收藏"
fileprivate let collectBtnW:CGFloat = 120

internal class collectBtn:UIButton{
    
    private weak var vc:BaseShowJobViewController?
    
    
    convenience init(frame:CGRect,  vc:BaseShowJobViewController){
        self.init(frame: frame)
        self.vc = vc
        self.addTarget(self.vc!, action: #selector(self.vc!.collected(_:)), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitle(collect, for: .normal)
        self.setTitle(collected, for: .selected)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel?.textAlignment = .right
        self.setTitleColor(UIColor.blue, for: .normal)
        self.backgroundColor = UIColor.white
        self.setImage(#imageLiteral(resourceName: "collect").changesize(size: CGSize.init(width: 25, height: 25), renderMode: .alwaysOriginal), for: .normal)
        self.setImage(#imageLiteral(resourceName: "collected").changesize(size: CGSize.init(width: 25, height: 25), renderMode: .alwaysOriginal), for: .selected)
        self.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class BaseShowJobViewController: BaseViewController {

    
    // table 展示内容
    internal lazy var table:UITableView = {  [unowned self] in
        let table = UITableView()
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.viewBackColor()
        return table
    }()
    
    // 收藏按钮
    internal lazy var collectedBtn:collectBtn = { [unowned self] in
        
        let btn = collectBtn.init(frame: CGRect.init(x: 0, y: 0, width: collectBtnW, height: GlobalConfig.toolBarH), vc: self)
        return btn
    }()
    
    // 左边按钮空隙
    lazy var leftSpace:UIBarButtonItem = {
        let b = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        // 底部toolbar按钮
        b.width = 0
        return b
    }()
    
    
    // 分享barItem
    private lazy var shareBtn:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        btn.setImage(#imageLiteral(resourceName: "share").changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: btn)]
        return btn
    }()
    
    // 分享界面
     internal lazy var  shareapps:ShareView = { [unowned self] in
        //放在最下方
        let view =  ShareView(frame: CGRect(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: shareViewH))
        return view
    }()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setToolbarHidden(false, animated: false)
         UIApplication.shared.keyWindow?.addSubview(shareapps)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setToolbarHidden(true, animated: false)
        shareapps.removeFromSuperview()
    }
    
    deinit {
        print("deinit baseshowJobVC \(String.init(describing: self))")
    }
    
   override func setViews(){
        self.view.backgroundColor = UIColor.white
    
        // 加载数据过程影藏view
        self.hiddenViews.append(table)
        self.hiddenViews.append(shareBtn)
    
        self.view.addSubview(table)
    

        self.toolbarItems = [leftSpace,UIBarButtonItem.init(customView: collectedBtn)]
    
        self.navigationController?.toolbar.layer.borderWidth = 1
        self.navigationController?.toolbar.layer.borderColor = UIColor.lightGray.cgColor

        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    
        super.setViews()
        
    }
    
   
   @objc internal func share(_ btn:UIButton){
    
        shareapps.showShare()
    
    }
    
    @objc internal func collected(_ btn:UIButton){
        fatalError("not implement")
    }

    
    @objc internal override func login(){
       
        let loginvc = UIStoryboard.init(name: GlobalConfig.StoryBordVCName.Main, bundle: nil).instantiateViewController(withIdentifier: GlobalConfig.StoryBordVCName.LoginVC) as! UserLogginViewController
        loginvc.navBack = true
        self.present(loginvc, animated: true, completion: nil)
    }
    
    internal func verifyLogin() -> Bool{
        if !GlobalUserInfo.shared.isLogin {
            
            self.view.presentAlert(type: UIAlertController.Style.alert, title: "请先登录", message: nil, items: [actionEntity.init(title: "确定", selector: #selector(login), args: nil)], target: self) { [weak self] (ac) in
                self?.present(ac, animated: true, completion: nil)
            }
            // 跳转到登录界面
            return false
        }
        return true
    }
    
    
}

