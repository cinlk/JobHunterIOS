//
//  ErrorPageView.swift
//  internals
//
//  Created by ke.liang on 2018/4/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let iconSize:CGSize = CGSize.init(width: 60, height: 60)
fileprivate let errorMsg:String = "数据加载失败，请检查你的网络"
fileprivate let conTitle:String = "重新连接"


protocol EorrorPageDelegate: class {
    //func reload()
    var tap:Driver<Void>{get}
}


class ErrorPageView: UIView,EorrorPageDelegate  {
    
    
    var tap: Driver<Void> {
        return self.resetBtn.rx.tap.asDriver()
    }

    
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
        des.text = errorMsg
        return des
    }()
    
    private lazy var resetBtn:UIButton = { [unowned self] in
        let btn = UIButton.init(title: (conTitle, .normal), fontSize: 16, alignment: .center, bColor: UIColor.blue)
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    override func layoutSubviews() {
        
        var views:[UIView] = [wifiImage, des , resetBtn]
        self.sd_addSubviews(views)
        _ = wifiImage.sd_layout().centerXEqualToView(self)?.topSpaceToView(self,15)?.widthIs(iconSize.width)?.autoHeightRatio(1)
        _ = des.sd_layout().topSpaceToView(wifiImage,10)?.centerXEqualToView(wifiImage)?.autoHeightRatio(0)
        _ = resetBtn.sd_layout().topSpaceToView(des,10)?.leftEqualToView(des)?.rightEqualToView(des)?.heightIs(30)
        
        super.layoutSubviews()
        views.removeAll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

