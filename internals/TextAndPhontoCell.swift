//
//  TextAndPhontoCell.swift
//  internals
//
//  Created by ke.liang on 2018/5/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let btnSizeWidth:CGFloat = 80
fileprivate let placeholdStr:String = "写入反馈"

class TextAndPhontoCell: UITableViewCell {

    
    
    internal var imageOne:UIImage?{
        didSet{
            guard let image = imageOne else {
                
                (pickerImageBtn1.viewWithTag(20) as! UIButton).isHidden = true
                pickerImageBtn1.isSelected = false
                pickerImageBtn1.setBackgroundImage(nil, for: .normal)
                pickerImageBtn1.setPositionWith(image: #imageLiteral(resourceName: "plus").changesize(size: CGSize.init(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), title: "上传图片", titlePosition: .bottom, additionalSpacing: 5, state: .normal, offsetY:  -10)
                return
            }
            (pickerImageBtn1.viewWithTag(20) as! UIButton).isHidden = false
            pickerImageBtn1.setTitle(nil, for: .normal)
            pickerImageBtn1.setImage(nil, for: .normal)
            pickerImageBtn1.isSelected = true
            pickerImageBtn1.setBackgroundImage(image, for: .normal)
        }
    }
    internal var imageTwo:UIImage?{
        didSet{
            guard  let image = imageTwo else {
                
                (pickerImageBtn2.viewWithTag(20) as! UIButton).isHidden = true

                pickerImageBtn2.isSelected = false
                pickerImageBtn2.setBackgroundImage(nil, for: .normal)
                pickerImageBtn2.setPositionWith(image: #imageLiteral(resourceName: "plus").changesize(size: CGSize.init(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), title: "上传图片", titlePosition: .bottom, additionalSpacing: 5, state: .normal, offsetY:  -10)
                return
            }
            (pickerImageBtn2.viewWithTag(20) as! UIButton).isHidden = false
            pickerImageBtn2.setTitle(nil, for: .normal)
            pickerImageBtn2.setImage(nil, for: .normal)
            pickerImageBtn2.isSelected = true
            pickerImageBtn2.setBackgroundImage(image, for: .normal)
        }
    }
    
    internal var setImage:(()->Void)?

    
    
    private lazy var placehold:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.text = placeholdStr
        return label
    }()
    
    private lazy var textView:UITextView = { [unowned self] in
        let text = UITextView.init()
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.black
        text.showsVerticalScrollIndicator = true
        // 内部container 偏移
        text.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 0)
        text.delegate = self
        text.inputAccessoryView = UIToolbar.NumberkeyBoardDone(title: "完成", view: self, selector: #selector(done))
        return text
        
        
    }()
    
    // delete image icon
    private lazy var deletBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.lightGray
        btn.alpha = 0.5
        btn.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        return btn
    }()
    private lazy var pickerImageBtn1:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: btnSizeWidth, height: btnSizeWidth * 6/5))
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
       
        btn.setPositionWith(image: #imageLiteral(resourceName: "plus").changesize(size: CGSize.init(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), title: "上传图片", titlePosition: .bottom, additionalSpacing: 5, state: .normal, offsetY:  -10)
        btn.tintColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(setPictureOne), for: .touchUpInside)
        
        // delete Btn
        let iconDelete = UIButton()
        iconDelete.backgroundColor = UIColor.lightGray
        iconDelete.alpha = 0.8
        iconDelete.setImage(#imageLiteral(resourceName: "delete").changesize(size: CGSize.init(width: 10, height: 10)).withRenderingMode(.alwaysTemplate), for: .normal)
        iconDelete.tintColor = UIColor.red
        iconDelete.tag = 20
        iconDelete.isHidden = true
        iconDelete.isUserInteractionEnabled = false
        btn.addSubview(iconDelete)
        _ = iconDelete.sd_layout().rightEqualToView(btn)?.topEqualToView(btn)?.widthIs(15)?.heightIs(15)
        
        return btn
        
    }()
    
    private lazy var pickerImageBtn2:UIButton = { [unowned self] in
        // 这里给出了大小，title才有frame
         let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: btnSizeWidth, height: btnSizeWidth * 6/5))
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        
        
        btn.setPositionWith(image: #imageLiteral(resourceName: "plus").changesize(size: CGSize.init(width: 30, height: 30)).withRenderingMode(.alwaysTemplate), title: "上传图片", titlePosition: .bottom, additionalSpacing: 5, state: .normal, offsetY:  -10)
        btn.tintColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(setPictureTow), for: .touchUpInside)
        
        let iconDelete = UIButton()
        iconDelete.backgroundColor = UIColor.lightGray
        iconDelete.alpha = 0.8
        iconDelete.setImage(#imageLiteral(resourceName: "delete").changesize(size: CGSize.init(width: 10, height: 10)).withRenderingMode(.alwaysTemplate), for: .normal)
        iconDelete.tintColor = UIColor.red
        iconDelete.tag = 20
        iconDelete.isHidden = true
        iconDelete.isUserInteractionEnabled = false

        btn.addSubview(iconDelete)
        _ = iconDelete.sd_layout().rightEqualToView(btn)?.topEqualToView(btn)?.widthIs(15)?.heightIs(15)
        
        
        return btn
    }()
    
    
    private lazy var words:UILabel = {
        let word = UILabel()
        word.font = UIFont.systemFont(ofSize: 12)
        word.textColor = UIColor.lightGray
        word.textAlignment = .left
        word.setSingleLineAutoResizeWithMaxWidth(100)
        word.text = "0/500"
        return word
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let views:[UIView] = [textView, pickerImageBtn1, pickerImageBtn2,words]
        self.contentView.sd_addSubviews(views)
        textView.addSubview(placehold)
        _ = placehold.sd_layout().leftSpaceToView(textView,15)?.topSpaceToView(textView,10)?.autoHeightRatio(0)
        
        
        // 在设置x和y位置 和改变大小
        _ = pickerImageBtn1.sd_layout().bottomSpaceToView(self.contentView,10)?.leftSpaceToView(self.contentView,10)?.widthIs(btnSizeWidth)?.autoHeightRatio(6/5)
        _ = pickerImageBtn2.sd_layout().leftSpaceToView(pickerImageBtn1,20)?.topEqualToView(pickerImageBtn1)?.widthRatioToView(pickerImageBtn1,1)?.heightRatioToView(pickerImageBtn1,1)
        
        _ = textView.sd_layout().topEqualToView(self.contentView)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.bottomSpaceToView(pickerImageBtn1,10)
        
        _ = words.sd_layout().rightSpaceToView(self.contentView,10)?.bottomEqualToView(pickerImageBtn1)?.autoHeightRatio(0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "TextAndPhontoCell"
    }
    
    class func cellHeight()->CGFloat{
        return 280
        
    }

}




extension TextAndPhontoCell{
    @objc private func done(){
        self.textView.resignFirstResponder()
    }
    
    @objc private func setPictureOne(){
        if imageOne == nil {
            self.setImage?()
            return
        }
        imageOne = nil
        
        
    }
    
    @objc private func setPictureTow(){
        if imageTwo == nil{
            self.setImage?()
            return
        }
        imageTwo = nil
    }
}


extension TextAndPhontoCell:UITextViewDelegate{
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        placehold.isHidden =  textView.text.isEmpty ? false : true
        let wordCount = textView.text.count
        words.text = "\(wordCount)/500"
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placehold.isHidden =  textView.text.isEmpty ? false : true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placehold.isHidden =  textView.text.isEmpty ? false : true
        
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
}
