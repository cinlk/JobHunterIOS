//
//  ErrorPageView.swift
//  internals
//
//  Created by ke.liang on 2018/4/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let iconSize:CGSize = CGSize.init(width: 60, height: 60)



class ErrorPageView: UIView {

    
    private lazy var wifiImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "disableWireless")
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var des:UILabel = {
        let des = UILabel.init()
        des.setSingleLineAutoResizeWithMaxWidth(100)
        des.textAlignment = .center
        des.textColor = UIColor.lightGray
        des.font = UIFont.systemFont(ofSize: 16)
        des.text = "数据加载失败，请检查你的网络"
        return des
    }()
    
    private lazy var resetBtn:UIButton = { [unowned self] in
        let btn = UIButton.init()
        btn.setTitle("重新连接", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.blue
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        return btn
    }()
    
    var reload:(()->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [wifiImage, des , resetBtn]
        self.sd_addSubviews(views)
        
        _ = wifiImage.sd_layout().centerXEqualToView(self)?.centerYEqualToView(self)?.widthIs(iconSize.width)?.autoHeightRatio(1)
        _ = des.sd_layout().topSpaceToView(wifiImage,10)?.centerXEqualToView(wifiImage)?.autoHeightRatio(0)
        _ = resetBtn.sd_layout().topSpaceToView(des,10)?.leftEqualToView(des)?.rightEqualToView(des)?.heightIs(30)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

extension ErrorPageView{
    @objc private func  refresh(){
        
        self.reload?()
    }
}
