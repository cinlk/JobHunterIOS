//
//  baseEmotionView.swift
//  internals
//
//  Created by ke.liang on 2018/6/23.
//  Copyright © 2018年 lk. All rights reserved.
//


// 表情符
fileprivate let kEmotionCellNumberOfOneRow = 8
fileprivate let kEmotionCellRow = 3
fileprivate let kEmotionCellNumberOfOnePage = kEmotionCellRow * kEmotionCellNumberOfOneRow


import UIKit

class baseEmotionView: UICollectionViewCell {

 
    
    
    internal var emotions:[MChatEmotion]  = [] {
        didSet{
            pageControl.numberOfPages = self.emotions.count / kEmotionCellNumberOfOnePage + (self.emotions.count % kEmotionCellNumberOfOnePage == 0 ? 0 : 1)
            self.emotionView.reloadData()
        }
    }
    

    internal var insertEmotion:((_ emotion:MChatEmotion)->Void)?
    
    lazy var pageControl: UIPageControl = { [unowned self] in
        let pageC = UIPageControl()
        pageC.currentPage = 0
        pageC.pageIndicatorTintColor = UIColor.lightGray
        pageC.currentPageIndicatorTintColor = UIColor.gray
        pageC.backgroundColor = UIColor.backGroundColor()
        return pageC
    }()
    
    private lazy var emotionView: UICollectionView = { [unowned self] in
        let collectV = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionHorizontalLayout(column: kEmotionCellNumberOfOneRow, row: kEmotionCellRow))
        collectV.backgroundColor = UIColor.backGroundColor()
        collectV.isPagingEnabled = true
        collectV.dataSource = self
        collectV.delegate = self
        collectV.showsVerticalScrollIndicator = false
        collectV.showsHorizontalScrollIndicator = false
        collectV.register(StaticChatEmotionCell.self, forCellWithReuseIdentifier: StaticChatEmotionCell.identity())
        return collectV
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(emotionView)
        self.addSubview(pageControl)
        
        _ = emotionView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomEqualToView(self)
        
        _ = self.pageControl.sd_layout().bottomSpaceToView(self,10)?.heightIs(10)?.widthIs(60)?.centerXEqualToView(self)
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "baseEmotionView"
    }
    
}


extension baseEmotionView{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
        
    }
    
}

extension baseEmotionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emotions.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let emo = emotions[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StaticChatEmotionCell.identity(), for: indexPath) as? StaticChatEmotionCell
        cell?.emotion = emo
        return cell!
   
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let emo = emotions[indexPath.row]
        self.insertEmotion?(emo)
       
    }
    
}
