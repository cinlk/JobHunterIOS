//
//  CompanySelector.swift
//  internals
//
//  Created by ke.liang on 2017/12/11.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import YNDropDownMenu



fileprivate let spaceWidth:CGFloat = 25
fileprivate let defaultChoose:String = "不限"
fileprivate let transforKey:[String:String] = ["是否转正":"can_transfer","学历":"degree","每周实习天数":"days",
                                               "实习日薪":"pay", "实习月数":"months"]

fileprivate class bottomToolBar:UIToolbar{
    
    
    private lazy var clearAll:UIButton = { [unowned self] in
        let clear = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: (GlobalConfig.ScreenW - spaceWidth - 10)/2, height: 35))
        clear.setTitle("清空", for: .normal)
        clear.setTitleColor(UIColor.black, for: .normal)
        clear.backgroundColor = UIColor.white
        clear.layer.borderWidth = 1
        clear.layer.borderColor = UIColor.black.cgColor
        clear.addTarget(self.pview!, action: #selector(self.pview!.clear), for: .touchUpInside)
        return clear
        
    }()
    
    private lazy var confirm:UIButton = { [unowned self] in
        let confirm = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: (GlobalConfig.ScreenW - spaceWidth - 10)/2, height: 35))
        confirm.setTitle("确定", for: .normal)
        confirm.setTitleColor(UIColor.white, for: .normal)
        confirm.backgroundColor = UIColor.blue
        confirm.addTarget(self.pview!, action: #selector(self.pview!.done), for: .touchUpInside)
        return confirm
        
        
    }()
    
    private lazy var space:UIBarButtonItem = {
        let s = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        s.width = spaceWidth
        return s
    }()
    
    
    
    private weak var pview:DropInternCondtionView?
    
    
    convenience init(frame:CGRect, view:DropInternCondtionView){
        self.init(frame: frame)
        self.pview = view
        
        
        self.barStyle = .default
        self.backgroundColor = UIColor.white
        self.items = []
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.items?.append(contentsOf: [UIBarButtonItem.init(customView: clearAll),space, UIBarButtonItem.init(customView: confirm)])
        
    }
}



// 实习条件
class DropInternCondtionView: YNDropDownView{
    
    private var datas:[String:[String]] = [:]{
        didSet{
            keys = datas.keys.reversed()
//            datas.keys.reversed().forEach{
//                conditions[$0] = "不限"
//            }
            
        }
    }
    
    // section关键字
    private var keys:[String] = []
    
    // 存储结果数据
    private var conditions:[String:String] = [:]
    
    var passData: ((_ cond:[String:String]?) -> Void)?
    

    // 加入toolbar
    private lazy var toolBar:bottomToolBar = {
        let bar = bottomToolBar.init(frame: CGRect.zero, view: self)
        return bar
    }()
    
    
    
    private lazy var layout:UICollectionViewFlowLayout = {
       
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize  = CGSize.init(width: (GlobalConfig.ScreenW - 50)/3, height: 35)
        layout.scrollDirection  = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing  = 10
        layout.sectionHeadersPinToVisibleBounds = false
        
        //layout.sectionInset  = UIEdgeInsets.init(top: 10, left: 5, bottom: 20, right: 10)
        return layout
        
    }()
    
    private lazy var collectionView:UICollectionView = { [unowned self] in
       
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets.init(top: 5, left: 10, bottom: 45, right: 10)
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CollectionTextCell.self, forCellWithReuseIdentifier: CollectionTextCell.identity())
        collectionView.register(CollectionLabelHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionLabelHeaderView.identity())
       return collectionView
    }()
    
    
    // 全局的 透明背景view
    internal lazy var backGroundBtn:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 0))
        btn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(collectionView)
        self.addSubview(toolBar)
        
        _ = toolBar.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(40)
        _ = collectionView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.heightIs(self.bounds.height)
        
        loadData()
        
    }
    
    

 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    // 显示 和 关闭 view
    override func dropDownViewOpened() {
        UIApplication.shared.keyWindow?.addSubview(backGroundBtn)
        if let vc =  (self.getParentViewController()?.parent as? JobHomeVC){
            vc.isScrollEnabled = false
        }
        self.getParentViewController()?.tabBarController?.tabBar.isHidden = true
    }
    
    override func dropDownViewClosed() {
        backGroundBtn.removeFromSuperview()
        if let vc =  (self.getParentViewController()?.parent as? JobHomeVC){
            vc.isScrollEnabled = true
        }
        self.getParentViewController()?.tabBarController?.tabBar.isHidden = false
    }
    
    
    
}

extension DropInternCondtionView{
    
    @objc internal func clear(){
       
        keys.forEach{
            conditions[$0] = defaultChoose
        }
        
        self.collectionView.reloadData()
        
    }
    
    @objc fileprivate func done(){
        conditions.keys.forEach { [unowned self]    (k) in
            if let m = transforKey[k]{
                 self.conditions[m] = self.conditions[k]
                 self.conditions.removeValue(forKey: k)
            }
           
        }
        self.passData?(conditions)
        self.hideMenu()
        
    }
    
    @objc private func hidden(){
        self.backGroundBtn.removeFromSuperview()
        self.hideMenu()
    }
}

extension DropInternCondtionView{
    private func loadData(){
        if SingletoneClass.shared.selectedInternCondition.isEmpty{
            // TODO
            return
        }
        datas =  SingletoneClass.shared.selectedInternCondition
        
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
            cell.Selected = (conditions[keys[indexPath.section]]?.contains(name) ?? false) ? true : false
             //
//            if (conditions[keys[indexPath.section]]?.contains(name))!{
//                cell.name.textColor = UIColor.blue
//                cell.name.layer.borderColor = UIColor.blue.cgColor
//
//            }else{
//
//                cell.name.textColor = UIColor.black
//                cell.name.layer.borderColor = UIColor.clear.cgColor
//
//            }
            return cell
            
        }
       
        return UICollectionViewCell()
    }

   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionLabelHeaderView.identity(), for: indexPath) as! CollectionLabelHeaderView
            header.titleLabel.text = keys[indexPath.section]
            header.titleLabel.font = UIFont.systemFont(ofSize: 16)
            
            return header
        }
        
        return UICollectionReusableView.init()
        
    }
    // section size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: GlobalConfig.ScreenW, height: 45)
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        let cell =  collectionView.cellForItem(at: indexPath) as! CollectionTextCell
        guard let name = cell.name.text else {return}
        // 每个section只有一个被选中
        conditions[keys[indexPath.section]] = name
        collectionView.reloadSections([indexPath.section], animationStyle: .none)
        //collectionView.reloadData()
    }
}


