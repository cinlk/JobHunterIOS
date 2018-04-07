//
//  ThirdPartLoginView.swift
//  internals
//
//  Created by ke.liang on 2018/4/6.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let title:String = "使用第三方登录"
fileprivate let items = 3
fileprivate let witdh = ScreenW - 20 - 3*15


protocol thirdPartLoginDelegate: class {
    func verifyLoggable(view:UIView, type: UMSocialPlatformType, respons:UMSocialUserInfoResponse)
    func showError(view:UIView,message:String)
    
    
}

class ThirdPartLoginView: UIView {

    
    private lazy var  loginTitle:UILabel = {
        let label = UILabel.init()
        label.text  = title
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(180)
        return label
    }()
    
    private lazy var weixinBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "wechat"), for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.addTarget(self, action: #selector(loginWeixin), for: .touchUpInside)
        return btn
        
    }()
    
    private lazy var weiboBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "sina"), for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.addTarget(self, action: #selector(loginWeiBo), for: .touchUpInside)

        return btn
    }()
    
    private lazy var qqBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "qq"), for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.addTarget(self, action: #selector(loginQQ), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var leftLine:UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
    private lazy var rightLine:UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
    
    weak var delegate:thirdPartLoginDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [loginTitle, weixinBtn, weiboBtn, qqBtn, leftLine, rightLine]
        
        self.sd_addSubviews(views)
        
        _ = loginTitle.sd_layout().topSpaceToView(self,10)?.centerXEqualToView(self)?.autoHeightRatio(0)
        _ = weiboBtn.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(loginTitle,20)?.widthIs(witdh/3)?.heightIs(50)
        _ = weixinBtn.sd_layout().leftSpaceToView(weiboBtn,10)?.topEqualToView(weiboBtn)?.widthRatioToView(weiboBtn,1)?.heightRatioToView(weiboBtn,1)
        _ = qqBtn.sd_layout().leftSpaceToView(weixinBtn,10)?.topEqualToView(weixinBtn)?.widthRatioToView(weixinBtn,1)?.heightRatioToView(weixinBtn,1)
        
        _ = leftLine.sd_layout().leftSpaceToView(self,10)?.rightSpaceToView(loginTitle, 10)?.heightIs(1)?.centerYEqualToView(loginTitle)
        _ = rightLine.sd_layout().rightSpaceToView(self,10)?.leftSpaceToView(loginTitle, 10)?.heightIs(1)?.centerYEqualToView(loginTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ThirdPartLoginView{
    // 第三方登录  判断用户是否安装weibo - app？？？
    @objc private func loginWeixin(){
        // 获取能够登录的 用户信息
        UMSocialManager.default().getUserInfo(with: .wechatSession, currentViewController: nil) { (res, error) in
            if error != nil {
                
            }else{
                if let response = res as? UMSocialUserInfoResponse{
                    print(response)
                }
            }
        }
    }
    
    @objc private func loginWeiBo(){
        
        UMSocialManager.default().getUserInfo(with: .sina, currentViewController: nil) { (res, error) in
            if error != nil {
                
            }else{
                if let response = res as? UMSocialUserInfoResponse{
                    print(response)
                }
            }
        }
    }
    @objc private func loginQQ(){
        
        UMSocialManager.default().getUserInfo(with: .QQ, currentViewController: nil) { (res, error) in
            if error != nil {
                
                self.delegate?.showError(view: self, message: error.debugDescription)
                
            }else{
                if let response = res as? UMSocialUserInfoResponse{
                    
                    // 得到授权信息
                    print("---------\(response)")
                    print(response.uid)
                    print(response.openid)
                    print(response.unionId)
                    print(response.accessToken)
                    print(response.expiration)
                    
                    // 用户信息
                    print(response.name)
                    print(response.iconurl)
                    print(response.unionGender)
                    
                    // sdk 数据源
                    print(response.originalResponse)
                    
                    // 与服务器交互，判断是否关联了 注册的手机号， 如果是就登录
                    
                    // 否则弹出界面 关联手机号，在登录
                    
                    self.delegate?.verifyLoggable(view: self, type: .QQ, respons: response)
                }
            }
        }
    }
}
