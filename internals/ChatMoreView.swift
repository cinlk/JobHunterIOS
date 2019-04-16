//
//  ChatMMoreView.swift
//  internals
//
//  Created by ke.liang on 2017/10/15.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

enum ChatMoreType:String{
    case pic = "picture"
    case camera = "camera"
    //case mycard = "personCard"
    case feedback = "text"// 快捷回复
    case location = "location"
    case voice = "voice"
    
}


fileprivate let cellNumbeOfOneRow = 3
fileprivate let CellRow = 2
fileprivate let cellNumberOfOnePage = cellNumbeOfOneRow * CellRow



protocol chatMoreViewDelegate:class {
    func  selectetType(moreView: ChatMoreView,didSelectedType type: ChatMoreType)
}


class ChatMoreView: UIView {
    
    weak var delegate: chatMoreViewDelegate?
    
    private lazy var moreView:UICollectionView = { [unowned self] in
        let collectView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: CollectionHorizontalLayout(
            column: cellNumbeOfOneRow, row:CellRow))
        collectView.backgroundColor = UIColor.backGroundColor()
        collectView.register(ChatMoreCell.self, forCellWithReuseIdentifier: ChatMoreCell.identity())
        collectView.delegate = self
        collectView.dataSource = self
        collectView.showsVerticalScrollIndicator = false
        collectView.showsHorizontalScrollIndicator = false
        collectView.isPagingEnabled = false
        return collectView
    }()
    
    
    var moreDataSource: [(name:String, icon:UIImage, type:ChatMoreType)]? {
        didSet{
            self.moreView.reloadData()
        }
    }
    
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.addSubview(moreView)
        _ = moreView.sd_layout().leftEqualToView(self)?.topEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
        
    }
    
    deinit {
        print("deinit chatMoreView \(String.init(describing: self))")
    }
}

extension ChatMoreView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moreDataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let moreModel = moreDataSource?[indexPath.item], let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMoreCell.identity(), for: indexPath) as? ChatMoreCell{
            
            cell.model = moreModel
            return cell
        }
        
        return  UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let moreModel = moreDataSource?[indexPath.item]{
            self.delegate?.selectetType(moreView: self, didSelectedType: moreModel.type)
        }
    }
    
    
}


fileprivate class ChatMoreCell: UICollectionViewCell {
    
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
            self.itemButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            self.itemLabel.text = model?.name
            self.type = model?.type
            self.backgroundColor =  UIColor.backGroundColor()
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.contentView.addSubview(itemButton)
        self.contentView.addSubview(itemLabel)
        
        _ = itemLabel.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.bottomSpaceToView(self.contentView,2)?.heightIs(21)
        _ = itemButton.sd_layout().topSpaceToView(self.contentView,15)?.bottomSpaceToView(self.itemLabel,5)?.widthIs(60)?.centerXEqualToView(itemLabel)
        
      
        
    }
    
    class func identity()->String{
        return "ChatMoreCell"
    }
}

