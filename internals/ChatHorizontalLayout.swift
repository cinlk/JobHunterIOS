//
//  ChatMMoreView.swift
//  internals
//
//  Created by ke.liang on 2017/10/15.
//  Copyright © 2017年 lk. All rights reserved.
//


import UIKit

class CollectionHorizontalLayout: UICollectionViewFlowLayout {
    // 保存所有item
    fileprivate var attributesArr: [UICollectionViewLayoutAttributes] = []
    fileprivate var col: Int = 0
    fileprivate var row: Int = 0
    
    fileprivate var lineSpace:CGFloat = 0
    init(column: Int, row: Int, lineSpace:CGFloat = 0 ) {
        super.init()
        self.col = column
        self.row = row
        self.lineSpace = lineSpace
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 重新布局
    override func prepare() {
        super.prepare()
        
        
        let itemW: CGFloat = GlobalConfig.ScreenW / CGFloat(col)
        let itemH: CGFloat = (collectionView?.bounds.height)! / CGFloat(row)
        // 设置itemSize
        itemSize = CGSize(width: itemW, height: itemH)
        minimumLineSpacing = self.lineSpace
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 设置collectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = true
        //let insertMargin = (collectionView!.bounds.height - CGFloat(row) * itemH) * 0.5
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        // 计算每个cell 布局
        var page = 0
        let itemsCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        for itemIndex in 0..<itemsCount {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            page = itemIndex / (col * row)
            // 通过一系列计算, 得到x, y值
            let x = itemSize.width * CGFloat(itemIndex % Int(col)) + (CGFloat(page) * GlobalConfig.ScreenW)
            let y = itemSize.height * CGFloat((itemIndex - page * row * col) / col)
            
            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            //
            attributesArr.append(attributes)
        }
        
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var rectAttributes: [UICollectionViewLayoutAttributes] = []
        _ = attributesArr.map({
            if rect.contains($0.frame) {
                rectAttributes.append($0)
            }
        })
        return rectAttributes
    }
    
    // 横向
    override var collectionViewContentSize: CGSize {
        let size: CGSize = super.collectionViewContentSize
        let collectionViewWidth: CGFloat = self.collectionView!.frame.size.width
        //let nbOfScreen:Int = 1
        let nbOfScreen: Int = Int(ceil(size.width / collectionViewWidth))
        let newSize: CGSize = CGSize(width: collectionViewWidth * CGFloat(nbOfScreen), height: size.height)
        return newSize
    }
}

