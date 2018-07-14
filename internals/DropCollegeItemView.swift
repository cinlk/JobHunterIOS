//
//  DropCollegeItemView.swift
//  internals
//
//  Created by ke.liang on 2018/4/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu

fileprivate let maxCount:Int = 5
fileprivate let addressPre:String = "当前地区: "
fileprivate let spaceWidth:CGFloat = 25


class DropCollegeItemView: YNDropDownView {

    
    
    // 当前大学
    private var datas:[String:[String]] = [:]{
        didSet{
            datas.keys.reversed().forEach{
                selected[$0] = []
            }
        }
    }
    
    // MARK app 定位到具体的省 或 直辖市
    private var currentCity:String = "北京"
    
    
    private lazy var addrese:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 100)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    
    private lazy var topAddressView:UIView = { [unowned self] in
        
        
        let top = UIView()
        top.backgroundColor = UIColor.white
        top.isUserInteractionEnabled = true
        
        let downArrow = UIImageView()
        downArrow.contentMode = .scaleAspectFit
        downArrow.image = #imageLiteral(resourceName: "arrow_nor").withRenderingMode(.alwaysTemplate)
        downArrow.clipsToBounds = true
        
        // 选择地区
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        
        
        gesture.addTarget(self, action: #selector(chooseArea(_ :)))
        
        top.addGestureRecognizer(gesture)
        
        top.addSubview(downArrow)
        _ = downArrow.sd_layout().rightSpaceToView(top,10)?.centerYEqualToView(top)?.widthIs(15)?.heightIs(15)
        
        let addressIcon = UIImageView()
        addressIcon.image = #imageLiteral(resourceName: "locate").withRenderingMode(.alwaysTemplate)
        addressIcon.clipsToBounds = true
        addressIcon.contentMode = .scaleAspectFit
        top.addSubview(addressIcon)
        _ = addressIcon.sd_layout().leftSpaceToView(top,10)?.centerYEqualToView(top)?.widthIs(20)?.heightIs(15)
        
        
        top.addSubview(addrese)
        _ = addrese.sd_layout().leftSpaceToView(addressIcon,5)?.centerYEqualToView(addressIcon)?.autoHeightRatio(0)
        
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
        col.contentInset = UIEdgeInsetsMake(5, 10, 45, 10)
        col.delegate = self
        col.dataSource = self
        col.allowsMultipleSelection = false
        col.backgroundColor = UIColor.white
        col.showsVerticalScrollIndicator = false
        col.showsHorizontalScrollIndicator = false
        col.register(CollectionTextCell.self, forCellWithReuseIdentifier: CollectionTextCell.identity())
        return col
        
    }()
    
    // 地区collectionView
    private lazy var areaView:AreaCollectionView = { [unowned self] in
        
        let v = AreaCollectionView.init(frame: CGRect.init(x: 0, y: 40, width: ScreenW, height: 0))
        
        v.autoresizesSubviews = false

        v.selectedCity = { city in
            self.reloadCitys(name: city)
        }
        
        //v.isHidden = true
        
        return v
    }()
    
    
    private lazy var isOpenAreaView:Bool = false
    
    
    private lazy var clearAll:UIButton = {
        let clear = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: (ScreenW - spaceWidth - 10)/2, height: 35))
        clear.setTitle("清空", for: .normal)
        clear.setTitleColor(UIColor.black, for: .normal)
        clear.backgroundColor = UIColor.white
        clear.layer.borderWidth = 1
        clear.layer.borderColor = UIColor.black.cgColor
        clear.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        return clear
    }()
    
    private lazy var confirm:UIButton = {
        let confirm = UIButton.init(frame: CGRect.init(x: 0, y: 0, width:  (ScreenW - spaceWidth - 10)/2, height: 35))
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
    
    
    
    // 记录当前选择的大学集合
    private var selected:[String:[String]] = [:]
    
    var passData: ((_ colleges:[String]) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(topAddressView)
        self.addSubview(collection)
        self.addSubview(toolBar)
        
        self.addSubview(areaView)
        
        
        addrese.text = addressPre + currentCity
        _ = toolBar.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(40)
        _ = topAddressView.sd_layout().topEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(40)
        
        _ = collection.sd_layout().topSpaceToView(topAddressView,0)?.rightEqualToView(self)?.leftEqualToView(self)?.heightIs(self.frame.height - topAddressView.frame.height)
        
        
        
        //
 
        
        
        
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


extension DropCollegeItemView{
    private func loadData(){
        var bj:[String] = []
        for i in 0..<15{
            bj.append("北京大学\(i)")
        }
        
        var cd:[String] = []
        for i in 0..<15{
            cd.append("成都大学\(i)")
        }
        let randSeed:[String] = ["北京","测试","大青蛙","当前为多","当前为多","成都","北京1","测试1","大青蛙1","当前为多1","当前为多1","成都1","北京2","测试2","大青蛙2","当前为多2","当前为多2","成都2","北京2","测试2","大青蛙2","当前为多2","当前为多2","成都2","北京3","测试3","大青蛙3","当前为多3","当前为多3","成都3","北京3","测试3","大青蛙3","当前为多3","当前为多3","成都3"]
        for i in 0..<randSeed.count{
            datas[randSeed[i]] =  i%2 == 0 ? cd : bj
        }
        // 设置城市
        areaView.datas = Array(datas.keys)
        //datas = ["北京":bj,"测试":bj,"大青蛙":cd,"当前为多":cd,"当前为多":bj,"成都":cd]
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
    
    @objc private func hidden(){
        backGroundBtn.removeFromSuperview()
        self.hideMenu()
    }
}


// 展开地区
extension DropCollegeItemView{
    @objc private func chooseArea(_ gest: UITapGestureRecognizer){
        //self.areaView

        // 收藏
        if isOpenAreaView {
            
            self.areaView.frame = CGRect.init(x: 0, y: 40, width: ScreenW, height: 1)
            
            //UIView.transition(with: <#T##UIView#>, duration: <#T##TimeInterval#>, options: <#T##UIViewAnimationOptions#>, animations: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
            UIView.animate(withDuration: 5, animations: {
                //self.areaView.isHidden = true
                self.areaView.layoutIfNeeded()

            })
            
        }else{
            // 展开
            self.areaView.frame = CGRect.init(x: 0, y: 40, width: ScreenW, height: self.bounds.height - 40)
            
            UIView.animate(withDuration: 5, animations: {
               self.areaView.layoutIfNeeded()
                //self.areaView.isHidden = false

            })
        }
    
        isOpenAreaView = !isOpenAreaView
       
    }
}

extension DropCollegeItemView{
    private func reloadCitys(name:String){
        currentCity = name
        
        
        self.collection.reloadData()

        UIView.animate(withDuration: 0.5, animations: {
           //self.areaView.isHidden = true
        }, completion: { bool in
            
            self.addrese.text = addressPre + name
        })
        
        isOpenAreaView = false
        
    }
}

extension DropCollegeItemView: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas[currentCity]?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionTextCell.identity(), for: indexPath) as! CollectionTextCell
        
        
        guard  selected[currentCity] != nil else {
            return UICollectionViewCell()
        }
        
        cell.name.text = datas[currentCity]?[indexPath.row]
        
        // 默认选择全部大学
        if selected[currentCity]!.isEmpty{
            selected[currentCity]!.append(datas[currentCity]![0])
        
        }
        
        
        if selected[currentCity]!.contains(datas[currentCity]![indexPath.row]){
            // 被选中状态
            cell.name.textColor = UIColor.blue
            cell.name.layer.borderColor = UIColor.blue.cgColor
            
        }else{
            cell.name.textColor = UIColor.black
            cell.name.layer.borderColor = UIColor.clear.cgColor
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard  selected[currentCity] != nil else {
            return
        }
        if  let cell = collectionView.cellForItem(at: indexPath) as? CollectionTextCell, let name = cell.name.text{
            // 全选
            if indexPath.row == 0 {
                selected[currentCity]!.removeAll()
                selected[currentCity]!.append(name)
                collectionView.reloadData()
                return
            }
            
            // 去掉全部选择的cell
            if selected[currentCity]!.contains(datas[currentCity]![0]){
                selected[currentCity]!.remove(at: 0)               
            }
            
            
            
            if selected[currentCity]!.contains(name){
                // 取消选择状态
                selected[currentCity]!.remove(at: selected[currentCity]!.index(of: name)!)
                
            }else{
                if selected[currentCity]!.count >= maxCount{
                    print("不能超过5个")
                    return
                }
                selected[currentCity]!.append(name)
            }
            
            
             collectionView.reloadData()
            
            
        }
    }
    
}
