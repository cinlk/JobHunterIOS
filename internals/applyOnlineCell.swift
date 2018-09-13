//
//  applyOnlineCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let column:Int = 2
fileprivate let row:Int = 2

class applyOnlineCell: UITableViewCell {

    
    private lazy var collect:BaseCollectionHorizonView = BaseCollectionHorizonView.init(frame: CGRect.zero, column: column, row: row)
    
    
    internal var selectedIndex:((_ name:String)->Void)?
    

    var mode:(title:String, items:[applyField])?{
        didSet{
                self.collect.topTitle.text = mode?.title
                self.collect.collectionView.reloadData()
            
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collect.collectionView.register(applyShowCollectedCell.self, forCellWithReuseIdentifier: applyShowCollectedCell.identity())
        collect.collectionView.delegate = self
        collect.collectionView.dataSource = self
        collect.rightBtn.addTarget(self, action: #selector(showAll(_:)), for: .touchUpInside)
        self.contentView.addSubview(collect)
        _ = collect.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "applyOnlineCell"
    }
    
}

extension applyOnlineCell{
    @objc private func showAll(_ btn:UIButton) {
        self.selectedIndex?("")
        
    }
}



extension applyOnlineCell:UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: applyShowCollectedCell.identity(), for: indexPath) as! applyShowCollectedCell
        cell.mode = mode!.items[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 跳转到 网申界面，显示所有对应项
        self.selectedIndex?(mode!.title)
    }
    
    
}

private class  applyShowCollectedCell:UICollectionViewCell{
    
    
    private lazy var icon:UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleToFill
        icon.clipsToBounds = true
        return icon
        
    }()
    
    private lazy var name:UILabel = {  [unowned self] in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.setSingleLineAutoResizeWithMaxWidth(self.width)
        label.textAlignment = .center
        return label
    }()
    
    var mode:applyField?{
        didSet{
            self.name.text = mode?.Field
            let url = URL.init(string: mode?.ImageUrl ?? "")
            //self.icon.image = UIImage.init(named: mode?.ImageUrl ?? APPLY_DEFAULT_IMG)
            self.icon.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(icon)
        self.contentView.addSubview(name)
      
        _ = name.sd_layout().centerXEqualToView (self.contentView)?.bottomEqualToView(self.contentView)?.autoHeightRatio(0)
        _ = icon.sd_layout().topEqualToView(self.contentView)?.leftSpaceToView(self.contentView,5)?.rightSpaceToView(self.contentView,5)?.bottomSpaceToView(name,5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "applyShowCollectedCell"
    }
    
    
    
    
}
