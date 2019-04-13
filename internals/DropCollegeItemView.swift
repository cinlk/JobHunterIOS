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
fileprivate let topAddressHeight:CGFloat = 40
fileprivate let bottomBarHeight:CGFloat = 40
fileprivate let spaceWidth:CGFloat = 25
fileprivate let defaulAllCollege:String = "不限"

// 顶部地址view
fileprivate class topAddress:UIView{
    
    
    private weak var pview:DropCollegeItemView?
    
    private lazy var downArrow:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.contentMode = .scaleAspectFit
        img.image = #imageLiteral(resourceName: "arrow_xl").withRenderingMode(.alwaysTemplate)
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var addressIcon:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        img.image = #imageLiteral(resourceName: "nearby").withRenderingMode(.alwaysOriginal)
        return img
    }()
    
    private  lazy var tap:UITapGestureRecognizer = {
        let t = UITapGestureRecognizer.init()
        return t
    }()
    
    private var address:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 100)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    
    convenience init(frame:CGRect, v:DropCollegeItemView?){
        self.init(frame: frame)
        self.pview = v
        self.tap.addTarget(self.pview!, action: #selector(self.pview!.chooseArea(_:)))

        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(self.tap)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let views:[UIView] = [downArrow, line, address, addressIcon]
        self.sd_addSubviews(views)
        _ = self.downArrow.sd_layout()?.rightSpaceToView(self, 10)?.centerYEqualToView(self)?.widthIs(15)?.heightEqualToWidth()
        _ = self.addressIcon.sd_layout()?.leftSpaceToView(self, 10)?.centerYEqualToView(self)?.widthIs(20)?.heightEqualToWidth()
        _ = self.address.sd_layout()?.leftSpaceToView(addressIcon, 5)?.centerYEqualToView(addressIcon)?.autoHeightRatio(0)
        _ = self.line.sd_layout()?.bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(1)
        
    }
    
    
    internal func setText(text:String){
        self.address.text = text
    }
}



