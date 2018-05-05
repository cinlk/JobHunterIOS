//
//  tagsTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/9.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let cellH:CGFloat = 30

@objcMembers class tagsTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    private lazy var label: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.text = "公司标签"
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return label
    }()
    
    // 标签collectionview
    private lazy var taggroup: UICollectionView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout()
        // 用120，字数长度最大为
        layout.estimatedItemSize = CGSize.init(width: 120, height: 30)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let taggroup = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        taggroup.isUserInteractionEnabled = false
        taggroup.showsVerticalScrollIndicator = false
        taggroup.showsVerticalScrollIndicator = false
        taggroup.contentInset = UIEdgeInsetsMake(10, 10, 0, 10)
        // 取消滚动，不然视图滑动错位
        taggroup.isScrollEnabled = false
        taggroup.delegate = self
        taggroup.backgroundColor  = UIColor.white
        taggroup.dataSource  = self
        taggroup.register(MyTag.self, forCellWithReuseIdentifier: "mytag")
        return taggroup
        
    }()
    
    private lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black
        return v
    }()
    
    dynamic var tags:[String]?{
        didSet{
            
            // MARK 如何动态计算 collectionview 高度？？？？
            let count = tags!.count
            // 技巧，最小2个，大于3个的数 高度都能覆盖
            _ = self.taggroup.sd_layout().heightIs(CGFloat((count/3) * 40 + 40))
            self.taggroup.reloadData()
            
            // 立刻跟新布局，不用等runloop 来更新
            //self.taggroup.layoutIfNeeded()
//
//            let contentSize = self.taggroup.collectionViewLayout.collectionViewContentSize
//            self.taggroup.sd_layout().heightIs(contentSize.height)
//
            self.setupAutoHeight(withBottomView: taggroup, bottomMargin: 10)
        }
    }
    
  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        self.selectionStyle = .none
        let views:[UIView] = [line, label, taggroup]
        self.contentView.sd_addSubviews(views)
        
        _ = label.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        
        _ = line.sd_layout().topSpaceToView(label,5)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(1)
        
        _ = taggroup.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(line,5)?.heightIs(0)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   override func cellHeight(for indexPath: IndexPath!, cellContentViewWidth width: CGFloat, tableView: UITableView!) -> CGFloat {
        
        return cellH
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return  1
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return tags?.count ?? 0
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "mytag", for: indexPath) as! MyTag
        let content =  tags?[indexPath.row] ?? ""
        cell.lable.text = content
 
        return cell
    }
    
}


fileprivate  class MyTag:UICollectionViewCell{
    
    lazy var lable:UILabel = {
        let lable = UILabel.init()
        lable.textColor = UIColor.black
        lable.textAlignment = .center
        lable.backgroundColor = UIColor.white
        lable.layer.borderWidth  = 1
        lable.adjustsFontSizeToFitWidth = true
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.lineBreakMode = .byWordWrapping
        
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 必须放到cell的contentview
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(lable)
        _ = lable.sd_layout().centerXEqualToView(self.contentView)?.centerYEqualToView(self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //  label string 长度定义cell长度
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.frame = CGRect(x: 0, y: 0, width:NSString(string: lable.text!).size(withAttributes: [NSAttributedStringKey.font:lable.font]).width+10, height: 30)
        lable.frame = attributes.frame
        
        return attributes
    }
}
