//
//  listPostItemCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let iconSize:CGSize = CGSize.init(width: 30, height: 30)

@objcMembers class ListPostItemCell: ForumBaseCell {

    dynamic var mode:PostArticleModel?{
        didSet{
            guard let mode = mode   else {
                return
            }
            self.postTitle.text = mode.title
            // 显示板块
            if mode.showTag{
                self.postType.text = "[" + mode.type.describe + "]"
            }else{
                self.postType.text = ""
            }
            
            self.creatTime.text = mode.createTimeStr
            if let url = mode.authorIcon  {
                self.authorIcon.kf.indicatorType = .activity
                self.authorIcon.kf.setImage(with: Source.network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                self.authorIcon.image = #imageLiteral(resourceName: "avartar")
            }
            //self.authorIcon.image = UIImage.init(named: mode.authorIcon)
            let authNameStr = NSMutableAttributedString.init(string: mode.authorName!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
            authNameStr.append(NSAttributedString.init(string: " " + (mode.colleage ?? ""), attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            
            self.authorName.attributedText = authNameStr
            
            
            
            
            // 点赞
//            let ts = String(mode.thumbUP)
//            let thumbStr = NSMutableAttributedString.init(string: ts)
//            thumbStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: NSRange.init(location: 0, length: ts.count))
//            let attch = NSTextAttachment.init()
//            attch.image = UIImage.init(named: "thumbup")?.withRenderingMode(.alwaysTemplate).imageWithColor(color: UIColor.lightGray)
//            // 图片和文字水平对齐
//            attch.bounds = CGRect.init(x: 0, y: (UIFont.systemFont(ofSize: 12).capHeight - 15)/2, width: 15, height: 15)
//
//            let tmp = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: attch))
//            tmp.append(thumbStr)
//
            let thumbUp = self.buildAttributeStr(content: String(mode.thumbUP), image: #imageLiteral(resourceName: "thumbup"))
            let thumbUpWidth = thumbUp.boundingRect(with: CGSize.init(width: 100, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil).width + 10
            self.thumbs.attributedText = thumbUp
            _ = self.thumbs.sd_layout().widthIs(thumbUpWidth)
            
            // 回复
//            let rs = String(mode.reply)
//
//            let replyAttr = NSMutableAttributedString.init(string: rs)
//            replyAttr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: NSRange.init(location: 0, length: rs.count))
//            let commentAttch = NSTextAttachment.init()
//            commentAttch.image = UIImage.init(named: "comment")?.withRenderingMode(.alwaysTemplate).imageWithColor(color: UIColor.lightGray)
//            commentAttch.bounds = CGRect.init(x: 0, y: (UIFont.systemFont(ofSize: 12).capHeight - 15)/2, width: 15, height: 15)
//            //replyAttr.append(NSAttributedString.init(attachment: commentAttch))
//            let tmp2 = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: commentAttch))
//            tmp2.append(replyAttr)
//
            
            let reply =  self.buildAttributeStr(content: String(mode.reply), image: #imageLiteral(resourceName: "comment"))
            // 字符串width
            let replyWidth = reply.boundingRect(with: CGSize.init(width: 100, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil).width + 10
            self.reply.attributedText = reply
            _ = self.reply.sd_layout().widthIs(replyWidth)
            
            
            let read = self.buildAttributeStr(content: String(mode.read), image: #imageLiteral(resourceName: "eye"))
            let readWidth = read.boundingRect(with: CGSize.init(width: 100, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil).width + 10
            self.read.attributedText = read
            _ = self.read.sd_layout()?.widthIs(readWidth)
            
            self.setupAutoHeight(withBottomView: self.creatTime, bottomMargin: 5)
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "listPostItemCell"
    }

}


extension ListPostItemCell{
    private func buildAttributeStr(content:String, image:UIImage) -> NSMutableAttributedString {
        
        
        let cs = NSMutableAttributedString.init(string: content)
        cs.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: NSRange.init(location: 0, length: content.count))
        
        let imageAttch = NSTextAttachment.init()
        imageAttch.image = image.withRenderingMode(.alwaysTemplate).imageWithColor(color: UIColor.lightGray)
        imageAttch.bounds = CGRect.init(x: 0, y: (UIFont.systemFont(ofSize: 12).capHeight - 15)/2, width: 15, height: 15)
        //replyAttr.append(NSAttributedString.init(attachment: commentAttch))
        
        let res = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: imageAttch))
        res.append(cs)
        
        return res
    }
}
