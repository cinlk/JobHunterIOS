//
//  BaseShowJobViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit




class BaseShowJobViewController: BaseViewController {


    let toolBarHeight:CGFloat = 44

    // table 展示内容
    internal lazy var table:UITableView = {  [unowned self] in
        let table = UITableView()
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.viewBackColor()
        
        return table
    }()
    
    // 收藏按钮
    internal lazy var collectedBtn:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: toolBarHeight))
        btn.setTitle("收藏", for: .normal)
        btn.setTitle("已收藏", for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.titleLabel?.textAlignment = .right
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "collect").changesize(size: CGSize.init(width: 25, height: 25)), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "collected").changesize(size: CGSize.init(width: 25, height: 25)), for: .selected)
        btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 30)
        
        
        btn.addTarget(self, action: #selector(collected(_:)), for: .touchUpInside)
        return btn
    }()
    // 左边按钮空隙
    lazy var leftSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    
    
    // 分享barItem
    private lazy var shareBtn:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        btn.setImage(#imageLiteral(resourceName: "share").changesize(size: CGSize.init(width: 25, height: 25)), for: .normal)
        btn.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)

        return btn
    }()
    
    // 分享界面
     internal lazy var  shareapps:shareView = { [unowned self] in
        //放在最下方
        let view =  shareView(frame: CGRect(x: 0, y: ScreenH, width: ScreenW, height: shareViewH))
        UIApplication.shared.keyWindow?.addSubview(view)
        ShareOriginY = view.origin.y
        //view.delegate = self
        return view
    }()
    
    private var ShareOriginY:CGFloat = 0
    
    // share背景view
    private lazy var darkView :UIView = {
        let darkView = UIView()
        darkView.frame = CGRect(x: 0, y: 0, width:ScreenW, height:ScreenH)
        darkView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
        darkView.isUserInteractionEnabled = true // 打开用户交互
        let singTap = UITapGestureRecognizer(target: self, action:#selector(self.handleSingleTapGesture)) // 添加点击事件
        singTap.numberOfTouchesRequired = 1
        darkView.addGestureRecognizer(singTap)
        return darkView
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
    
    
    
   override func setViews(){
        self.view.backgroundColor = UIColor.white
    
        // 加载数据过程影藏view
        self.handleViews.append(table)
        self.handleViews.append(shareBtn)
    
        self.view.addSubview(table)
    
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: shareBtn)]
        
        // 底部toolbar按钮
        leftSpace.width = -18
        self.toolbarItems = [leftSpace,UIBarButtonItem.init(customView: collectedBtn)]
    
        self.navigationController?.toolbar.layer.borderWidth = 1
        self.navigationController?.toolbar.layer.borderColor = UIColor.lightGray.cgColor

        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    
        super.setViews()
        
    }
    
   
   @objc func share(_ btn:UIButton){
    
        self.navigationController?.view.addSubview(darkView)
    
        UIView.animate(withDuration: 0.3, animations: {
            self.shareapps.frame = CGRect(x: 0, y: ScreenH - shareViewH, width: ScreenW, height: shareViewH)
        }, completion: nil)
    }
    
    @objc func collected(_ btn:UIButton){
        
    }

    @objc func  handleSingleTapGesture(){
        
        darkView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, animations: {
            
            self.shareapps.origin.y =  self.ShareOriginY
        }, completion: nil)
    }
    
}

