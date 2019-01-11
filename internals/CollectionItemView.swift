//
//  CollectionItemView.swift
//  internals
//
//  Created by ke.liang on 2018/9/11.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


class TableViewHeader:UIView{
    
    
    internal lazy var label:UILabel = {
        
        let title = UILabel.init(frame: CGRect.zero)
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 17)
        title.textAlignment = .left
        title.text = ""
        title.lineBreakMode = .byWordWrapping
        return title
        
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing =  10
        layout.minimumInteritemSpacing = 5
        // 每行3个元素
        layout.itemSize = CGSize.init(width: (ScreenW - 60) / 4 , height: 20)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        // collection view  初始高度
        let coll = UICollectionView.init(frame: CGRect.init(x: 0, y: 25, width: ScreenW - 40, height: ScreenH), collectionViewLayout: layout)
        coll.backgroundColor = UIColor.clear
        coll.dataSource = self
        coll.delegate = self
        coll.isScrollEnabled  = false
        coll.showsVerticalScrollIndicator = false
        coll.register(labelCollectionCell.self, forCellWithReuseIdentifier: "cell")
        return coll
    }()
    
    
    
    var chooseItem:((_ word:String)->Void)?
    
    var mode:[String]?{
        didSet{
            
            self.collectionView.reloadData()
            // 布局后的高度
            let height = collectionView.collectionViewLayout.collectionViewContentSize.height + 5
            
            _ = self.collectionView.sd_layout().heightIs(height)
            self.setupAutoHeight(withBottomView: collectionView, bottomMargin: 5)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.viewBackColor()
        self.addSubview(label)
        self.addSubview(collectionView)
        
        _ = label.sd_layout().leftSpaceToView(self,20)?.topSpaceToView(self,20)?.autoHeightRatio(0)
        _ = collectionView.sd_layout().leftEqualToView(label)?.rightSpaceToView(self,20)?.topSpaceToView(label,5)?.heightIs(0)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

extension TableViewHeader:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! labelCollectionCell
        if let mode = mode{
            
            cell.label.text = mode[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let word = mode?[indexPath.row]{
            self.chooseItem?(word)
        }
    }
    
    
    
    
}


private class labelCollectionCell:UICollectionViewCell{
    
    fileprivate lazy var label:UILabel = {
        let l = UILabel.init(frame: CGRect.zero)
        l.font = UIFont.systemFont(ofSize: 12)
        l.textAlignment = .center
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 1
        l.textColor = UIColor.blue
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(label)
        _ = label.sd_layout().centerXEqualToView(self.contentView)?.centerYEqualToView(self.contentView)?.widthIs(self.contentView.width)?.heightIs(self.contentView.height)
        
    }
    
}