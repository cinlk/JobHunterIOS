//
//  BaseCollectionHorizonView.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class BaseCollectionHorizonView: UIView {

  
    
    lazy var topTitle:UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textAlignment = .left
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        return title
    }()
    
    lazy var rightBtn:UIButton = { [unowned self] in
        let btn = UIButton()
        btn.setTitle("查看全部", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        //btn.addTarget(self, action: #selector(choose(_ :)), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    lazy var collectionView:UICollectionView = { [unowned self] in
        
        
        let layout = CollectionHorizontalLayout(column: self.column, row: self.row)
        
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        collection.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin]
        collection.backgroundColor = UIColor.white
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        
        return collection
        
    }()
    
    
    private var column:Int = 0
    private var row:Int = 0
    
    
    init(frame: CGRect, column:Int, row:Int) {
        self.column = column
        self.row = row
        super.init(frame: frame)
        
        let views:[UIView] = [topTitle, rightBtn, collectionView]
        self.sd_addSubviews(views)
        
        _ = topTitle.sd_layout().topSpaceToView(self,5)?.leftSpaceToView(self,10)?.autoHeightRatio(0)
        _ = rightBtn.sd_layout().rightSpaceToView(self,10)?.centerYEqualToView(topTitle)?.widthIs(120)?.heightIs(15)
        
        _ = collectionView.sd_layout().topSpaceToView(topTitle,10)?.leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
