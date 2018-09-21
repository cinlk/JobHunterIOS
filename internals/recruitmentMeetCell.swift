//
//  recruitmentMeetCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let columne:Int = 1
fileprivate let row:Int = 4

class recruitmentMeetCell: UITableViewCell {

    // 查看所有热门宣讲会
    var selectedIndex:(()->Void)?
    
    
    // 查看某个宣讲会
    var selectItem:(( _ mode:CareerTalkMeetingModel)->Void)?
    
    private lazy var baseCollection:BaseCollectionHorizonView = BaseCollectionHorizonView.init(frame: CGRect.zero, column: columne, row: row)
   
    
    var mode:(title:String,item:[CareerTalkMeetingModel])?{
        didSet{
            self.baseCollection.topTitle.text = mode?.title
            //self.table.reloadData()
            self.baseCollection.collectionView.reloadData()
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(baseCollection)
        baseCollection.collectionView.register(simpleRecruitCell.self, forCellWithReuseIdentifier: simpleRecruitCell.identity())
        baseCollection.rightBtn.addTarget(self, action: #selector(chooseAll(_ :)), for: .touchUpInside)
        baseCollection.collectionView.delegate = self
        baseCollection.collectionView.dataSource = self
        
        _ = baseCollection.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "recruitmentMeetCell"
    }
    
    class func cellHeight()->CGFloat{
        return 180
    }
}


extension recruitmentMeetCell{
    @objc private func chooseAll(_ btn:UIButton){
        if self.baseCollection.topTitle.text == ""{
            
        }else{
            // 跳转到职位的宣讲会界面
            
            self.selectedIndex?()
        }
    }
}


extension recruitmentMeetCell:UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode?.item.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: simpleRecruitCell.identity(), for: indexPath) as! simpleRecruitCell
        cell.mode = mode!.item[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.delegate?.chooseItem(index: indexPath.row)
        guard let mode = mode else {
            return
        }
        self.selectItem?(mode.item[indexPath.row])
        
    }
    
    
}

