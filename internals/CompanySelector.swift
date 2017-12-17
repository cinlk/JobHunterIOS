//
//  CompanySelector.swift
//  internals
//
//  Created by ke.liang on 2017/12/11.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import YNDropDownMenu



class CompanySelector: YNDropDownView{
    
    var data = ["公司阶段":["不限","初创型","成长行","成熟性","已上市"],
                "企业性质":["不限","国企","民营","合资","外企","国家机关","事业单位"],
                "公司规模":["不限","20以下","20-99人","100-499人","500-999人","1000人以上"]
                ]
    
    var keys = ["公司阶段", "企业性质", "公司规模"]
    
    // 传递的数据
    var conditions = ["公司阶段":"不限","企业性质":"不限","公司规模":"不限"]
    var passData: ((_ cond:[String:String]?) -> Void)?
    var collectionView:UICollectionView!
    
    var initial = 3
    
    
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


extension CompanySelector: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
     
        return  (data[keys[section]]?.count)!
        
    }
    
    
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: CompanySelectorCell.identity(), for: indexPath) as? CompanySelectorCell{
            
            cell.title.text = data[keys[indexPath.section]]?[indexPath.row]
            // 第一次加载 显示默认
            if indexPath.row == 0  && initial > 0 {
                cell.contentView.backgroundColor = UIColor.blue
                initial  -= 1
                //
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.top)
            }
            return cell
            
            
        }
        let cell = CompanySelectorCell.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 20))
        //cell.button.setTitle(data[keys[indexPath.section]]?[indexPath.row], for: .normal)
        return cell
    }

   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompanySelectorHeader.identity(), for: indexPath) as! CompanySelectorHeader
            header.name.text = keys[indexPath.section]
            return header
        }
        
        return UICollectionReusableView.init()
        
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let cell =  collectionView.cellForItem(at: indexPath) as! CompanySelectorCell
        cell.contentView.backgroundColor = UIColor.blue
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        for index in collectionView.indexPathsForSelectedItems!{
            if indexPath.section == index.section {
                // 同section 不能多选
                let oldcell = collectionView.cellForItem(at: index) as! CompanySelectorCell
                oldcell.contentView.backgroundColor = UIColor.white
                self.collectionView.deselectItem(at: index, animated: true)

            }
        }
        return true
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CompanySelectorCell
        cell.contentView.backgroundColor = UIColor.white
       
    }
    
    
}

extension CompanySelector{
    
    @objc func filterItem(){
        if let indexs =  collectionView.indexPathsForSelectedItems{
            indexs.forEach({ (index) in
                let cell = collectionView.cellForItem(at: index) as! CompanySelectorCell
                conditions[keys[index.section]] =  cell.title.text
            })
        }
        self.hideMenu()
        // 闭包回传
        if let pass = passData{
            pass(conditions)
        }
        
       
    }
}

class CompanySelectorCell:UICollectionViewCell{
    
    
    
    lazy var title:UILabel = {
       let lb = UILabel.init()
       lb.font = UIFont.systemFont(ofSize: 12)
       lb.textColor = UIColor.black
       lb.textAlignment = .center
       return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.frame = self.contentView.frame
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(title)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    static func identity()->String{
        return "CompanySelectorCell"
    }
}

class CompanySelectorHeader: UICollectionReusableView{
    
    lazy var name:UILabel = {
        let name = UILabel.init()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = UIColor.blue//
        name.textAlignment = .left
        name.font = UIFont.systemFont(ofSize: 12)
        
        return name
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        self.addSubview(name)
        _ = name.sd_layout().topSpaceToView(self,2.5)?.bottomSpaceToView(self,2.5)?.leftSpaceToView(self,5)?.widthIs(120)?.heightIs(15)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func identity()->String{
        return "header"
    }
    
    
}

