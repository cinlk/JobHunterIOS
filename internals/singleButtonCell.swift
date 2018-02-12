//
//  singleButtonCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class singleButtonCell: UITableViewCell {

    
    enum type {
        case add
        case delete
    }
    
    
    private lazy var btn:UIButton = {  [unowned self] in
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setImage(UIImage.barImage(size: CGSize.init(width: 30, height: 30), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "delete"), for: .normal)
        btn.setTitle("添加", for: .normal)
        btn.backgroundColor = UIColor.green
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        return btn
    }()
    
    var btnType:singleButtonCell.type = .delete{
        didSet{
            switch btnType {
            case .add:
                
                btn.setTitle("添加", for: .normal)
                btn.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
            case .delete:
                btn.setTitle("删除", for: .normal)
                btn.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
            }
        }
    }
   

    typealias deleteCallBack = () -> Void
    
    var deleteItem:deleteCallBack?
    var addMoreItem:(()->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle  = .none
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(btn)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        _ = btn.sd_layout().centerXEqualToView(self.contentView)?.centerYEqualToView(self.contentView)?.widthIs(200)?.heightIs(25)
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func identity()->String{
        return  "singleButtonCell"
    }

    class func cellHeight()->CGFloat{
        return 60
    }
}


extension singleButtonCell{
    
    @objc func click(){
        switch btnType {
        case .add:
            self.addMoreItem?()
        case .delete:
            self.deleteItem?()
        }
        
    }
}
