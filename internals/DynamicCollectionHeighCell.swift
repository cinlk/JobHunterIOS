//
//  feedBackTypeCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let cellIdentity = "cell"
fileprivate let itemHeight:CGFloat = 30

@objcMembers class feedBackTypeCell: UITableViewCell {
    
    
    
    internal var selectItem:((_ item:String)->Void)?
    
    private lazy var flowlayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
    
        return layout
    }()
    
    internal lazy var collectionView:UICollectionView = { [unowned self] in
        let collection = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowlayout)
        collection.backgroundColor = UIColor.white
        collection.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
        collection.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collection.isScrollEnabled = false
        collection.isUserInteractionEnabled = true
        collection.register(itemCell.self, forCellWithReuseIdentifier: cellIdentity)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    dynamic internal var mode:[String]?{
        didSet{
            
            
            collectionView.reloadData()
            // 计算layout 的高度，在设置collectionView高度 调整cell高度
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height + 20
             _ = contentView.sd_layout().heightIs(height)
            //print(contentView.frame)
            self.setupAutoHeight(withBottomView: contentView, bottomMargin: 10)
            
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(collectionView)
       
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    class func identity()->String{
        return "feedBackTypeCell"
    }
    
}


extension feedBackTypeCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let mode = mode else {
            return UICollectionViewCell()
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentity, for: indexPath) as! itemCell
        cell.btn.setTitle(mode[indexPath.row], for: .normal)
        return cell
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? itemCell{
            cell.btn.isSelected = true
            cell.btn.backgroundColor = UIColor.orange
            self.selectItem?(mode![indexPath.row])
        }
       
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? itemCell{
            cell.btn.isSelected = false
            cell.btn.backgroundColor = UIColor.lightGray
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let mode = mode else {
            return CGSize.init(width: 0, height: 0)
        }
        
        let item = (mode[indexPath.row] as NSString).boundingRect(with: CGSize.init(width: CGFloat(ScreenW - 40), height: itemHeight), options: NSStringDrawingOptions.usesFontLeading, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], context: nil)
        
        return CGSize.init(width: item.width + 10, height: itemHeight)
    }
}


private class itemCell:UICollectionViewCell{
    
    internal lazy var btn:UIButton = {
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.layer.borderWidth = 0
        btn.layer.cornerRadius = 5
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.textAlignment  = .center
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.lightGray
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(btn)
        _ =  btn.sd_layout().leftEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)?.rightEqualToView(self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}









