//
//  CompanySelector.swift
//  internals
//
//  Created by ke.liang on 2017/12/11.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import YNDropDownMenu



// 实习条件
class DropInternCondtionView: YNDropDownView{
    
    private var datas:[String:[String]] = [:]{
        didSet{
            keys = datas.keys.reversed()
            datas.keys.reversed().forEach{
                conditions[$0] = "不限"
            }
            
        }
    }
    
    // section关键字
    private var keys:[String] = []
    
    // 存储结果数据
    private var conditions:[String:String] = [:]
    
    var passData: ((_ cond:[String:String]?) -> Void)?
    
    
    
    // confirm button
    private lazy var clearAll:UIButton = {
        let clear = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 40))
        clear.setTitle("清空", for: .normal)
        clear.setTitleColor(UIColor.black, for: .normal)
        clear.backgroundColor = UIColor.white
        clear.layer.borderWidth = 1
        clear.layer.borderColor = UIColor.black.cgColor
        clear.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        return clear
    }()
    
    private lazy var confirm:UIButton = {
        let confirm = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 40))
        confirm.setTitle("确定", for: .normal)
        confirm.setTitleColor(UIColor.white, for: .normal)
        confirm.backgroundColor = UIColor.blue
        confirm.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
        return confirm
        
    }()
    // 加入toolbar
    private lazy var toolBar:UIToolbar = {
        let bar = UIToolbar.init()
        bar.barStyle = .default
        bar.backgroundColor = UIColor.white
        bar.items = []
        return bar
    }()
    
    
    
    private lazy var layout:UICollectionViewFlowLayout = { 
       
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize  = CGSize.init(width: (ScreenW - 40)/3, height: 35)
        layout.scrollDirection  = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing  = 20
        layout.sectionHeadersPinToVisibleBounds = false
        
        //layout.sectionInset  = UIEdgeInsets.init(top: 10, left: 5, bottom: 20, right: 10)
        return layout
        
    }()
    
    private lazy var collectionView:UICollectionView = { [unowned self] in
       
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.viewBackColor()
        collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 45, right: 10)
        collectionView.allowsMultipleSelection = false
        
        collectionView.register(CollectionTextCell.self, forCellWithReuseIdentifier: CollectionTextCell.identity())
        collectionView.register(CollectionLabelHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CollectionLabelHeaderView.identity())
       return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(collectionView)
        self.addSubview(toolBar)
        
        _ = toolBar.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(44)
        _ = collectionView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.heightIs(self.bounds.height)

        
        let space = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 50
        toolBar.items?.append(contentsOf: [UIBarButtonItem.init(customView: clearAll),space, UIBarButtonItem.init(customView: confirm)])
        
        loadData()
        
    }
    
    

 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension DropInternCondtionView{
    
    @objc private func clear(_ btn:UIButton){
       
        keys.forEach{
            conditions[$0] = "不限"
        }
        
        self.collectionView.reloadData()
        
    }
    
    @objc private func done(_ btn:UIButton){
        self.passData?(conditions)
        self.hideMenu()
        
    }
}

extension DropInternCondtionView{
    private func loadData(){
        datas =  ["每周实习天数":["不限","1天","2天","3天","4天","5天"],
                  
                  "实习日薪":["不限","100以下","100-200","200以上"],
                  "实习月数":["不限","1月","1-3月","3-6月","6月以上"],
                  "学历":["不限","大专","本科","硕士","博士"],
                  "是否转正":["不限","提供转正"],
        ]
        
    }
}

extension DropInternCondtionView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
     
        return  datas[keys[section]]?.count  ?? 0
        
    }
    
    
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: CollectionTextCell.identity(), for: indexPath) as? CollectionTextCell{
            
            guard let name = datas[keys[indexPath.section]]?[indexPath.row] else { return UICollectionViewCell() }
            
            cell.name.text = name
             //
            if (conditions[keys[indexPath.section]]?.contains(name))!{
                cell.name.textColor = UIColor.blue
                cell.name.layer.borderColor = UIColor.blue.cgColor
            }else{
                
                cell.name.textColor = UIColor.black
                cell.name.layer.borderColor = UIColor.clear.cgColor
                
            }
            return cell
            
        }
       
        fatalError("no cell")
    }

   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionLabelHeaderView.identity(), for: indexPath) as! CollectionLabelHeaderView
            header.titleLabel.text = keys[indexPath.section]
            header.titleLabel.font = UIFont.systemFont(ofSize: 20)
            return header
        }
        
        return UICollectionReusableView.init()
        
    }
    // section size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: ScreenW, height: 60)
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        let cell =  collectionView.cellForItem(at: indexPath) as! CollectionTextCell
        guard let name = cell.name.text else {return}
        // 每个section只有一个被选中
        conditions[keys[indexPath.section]] = name
        cell.name.textColor = UIColor.blue
        cell.name.layer.borderColor = UIColor.blue.cgColor

        collectionView.reloadData()
    }
}

