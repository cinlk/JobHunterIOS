//
//  xiaomiTableCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/10.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class xiaomiTableCell: UITableViewCell {

    
    lazy var timeButton:UIButton = {
       let btn = UIButton.init(frame: CGRect.zero)
       btn.sizeToFit()
       btn.setTitle("时间", for: .normal)
       btn.backgroundColor = UIColor.lightGray
       btn.alpha = 0.7
       btn.setTitleColor(UIColor.white, for: .normal)
       btn.isUserInteractionEnabled = false
       return btn
        
    }()
    
    
    
    fileprivate lazy var v:innerCell = {  [unowned self] in
        let v = innerCell.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 8
        v.layer.masksToBounds = true
        return v
    }()
    
    
    // 包裹views
    lazy var innerView:UIView = {
       let v = UIView.init(frame: CGRect.zero)
       v.backgroundColor = UIColor.lightGray
       v.layer.cornerRadius = 8
       return v
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.lightGray
        self.selectionStyle = .none
        self.innerView.clipsToBounds = true
        self.setViews()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func setViews(){
        self.contentView.addSubview(innerView)
        self.innerView.addSubview(timeButton)
        self.innerView.addSubview(v)
        
        _ = innerView.sd_layout().leftSpaceToView(self.contentView,5)?.rightSpaceToView(self.contentView,5)?.topSpaceToView(self.contentView,5)?.bottomSpaceToView(self.contentView,5)
        
        _ = timeButton.sd_layout().centerXEqualToView(innerView)?.topSpaceToView(innerView,5)?.widthIs(120)?.heightIs(15)
        _ = v.sd_layout().leftEqualToView(innerView)?.bottomEqualToView(innerView)?.rightEqualToView(innerView)?.topSpaceToView(timeButton,5)

    }
    
    
    class func cellHeight()->CGFloat{
        return 180.0
    }
    class func identity()->String{
        return "xiaomiTableCell"
    }
    
}



private class innerCell:UIView {
    
    lazy var line:UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    lazy var read:UILabel = {
        let read = UILabel.init()
        read.text = "阅读全文"
        read.textColor = UIColor.darkGray
        read.sizeToFit()
        read.font = UIFont.systemFont(ofSize: 12)
        return read
    }()
    
    // 如何换行？？
    lazy var title:UILabel = {
        let title = UILabel.init()
        title.textColor = UIColor.black
        title.sizeToFit()
        title.text = "吊袜带挖多另外的没胃口大达瓦大文多多无多哇大无多哇多哇多无"
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.font = UIFont.systemFont(ofSize: 14)
        return title
    }()
    
    
    lazy var arrow:UIImageView = {
        let arrow = UIImageView.init(image: UIImage.init(named: "rightforward"))
        arrow.contentMode = .scaleAspectFit
        arrow.clipsToBounds = true
        return arrow
    }()
    
    lazy var mainPictur:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.image = UIImage.init(named: "b3")
        
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews(){
        self.addSubview(line)
        self.addSubview(read)
        self.addSubview(arrow)
        self.addSubview(mainPictur)
        self.addSubview(title)
        
        let size = self.title.text?.getStringCGRect(size: CGSize.init(width: ScreenW - 20 , height: 0), font: UIFont.systemFont(ofSize: 14))
        
        _ = line.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomSpaceToView(self,20)?.heightIs(1)
        _ = read.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(line,5)?.bottomSpaceToView(self,5)?.widthIs(120)
        _ = arrow.sd_layout().rightSpaceToView(self,10)?.topEqualToView(read)?.widthIs(20)?.bottomEqualToView(read)
        _ = title.sd_layout().leftSpaceToView(self,10)?.rightSpaceToView(self,10)?.heightIs((size?.height)!)?.bottomSpaceToView(line,0)
        _ = mainPictur.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomSpaceToView(title,0)
        
       
        
    }
    
   
}
