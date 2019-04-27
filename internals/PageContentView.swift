//
//  PageContentView.swift
//  internals
//
//  Created by ke.liang on 2018/1/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

protocol PageContentViewScrollDelegate: class {
    func pageContenScroll(_ contentView: PageContentView, progress:CGFloat, sourcIndex:Int, targetIndex:Int)
    
}
private let CollectionCellID = "CollectionCellID"


class PageContentView: UIView {

    fileprivate var startOffsetX:CGFloat = 0
    private var childVCs:[UIViewController]?
    private weak var pVC:UIViewController?
    weak var delegate:PageContentViewScrollDelegate?
    fileprivate var isCkick:Bool = false
    
    lazy var collectionView:UICollectionView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = self.frame.size
        layout.scrollDirection = .horizontal
        
        let collv = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionCellID)
        collv.showsVerticalScrollIndicator = false
        collv.showsHorizontalScrollIndicator = false
        collv.isPagingEnabled = true
        collv.bounces = false
        collv.dataSource = self
        collv.delegate = self
        collv.scrollsToTop = false
        collv.contentInsetAdjustmentBehavior = .never
        
        return collv
    }()
    
    init(frame:CGRect, childVCs: [UIViewController], pVC: UIViewController) {
        super.init(frame: frame)
        self.childVCs = childVCs
        self.pVC = pVC
        childVCs.forEach { [weak self] (vc) in
            self?.pVC?.addChild(vc)
        
        }
        
        self.addSubview(collectionView)
        
        //collectionView.contentSize = CGSize.init(width: self.bounds.width * CGFloat(childVCs.count), height: self.bounds.height)

    }
    
    
    deinit {
        self.childVCs?.removeAll()
        //self.collectionView.cell
        
        print("deinit pageContent \(String.init(describing: self))")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension PageContentView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childVCs?.count ?? 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID, for: indexPath)
    
        cell.contentView.subviews.forEach { (view) in
            view.removeFromSuperview()
        
        }
//        // 这段代码内存泄露，在useloginvc dismiss 触发？？？
        let cVC = childVCs![indexPath.row]
        cVC.view.frame =  cell.contentView.frame
        cell.contentView.addSubview(cVC.view)
        return cell
    }
    

    
}


extension PageContentView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isCkick = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // label点击事件不执行（不然出现错误）
        if isCkick { return }
        
        var progress:CGFloat = 0
        var sourceIndex:Int = 0
        var targetIndex:Int = 0
        
        let currentOffsetX = scrollView.contentOffset.x
        let scrollWidth = scrollView.frame.width
        if currentOffsetX > startOffsetX{
            progress = currentOffsetX / scrollWidth  - floor(currentOffsetX / scrollWidth)
            sourceIndex = Int(currentOffsetX / scrollWidth)
            targetIndex = sourceIndex + 1 >= (childVCs?.count)! ? (childVCs?.count)! - 1 :  sourceIndex + 1
            
            // 刚好滑动到一个宽度
            if currentOffsetX - startOffsetX == scrollWidth{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{
            progress = 1 - (currentOffsetX/scrollWidth - floor(currentOffsetX/scrollWidth))
            targetIndex = Int(currentOffsetX/scrollWidth)
            sourceIndex = targetIndex + 1 >= (childVCs?.count)! ? (childVCs?.count)! - 1 : targetIndex + 1
            
        
        }
        delegate?.pageContenScroll(self, progress: progress, sourcIndex: sourceIndex, targetIndex: targetIndex)
        
    }
    
}

extension PageContentView{
    
    func moveToIndex(_ currentIndex: Int){
        isCkick = true
        
        let offsetX = CGFloat(currentIndex) * self.collectionView.frame.width
        // 触发scroller方法
        collectionView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: false)
    }
    
}


