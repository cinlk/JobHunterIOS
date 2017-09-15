//
//  CitysView.swift
//  internals
//
//  Created by ke.liang on 2017/8/31.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class CitysView: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    var currentCity:String!
    
    var CityCollection:UICollectionView!
    
    var source = [Int]()
    
    // mydata
    var dataSource:Dictionary<String,[String]> = ["定位":["北京"],"热门城市":["上海","成都","广州","重庆","苏州","城市1","城市1"
        ,"城市1","城市1","城市1","城市1","城市1","城市1"],"ABCD":["常德","北湖","城市1","城市1","城市1","城市1","城市1"]]
    
    var indexs = [0:"定位",1:"热门城市",2:"ABCD"]
    
    
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = true
        
        for i in 1...100 {
                source.append(i)
        }

        self.buildCollection()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title  = "Citys"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func buildCollection(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: 60, height: 30)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        
        
        
        CityCollection = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        CityCollection.delegate = self
        CityCollection.backgroundColor  = UIColor.white
        CityCollection.dataSource  = self
        CityCollection.register(MyCityCell.self, forCellWithReuseIdentifier: "single")
        CityCollection.register(headerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headeview")
        CityCollection.register(footerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footview")

        
        
        self.view.addSubview(CityCollection)
        
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return  dataSource.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionArray:NSArray = dataSource[indexs[section]!]! as NSArray
        return sectionArray.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "single", for: indexPath) as! MyCityCell
        
        
        let sectionArray:NSArray = dataSource[indexs[indexPath.section]!]! as NSArray
        
        let content = sectionArray.object(at: indexPath.row) as! String
        print(content)
        cell.age.text = content
        return cell
        

        
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return  UIEdgeInsetsMake(0, 0, 0, 0)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 60, height: 30)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width,height:35)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        print("\(indexPath.section) \(indexPath.row)")
        
        
        let sectionArray:NSArray = dataSource[indexs[indexPath.section]!]! as NSArray
        
        let content = sectionArray.object(at: indexPath.row) as! String

       
        self.currentCity = content
        self.navigationController?.popViewController(animated: true)
        let  view:DashboardViewController = self.navigationController?.topViewController as! DashboardViewController
        view.locatecity = content

    }

    
    
    
   
}



class MyCityCell:UICollectionViewCell{
    
    lazy var age:UILabel = {
        let age = UILabel.init()
        age.textColor = UIColor.black
        age.textAlignment = .center
        age.backgroundColor = UIColor.white
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

