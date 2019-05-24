//
//  ResumePageCell.swift
//  internals
//
//  Created by ke.liang on 2018/7/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class ResumePageCell: UITableViewCell {

    
    internal var startEdit:Bool?{
        didSet{
            if startEdit!{
                
                self.textTitle.isUserInteractionEnabled = true
                self.checkMark.isHidden = true
                self.attacheImage.isHidden =  true
                _ = self.textTitle.sd_layout().widthIs(GlobalConfig.ScreenW - 40)
                self.textTitle.becomeFirstResponder()
                
            }
        }
    }
    
    dynamic internal var mode:ReumseListModel?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            
           
            
            self.textTitle.text = mode.name
            
           
            // 设置宽度
            var MarginWidth:CGFloat = 0
            if mode.resumeKind == .text{
                MarginWidth = 40 + 20
            }else{
                MarginWidth = 40 + 20 + 20
            }
            if let size = mode.name?.rect(withFont: UIFont.systemFont(ofSize: 14), size: CGSize.init(width: GlobalConfig.ScreenW - MarginWidth, height: CGFloat(20))){
                _ = self.textTitle.sd_layout().widthIs(size.width)
            }
            self.checkMark.isHidden = !mode.isPrimary!
            if mode.resumeKind == .attachment{
                 self.attacheImage.isHidden = false
                _ = self.attacheImage.sd_layout().widthIs(15)?.heightIs(15)
            }else{
                self.attacheImage.isHidden = true
                _ = self.attacheImage.sd_layout().widthIs(0)?.heightIs(0)
            }
            
            
            self.setupAutoHeight(withBottomView: textTitle, bottomMargin: 10)
        }
    }
    
    internal lazy var textTitle:UITextField = {
        let text = UITextField()
        text.isUserInteractionEnabled = false
        text.backgroundColor = UIColor.clear
        text.placeholder = "简历名称不能为空"
        text.adjustsFontSizeToFitWidth = true
        text.clearButtonMode = .whileEditing
        text.font = UIFont.systemFont(ofSize: 14)
        text.returnKeyType = UIReturnKeyType.done
        return text
    }()
    
    
    internal lazy var attacheImage:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.isHidden = true
        image.image = #imageLiteral(resourceName: "attach")
        return image
    }()
    
    
    internal lazy var checkMark:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.isHidden = true
        image.image = #imageLiteral(resourceName: "checked")
        return image
    }()
    
    private lazy var moreBtn:UIButton = { [unowned self] in 
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.setImage(#imageLiteral(resourceName: "more").changesize(size: CGSize.init(width: 15, height: 10)), for: .normal)
        btn.contentMode = .center
        btn.addTarget(self, action: #selector(choose), for: .touchUpInside)
        return btn
    }()
    
    // 设置
    internal var setting:((_ btn:UIButton)->Void)?
    
  
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [textTitle,attacheImage, checkMark,  moreBtn]
        self.selectionStyle = .none 
        self.contentView.sd_addSubviews(views)
        _ = textTitle.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.heightIs(20)
        _ = attacheImage.sd_layout().leftSpaceToView(textTitle,5)?.centerYEqualToView(textTitle)
        _ = checkMark.sd_layout().leftSpaceToView(attacheImage,5)?.centerYEqualToView(textTitle)?.widthIs(15)?.heightIs(15)
        
        _ = moreBtn.sd_layout().rightSpaceToView(self.contentView,10)?.centerYEqualToView(textTitle)?.widthIs(20)?.heightIs(20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "ResumePageCell"
    }
    
}

extension ResumePageCell{
    @objc private func choose(){
        self.setting?(moreBtn)
    }
}
