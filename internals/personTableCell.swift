//
//  personTableCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



fileprivate let imgH:CGFloat = 40
fileprivate let imgW:CGFloat = 40

class personTableCell: UITableViewCell {
    
    private var leftImg:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        
        return img
    }()
    
    private var title:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.textAlignment = .left
        
        return label
    }()
    
    
    var mode:(image:UIImage,title:String)? {
        didSet{
            title.text = mode?.title
            leftImg.image = mode?.image
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(leftImg)
        self.contentView.addSubview(title)
        _ = leftImg.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.bottomSpaceToView(self.contentView,5)?.widthIs(imgW)?.heightIs(imgH)
        _ = title.sd_layout().leftSpaceToView(leftImg,20)?.topEqualToView(leftImg)?.bottomEqualToView(leftImg)?.rightSpaceToView(self.contentView,10)
        
    }
    
    class func identity()->String{
        return "personcell"
        
    }
    class func cellHeight()->CGFloat{
        return 50
    }

}


