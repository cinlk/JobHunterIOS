//
//  xiaomiTableCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/10.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class xiaomiTableCell: UITableViewCell {

    
   private lazy var timeLabel:UILabel = {
       let label = UILabel()
       label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
       label.font = UIFont.systemFont(ofSize: 16)
       label.textColor = UIColor.black
       label.textAlignment = .center
       //label.backgroundColor = UIColor.clear
       return label
    }()
    
    
    private lazy var inner:innerView = {  [unowned self] in
        let v = innerView.init()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 8
        v.layer.masksToBounds = true
        v.clipsToBounds = true
        return v
    }()
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.setViews()
        
    }
    
    private lazy var dd:UIView = {
        let v = UIView()
        return v
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   dynamic var mode:xiaomiNewsModel?{
        didSet{
            timeLabel.text = mode?.create_time
            inner.mode = mode
            self.setupAutoHeight(withBottomView: inner, bottomMargin: 0)
        }
    }
    
    private func setViews(){
        //self.contentView.
        self.contentView.sd_addSubviews([timeLabel, inner])
        
        _ = timeLabel.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(self.contentView,2.5)?.autoHeightRatio(0)
        _ = inner.sd_layout().leftSpaceToView(self.contentView,5)?.rightSpaceToView(self.contentView,5)?.topSpaceToView(self.timeLabel, 10)
        
    }
    
    
    class func identity()->String{
        return "xiaomiTableCell"
    }
    
}



 @objcMembers private class innerView:UIView {
    
    
    // 分割线
    private lazy var line:UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.init(r: 0.5, g: 0.5, b: 0.5, alpha: 0.5)
        return v
    }()
    
    // 阅读全文
    private lazy var read:UILabel = {
        let read = UILabel.init()
        read.text = "阅读全文"
        read.textColor = UIColor.darkGray
        read.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        read.font = UIFont.systemFont(ofSize: 12)
        return read
    }()
    
    private lazy var title:UILabel = {
        let title = UILabel.init()
        title.textColor = UIColor.black
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW - 15)
        title.font = UIFont.systemFont(ofSize: 14)
        return title
    }()
    
    
    private lazy var arrow:UIImageView = {
        let arrow = UIImageView.init(image: UIImage.init(named: "rightforward"))
        arrow.contentMode = .scaleAspectFill
        arrow.clipsToBounds = true
        return arrow
    }()
    
    private lazy var coverPictur:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        // 默认图片
        //img.image = UIImage.init(named: "b3")
        return img
    }()
    
    
   dynamic var mode:xiaomiNewsModel?{
        didSet{
            title.text = mode?.describetion
            coverPictur.image = UIImage.init(named: mode?.coverPicture ?? "xiaomiDefault")
            self.setupAutoHeight(withBottomView: read, bottomMargin: 5)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews(){
        self.backgroundColor = UIColor.white
        let views:[UIView] = [line, read, arrow, coverPictur, title]
        self.sd_addSubviews(views)
        
        //let heightImg:CGFloat = CGFloat(Int(arc4random_uniform(UInt32(300 - 10 + 1))))
        _ = coverPictur.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.heightIs(170)
        _ = title.sd_layout().topSpaceToView(coverPictur,2.5)?.leftEqualToView(self)?.rightEqualToView(self)?.autoHeightRatio(0)
        _ = read.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(title,5)?.autoHeightRatio(0)
        _ = arrow.sd_layout().rightSpaceToView(self, 10)?.topEqualToView(read)?.widthIs(20)?.bottomEqualToView(read)
        _ = line.sd_layout().bottomSpaceToView(read,5)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(1)
       
    }
}


extension xiaomiTableCell{
    
    // inner view 响应点击事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let newp = self.contentView.convert(point, to: inner)
        if inner.point(inside: newp, with: event){
            // 继续找到switchOff 的某个子view来响应事件
            return super.hitTest(point, with: event)
        }
        return  nil
        
    }
}
