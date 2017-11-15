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
        
        let line = UIView()
        line.backgroundColor = UIColor.black
        self.contentView.addSubview(line)
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
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return  1
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return tags.count
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "mytag", for: indexPath) as! MyTag
        
        
        let content =  tags[indexPath.row]
        
        cell.age.text = content
        cell.age.textColor = UIColor.black
        cell.backgroundColor = UIColor.gray
        return cell
    }
    
}


class MyTag:UICollectionViewCell{
    
    lazy var age:UILabel = {
        let age = UILabel.init()
        age.textColor = UIColor.black
        age.textAlignment = .center
        age.backgroundColor = UIColor.white
        age.layer.borderWidth  = 1
        age.adjustsFontSizeToFitWidth = true
        
        age.layer.borderColor = UIColor.black.cgColor
        age.font = UIFont.systemFont(ofSize: 17)
       
        return age
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 必须放到cell的contentview
        self.contentView.addSubview(age)
       _ = age.sd_layout().centerXEqualToView(self.contentView)?.centerYEqualToView(self.contentView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.frame = CGRect(x: 0, y: 0, width:NSString(string: age.text!).size(withAttributes: [NSAttributedStringKey.font:age.font]).width+10, height: 30)
                // 由于cell哪里label frame为0,0,0,0 这里重新设置frame显示字体
        age.frame = attributes.frame

        return attributes
    }
}
