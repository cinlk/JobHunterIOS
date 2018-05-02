//
//  DropCollegeItemView.swift
//  internals
//
//  Created by ke.liang on 2018/4/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu

class DropCollegeItemView: YNDropDownView {

    
    
    // 当前大学
    private var datas:[String:[String]] = [:]{
        didSet{
            datas.keys.reversed().forEach{
                selected[$0] = []
            }
        }
    }
    
    private var currentCity:String = "北京"
    
    
    private lazy var addrese:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(200)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var topAddressView:UIView = { [unowned self] in
        let top = UIView()
        top.backgroundColor = UIColor.white
        
        
        
        let downArrow = UIImageView()
        downArrow.isUserInteractionEnabled = true
        downArrow.image = #imageLiteral(resourceName: "arrow_nor")
        downArrow.clipsToBounds = true
        // 选择地区
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        
        
        gesture.addTarget(self, action: #selector(chooseArea(_ :)))
        
        downArrow.addGestureRecognizer(gesture)
        
        top.addSubview(downArrow)
        _ = downArrow.sd_layout().rightSpaceToView(top,10)?.centerYEqualToView(top)?.widthIs(20)?.heightRatioToView(top,0.5)
        let addressIcon = UIImageView()
        addressIcon.image = #imageLiteral(resourceName: "locate")
        top.addSubview(addressIcon)
        _ = addressIcon.sd_layout().leftSpaceToView(top,10)?.centerYEqualToView(top)?.widthIs(20)?.heightRatioToView(top,0.5)
        
        top.addSubview(addrese)
        _ = addrese.sd_layout().leftSpaceToView(addressIcon,5)?.topEqualToView(addressIcon)?.bottomEqualToView(addressIcon)
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        top.addSubview(line)
        _ = line.sd_layout().bottomEqualToView(top)?.leftEqualToView(top)?.rightEqualToView(top)?.heightIs(1)
        
        return top
    }()
    
    private lazy var flowLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: (ScreenW - 60)/2 , height: 40)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        // 不开启悬停
        layout.sectionHeadersPinToVisibleBounds = false
        
        return layout
    }()
    
    
    
    private lazy var collection:UICollectionView = {
        
        let col = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        col.contentInset = UIEdgeInsetsMake(0, 10, 45, 10)
        col.delegate = self
        col.dataSource = self
        
        col.allowsMultipleSelection = false
        col.backgroundColor = UIColor.white
        col.showsHorizontalScrollIndicator = false
        col.register(CollectionTextCell.self, forCellWithReuseIdentifier: CollectionTextCell.identity())
        return col
        
    }()
    
    // 地区collectionView
    private lazy var areaView:AreaCollectionView = { [unowned self] in
        
        let v = AreaCollectionView.init(frame: CGRect.zero)
        v.selectedCity = { city in
            self.reloadCitys(name: city)
        }
        
        return v
    }()
    
    // 控制
    private lazy var isTouch:Bool = false
    
    
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
    
    private var selected:[String:[String]] = [:]
    
    var passData: ((_ colleges:[String]) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(topAddressView)
        self.addSubview(collection)
        self.addSubview(toolBar)
        self.addSubview(areaView)
        
        
        addrese.text = "当前地区:" + currentCity
        _ = toolBar.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(44)
        _ = topAddressView.sd_layout().topEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(50)
        
        _ = collection.sd_layout().topSpaceToView(topAddressView,10)?.rightEqualToView(self)?.leftEqualToView(self)?.heightIs(self.frame.height - topAddressView.frame.height)
        
        
        _ = areaView.sd_layout().topSpaceToView(topAddressView,0)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(0)
        
        
        //areaView
        
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


extension DropCollegeItemView{
    private func loadData(){
        datas = ["北京":["北京所有大学", "北京大学1", "北京大学2","北京大学3","北京大学4","北京大学5"],
                 "成都":["成都所有大学","成都大学1","成都大学2","成都大学3"]]
    }
}

extension DropCollegeItemView{
    @objc private func clear(_ btn:UIButton){
        selected[currentCity]!.removeAll()
        self.collection.reloadData()
        
    }
    
    @objc private func done(_ btn:UIButton){
        
        self.passData?(selected[currentCity]!)
        self.hideMenu()
        
    }
}


// 展开地区
extension DropCollegeItemView{
    @objc private func chooseArea(_ gest: UITapGestureRecognizer){
        //self.areaView

        // 收藏
        if isTouch == true {
            
            UIView.animate(withDuration: 0.5, animations: {
                _ = self.areaView.sd_layout().heightIs(0)
                
                self.layoutIfNeeded()
                
            }, completion: { _ in

            })
            

            
        }else{
            
            // 展开
            UIView.animate(withDuration: 0.5, animations: {
                
                _ = self.areaView.sd_layout().heightIs(self.bounds.height)
                self.layoutIfNeeded()

            },completion: { _ in
                
                
            })
            
        }
        isTouch = !isTouch
       
    }
}

extension DropCollegeItemView{
    private func reloadCitys(name:String){
        currentCity = name
        
        addrese.text = "当前地区:" + currentCity
        self.collection.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
            _ = self.areaView.sd_layout().heightIs(0)
            self.layoutIfNeeded()
            
        }, completion: { _ in
            
            
        })
        isTouch = false
        
    }
}

extension DropCollegeItemView: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas[currentCity]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionTextCell.identity(), for: indexPath) as! CollectionTextCell
        
        
        cell.name.text = datas[currentCity]?[indexPath.row]
        
        // 默认选择第一个 全部大学
        if selected[currentCity]!.isEmpty{
            selected[currentCity]!.append(datas[currentCity]![0])
        }
        
        if selected[currentCity]!.contains(datas[currentCity]![indexPath.row]){
            // 已经被选中状态
            cell.name.textColor = UIColor.blue
            cell.name.layer.borderColor = UIColor.blue.cgColor
            
        }else{
            cell.name.textColor = UIColor.black
            cell.name.layer.borderColor = UIColor.clear.cgColor
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  let cell = collectionView.cellForItem(at: indexPath) as? CollectionTextCell, let name = cell.name.text{
            if indexPath.row == 0 {
                selected[currentCity]!.removeAll()
                selected[currentCity]!.append(name)
                collectionView.reloadData()
                return
            }
            
            if selected[currentCity]!.contains(datas[currentCity]![0]){
                selected[currentCity]!.remove(at: selected[currentCity]!.index(of: datas[currentCity]![0])!)
                let cell = collectionView.cellForItem(at: IndexPath.init(row: 0, section: 0)) as! CollectionTextCell
                cell.name.textColor = UIColor.black
                cell.name.layer.borderColor = UIColor.clear.cgColor
            }
            
            
            if selected[currentCity]!.contains(name){
                // 取消选择状态
                selected[currentCity]!.remove(at: selected[currentCity]!.index(of: name)!)
                cell.name.textColor = UIColor.black
                cell.name.layer.borderColor = UIColor.clear.cgColor
                
            }else{
                selected[currentCity]!.append(name)
                cell.name.textColor = UIColor.blue
                cell.name.layer.borderColor = UIColor.blue.cgColor
            }
            
            
            
        }
    }
    
}
