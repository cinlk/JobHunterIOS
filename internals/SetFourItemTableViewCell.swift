//
//  SetFourItemTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/19.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


protocol selectedItemDelegate: class {
    
    func showdelivery()
    func showInvitation()
    func showollections()
    func showPostArticle()
    
}

class SetFourItemTableViewCell: UITableViewCell {

    
    
    
    weak var delegate:selectedItemDelegate?
    
    
    private lazy var stack:UIStackView = {
        let sk = UIStackView.init()
        sk.axis = .horizontal
        sk.alignment = .fill
        sk.distribution = .fillEqually
        sk.backgroundColor = UIColor.red
        sk.spacing = 0
        sk.tintColor = UIColor.black
        return sk
    }()
    
    
    
    
    private lazy var deliveryView:UIView = { [unowned self] in
        
        let v = UIView()
        
        
        let btn = UIButton.init()
        btn.setImage(#imageLiteral(resourceName: "delivery").changesize(size: CGSize.init(width: 40, height: 45)), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "delivery").changesize(size: CGSize.init(width: 40, height: 45)), for: .highlighted)
        btn.addTarget(self, action: #selector(delivery), for: .touchUpInside)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "投递记录"
        v.addSubview(label)
        v.addSubview(btn)
        
        _ = btn.sd_layout().centerXEqualToView(label)?.bottomSpaceToView(label,5)?.heightIs(45)?.widthRatioToView(v,1)
        _ = label.sd_layout().bottomSpaceToView(v,5)?.widthRatioToView(v,1)?.heightIs(20)

        
        return v
        
    }()
    
    
    private lazy var inviteView:UIView = {  [unowned self] in
        let v = UIView()
        
        
        let btn = UIButton.init()
        btn.setImage(#imageLiteral(resourceName: "volk").changesize(size: CGSize.init(width: 40, height: 45)), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "volk").changesize(size: CGSize.init(width: 40, height: 45)), for: .highlighted)
        btn.addTarget(self, action: #selector(invite), for: .touchUpInside)

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "我的邀请"
        v.addSubview(label)
        v.addSubview(btn)
        
        _ = btn.sd_layout().centerXEqualToView(label)?.bottomSpaceToView(label,5)?.heightIs(45)?.widthRatioToView(v,1)
        _ = label.sd_layout().bottomSpaceToView(v,5)?.widthRatioToView(v,1)?.heightIs(20)
        
        
        return v
        
    }()
    
    
    private lazy var collectionView:UIView = {  [unowned self] in
        let v = UIView()
        
        
        let btn = UIButton.init()
        btn.setImage(#imageLiteral(resourceName: "collection").changesize(size: CGSize.init(width: 40, height: 45)), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "collection").changesize(size: CGSize.init(width: 40, height: 45)), for: .highlighted)
        btn.addTarget(self, action: #selector(collected), for: .touchUpInside)

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "我的收藏"
        v.addSubview(label)
        v.addSubview(btn)
        
        _ = btn.sd_layout().centerXEqualToView(label)?.bottomSpaceToView(label,5)?.heightIs(45)?.widthRatioToView(v,1)
        _ = label.sd_layout().bottomSpaceToView(v,5)?.widthRatioToView(v,1)?.heightIs(20)
        
        
        return v
        
    }()
    
    
    
    private lazy var postView:UIView = {  [unowned self] in
        let v = UIView()
        
        
        let btn = UIButton.init()
        btn.setImage(#imageLiteral(resourceName: "feedback").changesize(size: CGSize.init(width: 40, height: 45)), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "feedback").changesize(size: CGSize.init(width: 40, height: 45)), for: .highlighted)
        btn.addTarget(self, action: #selector(article), for: .touchUpInside)

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "我的帖子"
        v.addSubview(label)
        v.addSubview(btn)
        
        _ = btn.sd_layout().centerXEqualToView(label)?.bottomSpaceToView(label,5)?.heightIs(45)?.widthRatioToView(v,1)
        _ = label.sd_layout().bottomSpaceToView(v,5)?.widthRatioToView(v,1)?.heightIs(20)
        
        
        return v
        
    }()
    
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        stack.addArrangedSubview(deliveryView)
        stack.addArrangedSubview(inviteView)
        stack.addArrangedSubview(collectionView)
        stack.addArrangedSubview(postView)
        
        self.contentView.addSubview(stack)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.clear
        _ = stack.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    class func identity()->String{
        return "SetFourItemTableViewCell"
    }
    
    class func cellHeight()->CGFloat{
        return 80
    }
}

extension SetFourItemTableViewCell{
    
    @objc private func delivery(){
        self.delegate?.showdelivery()
    }
    
    @objc private func invite(){
        self.delegate?.showInvitation()
    }
    
    @objc private func collected(){
        self.delegate?.showollections()
    }
    @objc private func article(){
        self.delegate?.showPostArticle()
    }
    

    
}
