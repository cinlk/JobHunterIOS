//
//  shareView.swift
//  internals
//
//  Created by ke.liang on 2017/9/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate var ROWNUMBERS = 2
fileprivate let COLUME = 4
fileprivate let btnHeight:CGFloat = 45


protocol shareViewDelegate: class {
    func handleShareType(type: UMSocialPlatformType, view:UIView)
}


class shareView: UIView {
    
    // MARK 判断是否安装应用？？ UMSocialManager.default().isInstall(.wechatSession)
    
    
    // shareView的背景
    private lazy var sharebackBtn: UIButton = {  [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        btn.alpha = 0.5
        btn.backgroundColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    
    
    
    weak var delegate:shareViewDelegate?
    
    
    private lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    private lazy var cancelBtn:UIButton = {  [unowned self] in
        let btn = UIButton.init()
        btn.setTitle("取 消", for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    
    private lazy var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize.init(width: ScreenW / 4 - 15, height: (shareViewH - btnHeight) / 2 - 10)

        return layout
    }()
    
    private lazy var collectionView:UICollectionView = {  [unowned self] in
        let coll = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.layout)
        coll.backgroundColor = UIColor.white
        coll.dataSource = self
        coll.delegate = self
        coll.isScrollEnabled = false
        coll.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        coll.register(shareItemCell.self, forCellWithReuseIdentifier: shareItemCell.identity())
        return coll
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(collectionView)
        self.addSubview(cancelBtn)
        self.addSubview(line)
        

        _ = cancelBtn.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.heightIs(btnHeight)?.bottomEqualToView(self)
        _ = line.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomSpaceToView(cancelBtn,0)?.heightIs(1)
        _ = collectionView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomSpaceToView(cancelBtn,0)
        
        
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension shareView{
    func showShare(){
        UIApplication.shared.keyWindow?.insertSubview(sharebackBtn, belowSubview: self)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.frame.origin.y = ScreenH - shareViewH
        
                }, completion: nil)
    }
    
   @objc open  func dismiss(){
        sharebackBtn.removeFromSuperview()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame.origin.y = ScreenH
            
        }, completion: nil)
        
    }
}

extension shareView:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: shareItemCell.identity(), for: indexPath) as! shareItemCell
        let mode = shareItems[indexPath.row]
        cell.mode = (image: UIImage.init(named: mode.image ?? "default")! , name: mode.name!)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mode = shareItems[indexPath.row]
        self.sharedToUM(type: mode.type)
    }
    
    
}

// 代用友盟sdk进行分享
extension shareView{
    
    func sharedToUM(type: UMSocialPlatformType?){
        
        guard let type = type  else {
            return
        }
        delegate?.handleShareType(type: type ,view: sharebackBtn)
        
    }
    
    
    func getUserInfo(platformType:UMSocialPlatformType, vc :UIViewController){
        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: vc) { (result, error) in
            if let userInfo = result as? UMSocialUserInfoResponse{
                print(userInfo)
                
                //
                let AlerVC = UIAlertController.init(title: userInfo.name, message: userInfo.iconurl, preferredStyle: .alert)
                
                vc.present(AlerVC, animated: true, completion: nil)
                
            }
        }
    }
}





private class shareItemCell:UICollectionViewCell{
    
    private lazy var imageView:UIImageView = {
        let image =  UIImageView.init()
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        return image
    }()
    
    private lazy var name:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(100)
        return label
    }()
    
    var mode:(image:UIImage, name:String)?{
        didSet{
            self.imageView.image = mode!.image
            self.name.text = mode!.name
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let views:[UIView] = [imageView, name]
        self.contentView.sd_addSubviews(views)
        _ = imageView.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,5)?.widthIs(50)?.heightIs(50)
        _ = name.sd_layout().topSpaceToView(imageView,5)?.centerXEqualToView(imageView)?.autoWidthRatio(0)
        imageView.sd_cornerRadiusFromWidthRatio = 0.5
        name.setMaxNumberOfLinesToShow(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    class func identity()->String{
        return "shareItemCell"
    }
}

