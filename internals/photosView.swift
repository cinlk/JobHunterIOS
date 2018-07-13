//
//  photosView.swift
//  internals
//
//  Created by ke.liang on 2018/7/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class photosView: UIView {

    
    
    
 
    
    
    internal var setImage:((_ btn: inout UIImageView) -> Void)?
    
    // 得到图片数据
    internal var imageData:[Data]{
        get{
            var res:[Data] = []
            if let image = imageOne.image, let data = UIImageJPEGRepresentation(image, 0){
                res.append(data)
            }
            if let image = imageTow.image, let data = UIImageJPEGRepresentation(image, 0){
                res.append(data)
            }
            
            return res
        }
    }
    
    private lazy var pickerBtnOne:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.setPositionWith(image: #imageLiteral(resourceName: "plus").changesize(size: CGSize.init(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), title: "上传图片", titlePosition: .bottom, additionalSpacing: 5, state: .normal, offsetY: -10)
        btn.tintColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(pictureOne), for: .touchUpInside)
        
        
        return btn
    }()
    
    
    
    private lazy var pickerBtnTwo:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 80))
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.setPositionWith(image: #imageLiteral(resourceName: "plus").changesize(size: CGSize.init(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), title: "上传图片", titlePosition: .bottom, additionalSpacing: 5, state: .normal, offsetY: -10)
        btn.tintColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(pictureTwo), for: .touchUpInside)
        
        
        return btn
    }()
    
    
    // 替换的imageview
    
    private lazy var imageOne:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.isHidden = true
        image.layer.borderWidth = 1
        image.isUserInteractionEnabled = true
        image.layer.borderColor = UIColor.lightGray.cgColor
        let tab = UITapGestureRecognizer()
        tab.addTarget(self, action: #selector(pictureOne))
        image.addGestureRecognizer(tab)
        
        // 右上角删除图片
        let subImage = UIImageView()
        subImage.backgroundColor = UIColor.randomeColor()
        subImage.clipsToBounds = true
        subImage.isUserInteractionEnabled = true
        let subtab = UITapGestureRecognizer()
        subtab.addTarget(self, action: #selector(deleteImage))
        subImage.addGestureRecognizer(subtab)
        
        image.addSubview(subImage)
        _ = subImage.sd_layout().rightEqualToView(image)?.topEqualToView(image)?.heightIs(20)?.widthIs(20)
        
        
        return image
    }()
    
    private lazy var imageTow:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.isHidden = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.isUserInteractionEnabled = true
        let tab = UITapGestureRecognizer()
        tab.addTarget(self, action: #selector(pictureTwo))
        image.addGestureRecognizer(tab)
        // 右上角删除图片
        let subImage = UIImageView()
        subImage.backgroundColor = UIColor.randomeColor()
        subImage.clipsToBounds = true
        subImage.isUserInteractionEnabled = true
        let subtab = UITapGestureRecognizer()
        subtab.addTarget(self, action: #selector(deleteImage))
        subImage.addGestureRecognizer(subtab)
        
        image.addSubview(subImage)
        _ = subImage.sd_layout().rightEqualToView(image)?.topEqualToView(image)?.heightIs(20)?.widthIs(20)
        
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.addSubview(pickerBtnOne)
        self.addSubview(pickerBtnTwo)
        self.addSubview(imageOne)
        self.addSubview(imageTow)
        
        
        _ = pickerBtnOne.sd_layout().bottomSpaceToView(self,5)?.leftSpaceToView(self,10)?.widthIs(80)?.autoHeightRatio(1)
        _ = pickerBtnTwo.sd_layout().leftSpaceToView(pickerBtnOne,15)?.bottomEqualToView(pickerBtnOne)?.widthIs(80)?.autoHeightRatio(1)
        
        _ = imageOne.sd_layout().bottomSpaceToView(self,5)?.leftSpaceToView(self,10)?.widthIs(80)?.autoHeightRatio(1)
        _ = imageTow.sd_layout().leftSpaceToView(imageOne,15)?.bottomEqualToView(pickerBtnOne)?.widthIs(80)?.autoHeightRatio(1)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

extension photosView{
    @objc private func pictureOne(){
        self.setImage?(&imageOne)
        
        
    }
    
    @objc private func pictureTwo(){
        self.setImage?(&imageTow)

    }
    
    @objc private func deleteImage(_ tap:UIGestureRecognizer){
        if let target = tap.view as? UIImageView, let parent = target.superview as?  UIImageView{
            parent.image = nil
            parent.isHidden = true
        }
    }
}



