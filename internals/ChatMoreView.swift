//
//  ChatMMoreView.swift
//  internals
//
//  Created by ke.liang on 2017/10/15.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

enum ChatMoreType:Int{
    case pic
    case camera
    case mycard
    case feedback // 快捷回复
    
}


fileprivate let cellNumbeOfOneRow = 3
fileprivate let CellRow = 2
fileprivate let cellNumberOfOnePage = cellNumbeOfOneRow * CellRow
fileprivate let MoreCellID = "moreCell"


protocol ChatMoreViewDelegate:NSObjectProtocol {
    func chatMoreView(moreView: ChatMoreView,didSelectedType type: ChatMoreType)
}

class ChatMoreView: UIView {
    
    weak var delegate: ChatMoreViewDelegate?
    
    
    lazy var moreView:UICollectionView = { [unowned self] in
        let collectView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: LXFChatHorizontalLayout(
            column: cellNumbeOfOneRow, row:CellRow))
        collectView.backgroundColor = UIColor.white
        collectView.delegate = self
        collectView.dataSource = self
        return collectView
        }()
    
    
    //lazy var pageContol:
    
    
    lazy var moreDataSource: [(name:String, icon:UIImage, type:ChatMoreType)] = {
        return [
            ("照片",#imageLiteral(resourceName: "iPhoneIcon"), ChatMoreType.pic),
            ("相机",#imageLiteral(resourceName: "camera"), ChatMoreType.camera),
            ("个人名片",#imageLiteral(resourceName: "briefcase"),  ChatMoreType.mycard),
            ("快捷回复",#imageLiteral(resourceName: "shixiday"), ChatMoreType.feedback)
        ]
        
    }()
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(moreView)
        //self.addSubview(page)
        
        _ = moreView.sd_layout().leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.heightIs(200)
        
        self.backgroundColor  = UIColor.lightGray
        
        moreView.contentSize = CGSize.init(width: UIScreen.main.bounds.width, height: moreView.height)
        moreView.register(LXFChatMoreCell.self, forCellWithReuseIdentifier: MoreCellID)
        
        
    }
    
}

extension ChatMoreView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let moreModel = moreDataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreCellID, for: indexPath) as? LXFChatMoreCell
        
        cell?.model = moreModel
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let moreModel = moreDataSource[indexPath.item]
        // 选择功能
        self.delegate?.chatMoreView(moreView: self, didSelectedType: moreModel.type)
    }
    
    
}

extension ChatMoreView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        
    }
}

class LXFChatMoreCell: UICollectionViewCell {
    lazy var itemButton: UIButton = {
        let itemBtn = UIButton()
        itemBtn.backgroundColor = UIColor.white
        itemBtn.isUserInteractionEnabled = false
        itemBtn.layer.cornerRadius = 10
        itemBtn.layer.masksToBounds = true
        itemBtn.layer.borderColor = UIColor.lightGray.cgColor
        itemBtn.layer.borderWidth = 0.5
        return itemBtn
    }()
    
    lazy var itemLabel: UILabel = {
        let itemL = UILabel()
        itemL.textColor = UIColor.gray
        itemL.font = UIFont.systemFont(ofSize: 11.0)
        itemL.textAlignment = .center
        return itemL
    }()
    
    var type: ChatMoreType?
    
    // MARK:- 记录属性
    var model: (name: String, icon: UIImage, type: ChatMoreType)? {
        didSet {
            self.itemButton.setImage(model?.icon, for: .normal)
            self.itemLabel.text = model?.name
            self.type = model?.type
            self.backgroundColor = UIColor.lightGray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(itemButton)
        self.contentView.addSubview(itemLabel)
        
        _ = itemLabel.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.bottomSpaceToView(self.contentView,2)?.heightIs(21)
        _ = itemButton.sd_layout().topSpaceToView(self.contentView,15)?.bottomSpaceToView(self.itemLabel,5)?.widthIs(60)?.centerXEqualToView(itemLabel)
        
        //        itemLabel.snp.makeConstraints { (make) in
        //            make.left.right.equalTo(self)
        //            make.bottom.equalTo(self.snp.bottom).offset(-2)
        //            make.height.equalTo(21)
        //        }
        //        itemButton.snp.makeConstraints { (make) in
        //            make.top.equalTo(self.snp.top).offset(6)
        //            make.bottom.equalTo(itemLabel.snp.top).offset(-5)
        //            make.width.equalTo(itemButton.snp.height)
        //            make.centerX.equalTo(self.snp.centerX)
        //        }
        
    }
}

