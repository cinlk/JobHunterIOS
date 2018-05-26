//
//  PasswordLoggingViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class PasswordLoggingViewController: UITableViewController {

    
    
    
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
    
    private lazy var lash:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        btn.backgroundColor = UIColor.clear
        btn.setBackgroundImage(UIImage.init(named: "lash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setBackgroundImage(UIImage.flipImage(image: #imageLiteral(resourceName: "lash"), orientation: UIImageOrientation.down).withRenderingMode(.alwaysTemplate), for: UIControlState.selected)
        btn.tintColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        return btn
        
    }()
    
    
    private lazy var ForgetPasswordBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("忘记密码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var tableFootView:UIView = {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 40))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // 获取验证码界面
    private lazy var  resetpdVC = ResetPasswordViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                cell.textFiled.placeholder = "请输入账号"
                
                cell.textFiled.leftImage = userIcon
            }else if indexPath.row == 1{
                cell.textFiled.placeholder = "请输入密码"
                cell.textFiled.leftImage = numberIcon
                cell.textFiled.rightBtn = lash
                cell.textFiled.showLine = false
                cell.textFiled.isSecureTextEntry = true
                //cell.textFiled
            }
            cell.textFiled.leftView?.tintColor = UIColor.orange
            cell.textFiled.leftPadding = 10
            
            return cell
            
        }
        
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}




extension PasswordLoggingViewController{
    @objc private func click(_ btn:UIButton){
        
        btn.isSelected = !btn.isSelected
        btn.tintColor =  btn.isSelected ? UIColor.orange : UIColor.lightGray
        if let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as? innerTextFiledCell{
            cell.textFiled.isSecureTextEntry = btn.isSelected ? false : true
        }
        
    }
}

extension PasswordLoggingViewController{
    private func setViews(){
        
        tableFootView.addSubview(ForgetPasswordBtn)
        _ = ForgetPasswordBtn.sd_layout().rightSpaceToView(tableFootView,10)?.centerYEqualToView(tableFootView)?.widthIs(120)?.heightIs(20)
        
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = tableFootView
        self.tableView.isScrollEnabled = false
        self.tableView.bounces = false
        self.tableView.register(innerTextFiledCell.self, forCellReuseIdentifier: innerTextFiledCell.identity())
        self.tableView.backgroundColor = UIColor.white
        
        
        
    }
}

extension PasswordLoggingViewController{
    @objc private func resetPassword(){
       
        self.navigationController?.pushViewController(resetpdVC, animated: true)
    }
}
