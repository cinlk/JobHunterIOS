//
//  QuickLoggingViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let text = "登录代表你同意 "

class QuickLoggingViewController: UITableViewController {

   
    private lazy var userIcon:UIImageView = {
        let imageV = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        imageV.contentMode = .scaleAspectFill
        imageV.image  = #imageLiteral(resourceName: "me").withRenderingMode(.alwaysTemplate)
        return imageV
    }()
    
    private lazy var numberIcon:UIImageView = {
        let imageV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        imageV.contentMode = .scaleAspectFill
        imageV.image = #imageLiteral(resourceName: "password").withRenderingMode(.alwaysTemplate)
        return imageV
    }()
    
    
    private lazy var verifyBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 20))
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(self.validateCode), for: UIControlEvents.touchUpInside)

        
        return btn
    }()
    
    
    // 倒计时
    private  lazy var codeNumber:ValidateNumber =  ValidateNumber(button: verifyBtn)!
    
    
    
    private lazy var tableFootView:UIView = {  [unowned self] in 
        let v = UIView(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 40))
        v.isUserInteractionEnabled = true 
        let lb = UILabel()
        lb.setSingleLineAutoResizeWithMaxWidth(ScreenW - 40)
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textAlignment = .center
        lb.textColor = UIColor.black
        lb.text = text
        v.addSubview(lb)
        
        let userProtocal = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 30))
        userProtocal.backgroundColor = UIColor.white
        userProtocal.setTitle("<<app用户协议>>", for: .normal)
        userProtocal.setTitleColor(UIColor.blue, for: .normal)
        userProtocal.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        userProtocal.titleLabel?.textAlignment = .left
        userProtocal.addTarget(self, action: #selector(showProtocal), for: .touchUpInside)
        v.addSubview(userProtocal)
        _ = userProtocal.sd_layout().rightSpaceToView(v,10)?.centerYEqualToView(v)?.widthIs(118)
        _ = lb.sd_layout().rightSpaceToView(userProtocal,10)?.centerYEqualToView(userProtocal)?.autoHeightRatio(0)
        
        
        return v
        
        
    }()
    
    
//    // 协议显示
//    private lazy var showUserProtocal:UIButton = {
//
//    }()
//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: innerTextFiledCell.identity()) as? innerTextFiledCell{
            if indexPath.row == 0 {
                cell.textFiled.placeholder = "请输入手机号"
                 
                cell.textFiled.leftImage = userIcon
            }else if indexPath.row == 1{
                cell.textFiled.placeholder = "请输入验证码"
                cell.textFiled.leftImage = numberIcon
                cell.textFiled.rightBtn = verifyBtn
                cell.textFiled.righPadding = 10
            }
            cell.textFiled.leftView?.tintColor = UIColor.orange
            cell.textFiled.keyboardType = .numberPad
            cell.textFiled.leftPadding = 10
           
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}




extension QuickLoggingViewController{
    private func setViews(){
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = tableFootView
        self.tableView.isScrollEnabled = false
        self.tableView.bounces = false
        
        self.tableView.register(innerTextFiledCell.self, forCellReuseIdentifier: innerTextFiledCell.identity())
        self.tableView.backgroundColor = UIColor.white
        
        
        
    }
}


extension QuickLoggingViewController{
    @objc private func showProtocal(){
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.randomeColor()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

//
extension QuickLoggingViewController{
    @objc private func validateCode(){
        
         codeNumber.start()
    }
}
