//
//  DropItemCityView.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu



fileprivate let maxSelectedCount:Int = 5
fileprivate let spaceWidth:CGFloat = 25
fileprivate let defaultSelecName:String = "全国"

fileprivate class bottomToolBar:UIToolbar{
    
    
    private lazy var clearAll:UIButton = {
        let clear = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: (GlobalConfig.ScreenW - spaceWidth - 10)/2 , height: 35))
        clear.setTitle("清空", for: .normal)
        clear.setTitleColor(UIColor.black, for: .normal)
        clear.backgroundColor = UIColor.white
        clear.layer.borderWidth = 1
        clear.layer.borderColor = UIColor.black.cgColor
        clear.addTarget(self.pview!, action: #selector(self.pview!.clear), for: .touchUpInside)
        return clear
    }()
    
    private lazy var confirm:UIButton = {
        let confirm = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: (GlobalConfig.ScreenW - spaceWidth - 10)/2 , height: 35))
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
    
   
    
    private weak var pview:DropItemCityView?
    
    
    convenience init(frame:CGRect, view:DropItemCityView){
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




class DropItemCityView: YNDropDownView {

    
    // test Data
    
    private var citys:[String:[String]] = [:]{
        didSet{
            index = citys.keys.sorted()
            // 热门城市 插入第一位
            if let last = index.popLast(), last == "热门城市"{
                index.insert(last, at: 0)
            }
            // 默认选中全国
            selected.append(defaultSelecName)
            
        }
    }
    
    private var index:[String] = []
    private lazy var selected:[String] = []
    
    // 回调
    var passData: ((_ cities :[String]) -> Void)?

    
    private lazy var flowLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: (GlobalConfig.ScreenW - 50)/3 , height: 40)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        // 不开启悬停
        layout.sectionHeadersPinToVisibleBounds = false
        
        return layout
    }()
    
    private lazy var collection:UICollectionView = { [unowned self] in
        let col = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        col.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 45, right: 10)
        col.delegate = self
        col.dataSource = self
        col.allowsMultipleSelection = false
        col.backgroundColor = UIColor.white
        col.showsHorizontalScrollIndicator = false
        col.register(CollectionLabelHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionLabelHeaderView.identity())
        col.register(CollectionTextCell.self, forCellWithReuseIdentifier: CollectionTextCell.identity())
        return col
    }()
    
  
    // 加入toolbar
    private lazy var toolBar:bottomToolBar = {
        let bar = bottomToolBar.init(frame: CGRect.zero, view: self)
        return bar
        
    }()
    
    // 全局的 透明背景view
    internal lazy var backGroundBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 0))
        btn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1
    
        return btn
    }()
    
    

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(collection)
        self.addSubview(toolBar)
        
        _ = toolBar.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(40)
        _ = collection.sd_layout().topEqualToView(self)?.rightEqualToView(self)?.leftEqualToView(self)?.heightIs(self.frame.height)
        
        
        loadData()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    // 显示 和 关闭 view
    override func dropDownViewOpened() {
        
        UIApplication.shared.keyWindow?.addSubview(backGroundBtn)
        // 静止collectionview滑动
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


extension DropItemCityView{
    @objc private func hidden(){
        backGroundBtn.removeFromSuperview()
        self.hideMenu()
    }
}

extension DropItemCityView{
    private func loadData(){
        citys = SingletoneClass.shared.selectedCity
        if citys.isEmpty{
            // TODO 再次获取http
        }
        self.collection.reloadData()
    }
}

extension DropItemCityView:UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return index.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citys[index[section]]?.count ?? 0
        
    }
    
    // header section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width,height:45)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionLabelHeaderView.identity(), for: indexPath) as? CollectionLabelHeaderView{
            header.titleLabel.text = index[indexPath.section]
            return header
        }
        
        return UICollectionReusableView()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionTextCell.identity(), for: indexPath) as!  CollectionTextCell
       
        guard  let name = citys[index[indexPath.section]]?[indexPath.row] else {
            return cell
        }
        
        cell.name.text = name
        
        cell.Selected = selected.contains(name) ? true : false
//        if selected.contains(name){
//            // 已经被选中状态
//            cell.name.textColor = UIColor.blue
//            cell.name.layer.borderColor = UIColor.blue.cgColor
//
//        }else{
//            cell.name.textColor = UIColor.black
//            cell.name.layer.borderColor = UIColor.clear.cgColor
//        }
        
        return cell
    }
    
    // 多选
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionTextCell
        guard let text = cell.name.text else {
            return
        }
        
        
        // 全国 则取消其他选择
        if text == defaultSelecName{
            selected.removeAll()
            selected.append(text)
            collectionView.reloadData()
            return
        }
        if selected.contains(defaultSelecName){
            selected.remove(at: selected.index(of: defaultSelecName)!)
            let cell = collectionView.cellForItem(at: IndexPath.init(row: 0, section: 0)) as! CollectionTextCell
            //cell.name.textColor = UIColor.black
            //cell.name.layer.borderColor = UIColor.clear.cgColor
            cell.Selected = false
        }
        
        if selected.contains(text){
            // 取消选择状态
            selected.remove(at: selected.index(of: text)!)
            //cell.name.textColor = UIColor.black
            //cell.name.layer.borderColor = UIColor.clear.cgColor
            cell.Selected = false
        }else{
            //
            if selected.count >= maxSelectedCount{
                self.showToast(title: "不能超过\(maxSelectedCount)个", customImage: nil, mode: .customView)
                return
            }
            selected.append(text)
            //cell.name.textColor = UIColor.blue
            //cell.name.layer.borderColor = UIColor.blue.cgColor
            cell.Selected = true
        }
        
        
    }
    
    
}




extension DropItemCityView{
    @objc internal func clear(){
        selected.removeAll()
        selected.append(defaultSelecName)
        self.collection.reloadData()
        
    }
    
    @objc internal func done(){
        
        self.passData?(selected)
        self.hideMenu()
        
    }
}


 