fileprivate class bottomToolBar:UIToolbar{
    
    
    private lazy var clearAll:UIButton = {  [unowned self] in
    
        let clear = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: (GlobalConfig.ScreenW - spaceWidth - 10)/2, height: 35))
        clear.setTitle("清空", for: .normal)
        clear.setTitleColor(UIColor.black, for: .normal)
        clear.backgroundColor = UIColor.white
        clear.layer.borderWidth = 1
        clear.layer.borderColor = UIColor.black.cgColor
        clear.addTarget(self.pview!, action: #selector(self.pview!.reset), for: .touchUpInside)
        return clear
        
    }()
    
    private lazy var confirm:UIButton = {  [unowned self]  in
        let confirm = UIButton.init(frame: CGRect.init(x: 0, y: 0, width:  (GlobalConfig.ScreenW - spaceWidth - 10)/2, height: 35))
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
    
    
    
    private weak var pview:DropCollegeItemView?
    
    
    convenience init(frame:CGRect, view:DropCollegeItemView){
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



class DropCollegeItemView: YNDropDownView {

    
    
    private lazy var topAddressView:topAddress = {  [unowned self]  in
        let t = topAddress.init(frame: CGRect.zero, v: self)
        return t
    }()
    
    private lazy var flowLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        // 每行2个元素
        layout.itemSize = CGSize.init(width: (GlobalConfig.ScreenW - 60)/2 , height: 40)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        // 不开启悬停
        layout.sectionHeadersPinToVisibleBounds = false
        
        return layout
    }()
    
    
    
    private lazy var collection:UICollectionView = {  [unowned self]  in
        
        let col = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        col.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 45, right: 10)
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
        
        let v = AreaCollectionView.init(frame: CGRect.init(x: 0, y: topAddressHeight, width: GlobalConfig.ScreenW, height: 0))
        
        v.autoresizesSubviews = false

        v.selectedCity = { city in
            self.reloadCitys(name: city)
        }
        return v
    }()
    
    
    // 加入toolbar
    private lazy var toolBar:bottomToolBar = {  [unowned self]  in
        let bar = bottomToolBar.init(frame: CGRect.zero, view: self)
        return bar
    }()
    
    
    // 全局的 透明背景view
    internal lazy var backGroundBtn:UIButton = {  [unowned self]  in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 0))
        btn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1
        return btn
    }()
    
    private lazy var isOpenAreaView:Bool = false
    
    
    // 当前大学
    private var datas:[String:[String]] = [:]{
        didSet{
            
            // 默认城市n类所有大学
            datas.keys.reversed().forEach{ [unowned self]  in
                selected[$0] = [defaulAllCollege]
                //datas[$0]?.insert(defaulAllCollege, at: 0)
            }
            self.topAddressView.setText(text: addressPre + currentCity)
            self.collection.reloadData()
        }
    }
    
    // TODO  定位到具体的省 或 直辖市 逻辑
    private var currentCity:String = "北京"
    
    // 记录当前选择的城市的大学集合
    private var selected:[String:[String]] = [:]
    
    var passData: ((_ colleges:[String:[String]]) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(topAddressView)
        self.addSubview(collection)
        self.addSubview(toolBar)
        self.addSubview(areaView)
        
        //addrese.text = addressPre + currentCity
        
        _ = toolBar.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(bottomBarHeight)
        _ = topAddressView.sd_layout().topEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(topAddressHeight)
        
        _ = collection.sd_layout().topSpaceToView(topAddressView,0)?.rightEqualToView(self)?.leftEqualToView(self)?.heightIs(self.frame.height - topAddressView.frame.height)
        
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


extension DropCollegeItemView{
    private func loadData(){

        if SingletoneClass.shared.selectedcityCollege.isEmpty{
            // TODO
            return
        }
        // 加入不限到每个城市
        var tmp = SingletoneClass.shared.selectedcityCollege
        tmp.keys.forEach { (k) in
            tmp[k]?.insert(defaulAllCollege, at: 0)
        }
        self.datas = tmp
        self.currentCity = tmp.keys.first ?? ""
        // 设置城市
        areaView.datas = Array(datas.keys)
        //datas = ["北京":bj,"测试":bj,"大青蛙":cd,"当前为多":cd,"当前为多":bj,"成都":cd]
    }
}

extension DropCollegeItemView{
    
    @objc internal func reset(){
        selected.keys.forEach {  [unowned self]  (k) in
            self.selected[k] = [defaulAllCollege]
        }
//        selected[currentCity]!.removeAll()
//        selected[currentCity]! = [defaulAllCollege]
        self.collection.reloadData()
        
    }
    
    @objc internal func done(){
        
        
        self.passData?([currentCity: selected[currentCity] ?? []])
        self.hideMenu()
        
    }
    
    @objc private func hidden(){
        backGroundBtn.removeFromSuperview()
        self.hideMenu()
    }
}


// 展开地区
extension DropCollegeItemView{
    
    private func changeAreaView(frame:CGRect, complete:  (()->Void)?){
        self.areaView.frame = frame
        UIView.animate(withDuration: 0.3) {
            self.areaView.layoutIfNeeded()
            complete?()
        }
    }
    
    
    @objc internal func chooseArea(_ gest: UITapGestureRecognizer){
        //self.areaView

        isOpenAreaView ? self.changeAreaView(frame: CGRect.init(x: 0, y: topAddressHeight, width: GlobalConfig.ScreenW, height: 1), complete: nil) : self.changeAreaView(frame: CGRect.init(x: 0, y: topAddressHeight, width: GlobalConfig.ScreenW, height: self.bounds.height - topAddressHeight), complete: nil)
        
         isOpenAreaView = !isOpenAreaView
    
       
    }
}

extension DropCollegeItemView{
    
    private func reloadCitys(name:String){
        
        currentCity = name
        self.collection.reloadData()

        self.changeAreaView(frame: CGRect.init(x: 0, y: topAddressHeight, width: GlobalConfig.ScreenW, height: 1), complete: { [weak self] in
            self?.topAddressView.setText(text: addressPre + name)
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
//        if selected[currentCity]!.isEmpty{
//            selected[currentCity]!.append(datas[currentCity]![0])
//
//        }
//
        
        cell.Selected = selected[currentCity]!.contains(datas[currentCity]![indexPath.row]) ? true : false
//        if selected[currentCity]!.contains(datas[currentCity]![indexPath.row]){
//            // 被选中状态
//            cell.name.textColor = UIColor.blue
//            cell.name.layer.borderColor = UIColor.blue.cgColor
//
//        }else{
//            cell.name.textColor = UIColor.black
//            cell.name.layer.borderColor = UIColor.clear.cgColor
//        }
//
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard  selected[currentCity] != nil else {
            return
        }
        
        if  let cell = collectionView.cellForItem(at: indexPath) as? CollectionTextCell, let name = cell.name.text{
            
            // 默认全选
            if name == defaulAllCollege {
                selected[currentCity]!.removeAll()
                selected[currentCity]! = [defaulAllCollege]
                collectionView.reloadData()
                return
            }
            
            // 先去掉全部选择的cell
            if (selected[currentCity]?.contains(datas[currentCity]?[0] ?? "") ?? false), let i = selected[currentCity]?.firstIndex(of: defaulAllCollege) {
                selected[currentCity]?.remove(at: i)
                
            }
        
            
            if selected[currentCity]!.contains(name){
                // 取消选择状态
                selected[currentCity]!.remove(at: selected[currentCity]!.firstIndex(of: name)!)
                
            }else{
                if selected[currentCity]!.count >= maxCount{
                    self.showToast(title: "不能超过5个", customImage: nil, mode: .text)
                    return
                }
                selected[currentCity]!.append(name)
            }
            
            
             collectionView.reloadData()
            
            
        }
    }
    
}
