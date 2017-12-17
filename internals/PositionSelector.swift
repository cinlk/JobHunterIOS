//
//  PositionSelector.swift
//  internals
//
//  Created by ke.liang on 2017/12/11.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import YNDropDownMenu

class PositionSelector:YNDropDownView{
    
    
    var data = ["学历要求":["大专","本科","硕士","博士","不要求"]
        ,"工作性质":["全职","兼职","实习"]
        ]
    
    
    var keys = ["学历要求", "工作性质"]
    
    // 传递的数据
    var conditions:[String:[String]] = ["学历要求":[],"工作性质":[]]
    var passData: ((_ cond:[String:[String]]?) -> Void)?
    
    // confirm button
    lazy var confirm:UIButton  = {
        let btn = UIButton.init()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(filterItem), for: .touchUpInside)
        return btn
        
    }()
    
    var collectionView:UICollectionView!
    
    lazy var layout:UICollectionViewFlowLayout = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize  = CGSize.init(width: 80, height: 20)
        layout.scrollDirection  = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing  = 15
        layout.sectionInset  = UIEdgeInsets.init(top: 10, left: 5, bottom: 20, right: 10)
        layout.headerReferenceSize   = CGSize.init(width: self.size.width, height: 20)
        return layout
        
        }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.contentInset = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 0)
        collectionView.allowsMultipleSelection = true
        collectionView.register(CompanySelectorCell.self, forCellWithReuseIdentifier: CompanySelectorCell.identity())
        collectionView.register(CompanySelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CompanySelectorHeader.identity())
        
        
        self.addSubview(collectionView)
        _ = collectionView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomEqualToView(self)
        
        self.addSubview(confirm)
        _ = confirm.sd_layout().leftSpaceToView(self,20)?.rightSpaceToView(self,20)?.bottomSpaceToView(self,20)?.heightIs(30)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension PositionSelector:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return  (data[keys[section]]?.count)!
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: CompanySelectorCell.identity(), for: indexPath) as? CompanySelectorCell{
            cell.title.text = data[keys[indexPath.section]]?[indexPath.row]
            return cell
            
        }
        let cell = CompanySelectorCell.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 20))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CompanySelectorCell
        cell.contentView.backgroundColor = UIColor.blue
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CompanySelectorCell
        cell.contentView.backgroundColor = UIColor.white
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompanySelectorHeader.identity(), for: indexPath) as! CompanySelectorHeader
            header.name.text = keys[indexPath.section]
            return header
        }
        
        return UICollectionReusableView.init()
        
    }
    
}

extension PositionSelector{
    
    @objc func filterItem() {
        keys.forEach { (str) in
            conditions[str]?.removeAll()
        }
        if let indexs =  collectionView.indexPathsForSelectedItems{
            indexs.forEach({ (index) in
                let cell = collectionView.cellForItem(at: index) as! CompanySelectorCell
                conditions[keys[index.section]]?.append(cell.title.text!)
            })
        }
        self.hideMenu()
        // 闭包回传
        if let pass = passData{
            pass(conditions)
        }
        
    }
}
