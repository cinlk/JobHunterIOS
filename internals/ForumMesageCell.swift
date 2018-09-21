//
//  ForumMesageCell.swift
//  internals
//
//  Created by ke.liang on 2018/7/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class ForumMesageCell: UITableViewCell {
    
   
    private lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        lb.isAttributedContent = true
        
        return lb
    }()
    
    private lazy var subTitle:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        lb.textAlignment = .left
        lb.textColor = UIColor.black
        return lb
    }()
    
    // 包裹 回复内容view
    private lazy var replyContent:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.viewBackColor()
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var reply:UILabel = {
        
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        lb.textAlignment = .left
        lb.textColor = UIColor.black
        return lb
    }()
    
    
    private lazy var time:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.setSingleLineAutoResizeWithMaxWidth(100)
        lb.textAlignment = .left
        lb.textColor = UIColor.lightGray
        return lb
    }()
    
    
    dynamic var mode:ForumMessage?{
        didSet{
            
            guard  let mode = mode  else {
                return
            }

            guard let type = mode.body?.type, let target = mode.body?.kind.describe else {
                return
            }
            
            let attr:NSMutableAttributedString?
            
            if let sender = mode.body?.senderName{
                
                attr = NSMutableAttributedString.init(string: sender, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor:UIColor.randomeColor()])
                
                attr!.append(NSAttributedString.init(string: " " + type.describe + "了你的"+target, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor:UIColor.black]))
                
                
            }else if let receiver = mode.body?.receiverName{
                attr = NSMutableAttributedString.init(string: "我" + type.describe + "了 ", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor:UIColor.black])
                
                attr!.append(NSAttributedString.init(string:   receiver , attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor:UIColor.randomeColor()]))
                attr?.append(NSAttributedString.init(string:  "的"  + target, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor:UIColor.black]))
                
                
            }else{
                return
            }
            
           
            titleLabel.attributedText = attr!
            
            subTitle.text = mode.body?.title
            time.text = mode.timeStr
            
            // 回复类型
            if type == .reply{
                guard let content = mode.body?.replyContent else {
                    return
                }
                
                let cgsize = UILabel.sizeOfString(string: content as NSString, font: reply.font, maxWidth:  ScreenW - 20)                
                 _ = replyContent.sd_layout().heightIs(cgsize.height + 10)
                
                reply.text = content
                self.setupAutoHeight(withBottomView: replyContent, bottomMargin: 10)


            }else {
                replyContent.isHidden = true
                self.setupAutoHeight(withBottomView: subTitle, bottomMargin: 10)
            }

            
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true 
        self.replyContent.addSubview(reply)
        
        _ = reply.sd_layout().topSpaceToView(replyContent,5)?.leftSpaceToView(replyContent,5)?.autoHeightRatio(0)
        
        let views:[UIView] = [titleLabel, subTitle, replyContent,time]
        self.contentView.sd_addSubviews(views)
        
        _ = titleLabel.sd_layout().topSpaceToView(self.contentView,10)?.leftSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        _ = subTitle.sd_layout().topSpaceToView(titleLabel,5)?.leftEqualToView(titleLabel)?.autoHeightRatio(0)
        _ = replyContent.sd_layout().topSpaceToView(subTitle,10)?.leftEqualToView(subTitle)?.rightSpaceToView(self.contentView,5)
        
        _ = time.sd_layout().rightSpaceToView(self.contentView,5)?.topEqualToView(titleLabel)?.autoHeightRatio(0)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    class func identity()->String{
        return "ForumMesageCell"
    }
    
}
