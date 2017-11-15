//
//  CitysView.swift
//  internals
//
//  Created by ke.liang on 2017/8/31.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu

protocol switchCity {
    func cityforsearch(city:String)
}


class CityViewController:UIViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择城市"
        let city = CitysView(frame: self.view.frame)
        self.view.addSubview(city)
        
    }
}


class CitysView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    var currentCity:String!
    
    var CityCollection:UICollectionView!
    
    
    // protocal delegate
    var switchDelgate: switchCity?
    
    
    
    // mydata
    var dataSource:Dictionary<String,[String]> = ["定位":["北京"],"热门城市":["上海","成都","广州","重庆","苏州","城市1","城市1"
        ,"城市1","城市1","城市1","城市1","城市1","城市1"],"ABCD":["常德","北湖","城市1","城市1","城市1","城市1","城市1"]]
    
    var indexs = ["定位","热门城市","ABCD"]
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.buildCollection()
        
        // Do any additional setup after loading the view.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func buildCollection(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10)
        
        layout.itemSize = CGSize(width: 30, height: 20)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        // layout.headerReferenceSize = CGSize(width: 0, height: 0)
        // layout.footerReferenceSize = CGSize(width: 0, height: 0)
        
        
        
        
        CityCollection = UICollectionView.init(frame: self.frame, collectionViewLayout: layout)
        
        
        
        CityCollection.delegate = self
        CityCollection.backgroundColor  = UIColor.white
        CityCollection.dataSource  = self
        
        CityCollection.register(myitem.self, forCellWithReuseIdentifier: "single")
        CityCollection.register(headerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headeview")
        CityCollection.register(footerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footview")
        CityCollection.isScrollEnabled = true
        CityCollection.isMultipleTouchEnabled =  false
        CityCollection.contentInset  = UIEdgeInsetsMake(0, 0, 100, 0)
        CityCollection.contentSize =  CGSize(width: self.frame.width, height: self.frame.height)
        self.addSubview(CityCollection)
        
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  dataSource.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionArray:NSArray = dataSource[indexs[section]]! as NSArray
        return sectionArray.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "single", for: indexPath) as! myitem
        
        cell.name.addTarget(self, action: #selector(click(button:)), for: .touchUpInside)
        
        let sectionArray:NSArray = dataSource[indexs[indexPath.section]]! as NSArray
        
        let content = sectionArray.object(at: indexPath.row) as! String
        cell.name.setTitle(content, for: .normal)
        return cell
        
        
        
        
    }
    
    // choose city
    @objc func click(button:UIButton){
        let city = button.titleLabel?.text
        self.switchDelgate?.cityforsearch(city: city!)
        
        if  let parentView = self.superview as? YNDropDownView{
            parentView.hideMenu()
            parentView.changeMenu(title: city!, at: 0)
            
        }
        else{
                
            self.viewController(aClass: CityViewController.self)?.navigationController?.popViewController(animated: true)
            let dash = self.viewController(aClass: CityViewController.self)?.navigationController?.topViewController as! DashboardViewController
            dash.dashLocateCity = city!
            
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    // 更新visible cell
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //CityCollection. .append(collectionView.cellForItem(at: indexPath))
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        
        //CityCollection.visibleCells.remove(at: index)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headeview", for: indexPath) as! headerView
            header.name.text = indexs[indexPath.section]
            return header
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footview", for: indexPath)
        return footer
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //
    //        return  UIEdgeInsetsMake(0, 0, 0, 0)
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width,height:35)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath)
        let sectionArray:NSArray = dataSource[indexs[indexPath.section]]! as NSArray
        
        let content = sectionArray.object(at: indexPath.row) as! String
        
        
        print(content)
    }
    
    //    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    //
    //        print("hit")
    //        //loop through the cells, get each cell, and run this test on each cell
    //        //you need to define a proper loop
    //        // 当前可见的cell, 点击point点，scroll下拉后 似乎不包括point（bug？）
    //
    //
    //        for cell in self.CityCollection.visibleCells {
    //                //get the cells button
    //
    //                        return cell
    //        }
    //
    //        //after the loop, if it could not find the touch in one of the cells return the view you are on
    //        return CityCollection
    //
    //    }
    
    
    
    
    
    
}



class MyCityCell:UICollectionViewCell{
    
    lazy var age:UILabel = {
        let age = UILabel.init()
        age.textColor = UIColor.black
        age.textAlignment = .center
        age.backgroundColor = UIColor.white
        age.adjustsFontSizeToFitWidth  = true
        return age
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(age)
        _ = age.sd_layout().topEqualToView(self)?.widthIs(60)?.heightIs(30)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class footerView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class headerView: UICollectionReusableView {
    
    lazy var name:UILabel = {
        let name = UILabel.init()//2098
        name.translatesAutoresizingMaskIntoConstraints = false
        name.backgroundColor = UIColor.gray//
        name.textAlignment = .left
        name.textColor = UIColor.white
        
        return name
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(name)
        _ = name.sd_layout().topSpaceToView(self,1)?.widthIs(self.frame.width)?.heightIs(20)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class singleCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(age)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:  "H:|-[age]-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["age":age]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[age]-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["age" : age ]))
    }
    
    lazy var age: UILabel = {
        let age = UILabel.init()
        age.translatesAutoresizingMaskIntoConstraints = false
        age.backgroundColor = UIColor.blue
        age.textAlignment = .center
        age.textColor = UIColor.white
        age.text = "0"
        return age
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

