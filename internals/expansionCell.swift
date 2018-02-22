//
//  expansionCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class expansionCell: UITableViewCell {

    
  private lazy var title:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
   private lazy var icon:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        return img
    }()
    
   private lazy var detailLabel:UILabel = {
        
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    var mode:(title:String, detail:String, selected:Bool)?{
        didSet{
            self.title.text = mode?.title
            setTextLabel(str: mode!.detail)
            setSelectedCell(flag: mode!.selected)
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(title)
        self.contentView.addSubview(icon)
        self.contentView.addSubview(detailLabel)
        _ = title.sd_layout().leftSpaceToView(self.contentView,16)?.topSpaceToView(self.contentView,10)?.rightSpaceToView(self.contentView,100)?.heightIs(20)
        _ = icon.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(title)?.widthIs(15)?.heightIs(10)
        //_ = detailLabel.sd_layout().rightEqualToView(title)?.topSpaceToView(title,)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "expansionCell"
    }
    
    // 计算内容高度
    private func setTextLabel(str:String){
        
        let strCGRect = str.getStringCGRect(size: CGSize.init(width: ScreenW - 20, height: 0), font:  self.detailLabel.font)
        
        detailLabel.text = str
        detailLabel.frame = CGRect.init(x: 16, y: 40, width: ScreenW  - 20, height: strCGRect.height)
    }
    
    // 是否选中 设置color
    private func setSelectedCell(flag:Bool){
        if flag{

            self.icon.image = UIImage.init(named: "arrow_xl")
            self.title.textColor = UIColor.green
            
        }else{
            self.title.textColor = UIColor.black
            self.icon.image = UIImage.init(named: "arrow_mr")
        }
    }
    
    class func cellHeight()->CGFloat{
        
        return 40
    }
}
