//
//  AreaCollectionView.swift
//  internals
//
//  Created by ke.liang on 2018/4/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



class AreaCollectionView: UIView {

    
    
    //test datas 地区
    internal var datas:[String] = []{
        didSet{
            self.collection.reloadData()
        }
    }
    
    
    internal var selectedCity:((_ city:String)->Void)?
    
    private lazy var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: (GlobalConfig.ScreenW - 50) / 3 , height: 40)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        return layout
    }()
    
    internal lazy var collection:UICollectionView = { [unowned self] in
        let col = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        col.allowsMultipleSelection = false
        col.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        col.dataSource = self
        col.delegate = self
        col.backgroundColor = UIColor.white
        col.tag  = 10
        col.autoresizesSubviews = false
        col.layer.removeAllAnimations()
        
        col.register(CollectionTextCell.self, forCellWithReuseIdentifier: CollectionTextCell.identity())
        return col
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collection)
        _ = collection.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomEqualToView(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}



extension AreaCollectionView:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionTextCell.identity(), for: indexPath) as? CollectionTextCell{
            cell.name.text = datas[indexPath.row]
            cell.name.textColor = UIColor.black
            cell.name.layer.borderColor = UIColor.clear.cgColor
            return cell
        }
        
        fatalError("no cell")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionTextCell{
            cell.name.textColor = UIColor.blue
            cell.name.layer.borderColor = UIColor.blue.cgColor
            self.selectedCity?(cell.name.text!)
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionTextCell{
            cell.name.textColor = UIColor.black
            cell.name.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    
    
    
}
