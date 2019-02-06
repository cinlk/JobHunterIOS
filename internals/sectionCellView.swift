//
//  sectionCellView.swift
//  internals
//
//  Created by ke.liang on 2018/3/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class SectionCellView: UITableViewCell {

    lazy var SectionTitle:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        return label
    }()
    
    lazy var rightBtn:UIButton = { [unowned self] in
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.addTarget(self, action: #selector(choose(_ :)), for: .touchUpInside)
        return btn
    }()
    
    var action:(()->Void)?
    
    
   dynamic var mode:String?{
        didSet{
            self.SectionTitle.text = mode ?? ""
            self.setupAutoHeight(withBottomView: SectionTitle, bottomMargin: 5)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(SectionTitle)
        self.contentView.addSubview(rightBtn)
        
        _ = SectionTitle.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.autoHeightRatio(0)
        SectionTitle.setMaxNumberOfLinesToShow(1)
        _ = rightBtn.sd_layout().rightSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.widthIs(120)?.heightIs(15)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "sectionCellView"
    }
}

extension SectionCellView{
    @objc private func choose(_ btn:UIButton){
        self.action?()
    }
}
