//
//  internCondition.swift
//  internals
//
//  Created by ke.liang on 2017/9/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu

protocol internSelection {
    func selected(days:Int, salary:String,month:Int,scholarship:String,staff:Bool)
}
// 实习条件




class internCondition: UIView,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    
    var condtions:UICollectionView!
    
    var confirmButton:UIButton!
    
    var selections: internSelection?
    
    
    var data = ["每周实习天数":["不限","1天","2天","3天","4天","5天","6天","7天"],
                "日薪(元)":["不限","50以下","50-100","100-150","150-200","200-300","300以上"],
                "实习月数":["不限","1月","2月","3月","4月","5月","5月及以上"],
                "学历":["不限","大专","本科","硕士","博士"],
                "是否转正":["提供转正","不提供转正"]]
    
    var indexs = ["每周实习天数","日薪(元)","实习月数","学历","是否转正"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView(){
        let layout = UICollectionViewFlowLayout()
        self.isUserInteractionEnabled = true
        //layout.itemSize = CGSize(width: 50, height: 20)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //layout.itemSize = CGSize(width: 50, height: 30)
        
        //condtions = UICollectionView(frame: CGRect(x:0,y:0,width:self.frame.width,height:self.frame.height), collectionViewLayout: layout)
        condtions = UICollectionView.init(frame: CGRect(x:0,y:0,width:self.frame.width,height:self.frame.height-100), collectionViewLayout: layout)
        //condtions.contentSize = CGSize(width: self.bounds.width, height: self.bounds.height*2)
        //condtions.setCollectionViewLayout(layout, animated: false)
        condtions.isScrollEnabled = true
        condtions.delegate = self
        condtions.backgroundColor  = UIColor.white
        condtions.dataSource = self
        condtions.allowsMultipleSelection = true
        condtions.register(myitem.self, forCellWithReuseIdentifier: "item")
        condtions.register(headerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headeview")
        condtions.register(footerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footview")
        
        //condtions.contentSize =   CGSize(width: self.frame.width, height: self.frame.height)
        // 当界面内容不超过界面大小时不会滑动,设置true强制滑动
        condtions.alwaysBounceVertical = true
        condtions.contentInset = UIEdgeInsetsMake(0, 10, 20, 10)
        
        //condtions.contentInset =  UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.addSubview(condtions)
        confirmButton = UIButton()
        confirmButton.backgroundColor = UIColor.blue
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.isUserInteractionEnabled = true
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        confirmButton.setTitleColor(UIColor.black, for: .normal)
        //confirmButton.adjustsImageWhenHighlighted  = true
        
        self.condtions.addSubview(confirmButton)
        
        _ = confirmButton.sd_layout().bottomSpaceToView(condtions,20)?.leftSpaceToView(condtions,20)?.heightIs(30)?.widthIs(260)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionArray:NSArray = data[indexs[section]]! as NSArray
        return sectionArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! myitem
        
        let sectionArray:NSArray = data[indexs[indexPath.section]]! as NSArray
        
        let content = sectionArray.object(at: indexPath.row) as! String
        cell.name.setTitle(content, for: .normal)
        
        //cell.age.font = UIFont.systemFont(ofSize: 12)
        
        
        return cell
        
        
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsetsMake(0, 10, 0, 10)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind  == UICollectionElementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headeview", for: indexPath)
                as! headerView
            header.name.text = indexs[indexPath.section]
            header.name.backgroundColor = UIColor.white
            header.name.textColor = UIColor.blue
            header.name.font = UIFont.systemFont(ofSize: 12)
            header.name.adjustsFontSizeToFitWidth = true
            
            
            return header
        }
        
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footview", for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell  =  collectionView.cellForItem(at: indexPath) as! myitem
        cell.name.backgroundColor = UIColor.blue
        
        cell.name.isSelected = true
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell  =  collectionView.cellForItem(at: indexPath) as! myitem
        cell.name.backgroundColor = UIColor.white
        cell.name.isSelected = false
    }
    
    // 取消同section 之前被选择的item
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        //
        for index in collectionView.indexPathsForSelectedItems!{
            if indexPath.section == index.section {
                //
                let cell =  collectionView.cellForItem(at: index) as! myitem
                condtions.deselectItem(at: index, animated: false)
                cell.name.backgroundColor = UIColor.white
                cell.name.isSelected = false
                
            }
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("start scroll \(scrollView)")
    }
    
    
    // very good  点击事件透传
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        //loop through the cells, get each cell, and run this test on each cell
        //you need to define a proper loop
        for cell in self.condtions.visibleCells {
            
            //if the touch was in the cell
            if cell.frame.contains(point) {
                //get the cells button
                for uiview in cell.subviews {
                    if uiview is UIButton {
                        let button = uiview as! UIButton
                        //if the button received the touch, return it, if not, return the cell
                        if button.frame.contains(point) {
                            return button
                        }
                        else {
                            return cell
                        }
                    }
                }
            }
        }
        if confirmButton.frame.contains(point){
            return confirmButton
        }
        //after the loop, if it could not find the touch in one of the cells return the view you are on
        return condtions
        
    }
    
    func confirm(){
        
        let days = 0
        var salary = "不限"
        var month = 0
        var scholar = "不限"
        var staff = false
        for index in   condtions.indexPathsForSelectedItems!{
            
            let sectionArray:NSArray = data[indexs[index.section]]! as NSArray
            let content = sectionArray.object(at: index.row) as! String
            
            
        }
        (self.superview as! YNDropDownView).hideMenu()
        self.selections?.selected(days: days, salary: salary, month: month, scholarship: scholar, staff: staff)
    }
}


class myitem:UICollectionViewCell{
    
    
    lazy var name:UIButton = {
        let name = UIButton.init()
        name.backgroundColor = UIColor.white
        name.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        name.setTitleColor(UIColor.black, for: .normal)
        name.setTitleColor(UIColor.white, for: .selected)
        name.layer.borderWidth = 0.7
        name.layer.borderColor = UIColor.gray.cgColor
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(name)
        _ = name.sd_layout().topEqualToView(self)?.widthIs(60)?.heightIs(20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

