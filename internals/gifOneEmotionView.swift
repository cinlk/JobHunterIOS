//
//  gifOneEmotionView.swift
//  internals
//
//  Created by ke.liang on 2018/6/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

// gif 图
fileprivate let MEmotionCellNumberOfOneRow = 4
fileprivate let MEmotionCellRow = 2
fileprivate let MEmotionCellNumberOfOnePage  = MEmotionCellRow * MEmotionCellNumberOfOneRow



class gifEmotionView: UICollectionViewCell {

    
    
    
    internal var emotions: [MChatEmotion] =  [] {
        didSet{
            
            
            pageControl.numberOfPages = self.emotions.count / MEmotionCellNumberOfOnePage + (self.emotions.count % MEmotionCellNumberOfOnePage == 0 ? 0 : 1)
            
            self.emotionView.reloadData()
        }
    }
    
    
    
    internal var sendGif:((_ emo:MChatEmotion)->Void)?
    
    // second emotionView
    private lazy var emotionView: UICollectionView = { [unowned self] in
        let collectV = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: CollectionHorizontalLayout(column: MEmotionCellNumberOfOneRow, row: MEmotionCellRow))
        
        collectV.backgroundColor  = UIColor.backGroundColor()
        collectV.isPagingEnabled = true
        collectV.delegate  = self
        collectV.dataSource = self
        collectV.showsVerticalScrollIndicator = false
        collectV.showsHorizontalScrollIndicator = false
        collectV.register(DynamicChatEmotionCell.self, forCellWithReuseIdentifier: DynamicChatEmotionCell.identity())
        return collectV
    }()
    
    
    lazy var pageControl: UIPageControl = { [unowned self] in
        let pageC = UIPageControl()
       
        pageC.currentPage = 0
        pageC.pageIndicatorTintColor = UIColor.lightGray
        pageC.currentPageIndicatorTintColor = UIColor.gray
        pageC.backgroundColor = UIColor.backGroundColor()
        return pageC
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
        return "gifOneEmotionView"
    }
    
    

}


extension gifEmotionView{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
        
    }
    
}

extension gifEmotionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emotions.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let emo = emotions[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DynamicChatEmotionCell.identity(), for: indexPath) as? DynamicChatEmotionCell
        cell?.emotion = emo
        return cell!
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let emo = emotions[indexPath.row]
        self.sendGif?(emo)
        
        
    }
    
}
