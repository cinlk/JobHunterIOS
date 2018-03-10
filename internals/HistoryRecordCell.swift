//
//  HistoryRecordCell.swift
//  internals
//
//  Created by ke.liang on 2017/12/10.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

@objcMembers class HistoryRecordCell: UITableViewCell {

    private lazy var leftImage:UIImageView = {
        let leftImage = UIImageView.init()
        leftImage.image = #imageLiteral(resourceName: "round")
        leftImage.contentMode = .scaleAspectFit
        leftImage.clipsToBounds = true
        return leftImage
        
    }()
    private lazy var item:UILabel = {
        let item = UILabel.init()
        item.textAlignment = .left
        item.font = UIFont.systemFont(ofSize: 16)
        item.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        item.textColor = UIColor.black
        return item
    }()
    
    private lazy var deleteIcon:UIButton = { [unowned self] in
        let deleteIcon = UIButton.init(type: .custom)
        deleteIcon.setBackgroundImage(#imageLiteral(resourceName: "delete"), for: .normal)
        deleteIcon.backgroundColor = UIColor.clear
        deleteIcon.clipsToBounds = true
        deleteIcon.addTarget(self, action: #selector(deletItem), for: .touchUpInside)
        return deleteIcon
    }()
    
    
    dynamic var mode:String?{
        didSet{
            item.text = mode!
            self.setupAutoHeight(withBottomView: item, bottomMargin: 15)
        }
    }
    
    
    var deleteRow:((_ name:String)->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(leftImage)
        self.contentView.addSubview(item)
        self.contentView.addSubview(deleteIcon)
        
        
        _ = leftImage.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.heightIs(15)?.widthIs(15)
        _ = item.sd_layout().leftSpaceToView(leftImage,20)?.topEqualToView(leftImage)?.autoHeightRatio(0)
        
        _ = deleteIcon.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(leftImage)?.bottomEqualToView(item)?.widthIs(20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func identity()->String{
        return "searchHistoryList"
    }
    

}

extension HistoryRecordCell{
    @objc private func deletItem(){
        self.deleteRow?(self.mode!)
    }
}
