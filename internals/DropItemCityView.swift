//
//  DropItemCityView.swift
//  internals
//
//  Created by ke.liang on 2018/4/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu


fileprivate let column:Int = 3
fileprivate let maxCount:Int = 5
fileprivate let spaceWidth:CGFloat = 25
fileprivate let defaultSelecName:String = "全国"

class DropItemCityView: YNDropDownView {

    
    // test Data
    
    private  var citys:[String:[String]] = [:]{
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
    
    
    // 回调
    var passData: ((_ citys:[String]?) -> Void)?

    
    private lazy var flowLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: (ScreenW - 50)/3 , height: 40)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        // 不开启悬停
        layout.sectionHeadersPinToVisibleBounds = false
        
        return layout
    }()
    
    private lazy var collection:UICollectionView = { [unowned self] in
        let col = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        col.contentInset = UIEdgeInsetsMake(0, 10, 45, 10)
        col.delegate = self
        col.dataSource = self
        col.allowsMultipleSelection = false
        col.backgroundColor = UIColor.white
        col.showsHorizontalScrollIndicator = false
        col.register(CollectionLabelHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CollectionLabelHeaderView.identity())
        col.register(CollectionTextCell.self, forCellWithReuseIdentifier: CollectionTextCell.identity())
        return col
    }()
    
    private lazy var clearAll:UIButton = {
        let clear = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: (ScreenW - spaceWidth - 10)/2 , height: 35))
        clear.setTitle("清空", for: .normal)
        clear.setTitleColor(UIColor.black, for: .normal)
        clear.backgroundColor = UIColor.white
        clear.layer.borderWidth = 1
        clear.layer.borderColor = UIColor.black.cgColor
        clear.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        return clear
    }()
    
    private lazy var confirm:UIButton = {
        let confirm = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: (ScreenW - spaceWidth - 10)/2 , height: 35))
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
    
    // 全局的 透明背景view
    internal lazy var backGroundBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 0))
        btn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1
    
        return btn
    }()
    
    
    private lazy var selected:[String] = []
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(collection)
        self.addSubview(toolBar)
        
        _ = toolBar.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(40)
        _ = collection.sd_layout().topEqualToView(self)?.rightEqualToView(self)?.leftEqualToView(self)?.heightIs(self.frame.height)
        
        let space = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = spaceWidth
        toolBar.items?.append(contentsOf: [UIBarButtonItem.init(customView: clearAll),space, UIBarButtonItem.init(customView: confirm)])
        
        
        loadData()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    // 显示 和 关闭 view
    override func dropDownViewOpened() {
        
        UIApplication.shared.keyWindow?.addSubview(backGroundBtn)
        self.getParentViewController()?.tabBarController?.tabBar.isHidden = true
    }
    
    override func dropDownViewClosed() {
        
        backGroundBtn.removeFromSuperview()
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
       citys = ["GHIJ": ["桂林", "广州", "合肥", "呼和浩特", "海口", "杭州", "湖州", "济南", "济宁", "嘉兴", "江阴"], "热门城市": ["全国", "西安", "深圳", "武汉", "长沙", "苏州", "南京", "上海", "成都", "广州", "杭州", "北京"], "ABCDEF": ["鞍山", "安阳", "保定", "北京", "成都", "重庆", "长沙", "常州", "大连", "东营", "德州", "佛山", "福州"], "KLMN": ["特别长特别长特比长", "昆明", "昆山", "聊城", "廊坊", "洛阳", "连云港", "兰州", "绵阳", "宁波", "南京", "南宁", "南通"]]
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
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CollectionLabelHeaderView.identity(), for: indexPath) as? CollectionLabelHeaderView{
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
        
        if selected.contains(name){
            // 已经被选中状态
            cell.name.textColor = UIColor.blue
            cell.name.layer.borderColor = UIColor.blue.cgColor
            
        }else{
            cell.name.textColor = UIColor.black
            cell.name.layer.borderColor = UIColor.clear.cgColor
        }
        
        return cell
    }
    
    // 多选
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionTextCell
        guard let text = cell.name.text else {
            return
        }
        
        
        // 全国 则取消其他选择
        if text == "全国"{
            selected.removeAll()
            selected.append(text)
            collectionView.reloadData()
            return
        }
        if selected.contains("全国"){
            selected.remove(at: selected.index(of: "全国")!)
            let cell = collectionView.cellForItem(at: IndexPath.init(row: 0, section: 0)) as! CollectionTextCell
            cell.name.textColor = UIColor.black
            cell.name.layer.borderColor = UIColor.clear.cgColor
            
        }
        
        if selected.contains(text){
            // 取消选择状态
            selected.remove(at: selected.index(of: text)!)
            cell.name.textColor = UIColor.black
            cell.name.layer.borderColor = UIColor.clear.cgColor
           
        }else{
            //
            if selected.count >= maxCount{
                print("不能超过5个")
                return
            }
            selected.append(text)
            cell.name.textColor = UIColor.blue
            cell.name.layer.borderColor = UIColor.blue.cgColor
        }
        
        
    }
    
    
}




extension DropItemCityView{
    @objc private func clear(_ btn:UIButton){
        selected.removeAll()
        selected.append(defaultSelecName)
        self.collection.reloadData()
        
    }
    
    @objc private func done(_ btn:UIButton){
        
        self.passData?(selected)
        self.hideMenu()
        
    }
}


 
