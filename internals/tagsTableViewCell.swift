//
//  tagsTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/9.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class tagsTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var taggroup: UICollectionView!
    
    
    var tags:[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let line = UIView()
        line.backgroundColor = UIColor.black
        self.contentView.addSubview(line)
        _ = label.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(120)?.heightIs(20)
        _ = line.sd_layout().topSpaceToView(label,5)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(1)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        layout.sectionInset=UIEdgeInsetsMake(0, 10, 0, 10)
        
        layout.estimatedItemSize = CGSize(width: 20, height: 20)
        
       
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
      
        
        taggroup.isUserInteractionEnabled = false
        taggroup.showsVerticalScrollIndicator = false
        taggroup.showsVerticalScrollIndicator = false
        taggroup.autoresizesSubviews = false
        taggroup.setCollectionViewLayout(layout, animated: false)
        taggroup.delegate = self
        taggroup.backgroundColor  = UIColor.white
        taggroup.dataSource  = self
        taggroup.register(MyTag.self, forCellWithReuseIdentifier: "mytag")
        
        
        
     
        
    }
    
   override func cellHeight(for indexPath: IndexPath!, cellContentViewWidth width: CGFloat, tableView: UITableView!) -> CGFloat {
        
        return 30
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return  1
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return tags.count
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "mytag", for: indexPath) as! MyTag
        let content =  tags[indexPath.row]
        cell.lable.text = content
        cell.lable.textColor = UIColor.black
        cell.backgroundColor = UIColor.gray
        return cell
    }
    
}


class MyTag:UICollectionViewCell{
    
    lazy var lable:UILabel = {
        let lable = UILabel.init()
        lable.textColor = UIColor.black
        lable.textAlignment = .center
        lable.backgroundColor = UIColor.white
        lable.layer.borderWidth  = 1
        lable.adjustsFontSizeToFitWidth = true
        
        lable.layer.borderColor = UIColor.black.cgColor
        lable.font = UIFont.systemFont(ofSize: 17)
       
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 必须放到cell的contentview
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
