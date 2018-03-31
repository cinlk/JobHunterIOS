//
//  ChatEmotionCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


// 静态表情
class StaticChatEmotionCell: UICollectionViewCell {

    // MARK:- 定义属性
    var emotion: MChatEmotion? {
        didSet {
            guard let emo = emotion else { return }
            if emo.isRemove {
                emotionImageView.image = UIImage(named: "DeleteEmoticonBtn")
            } else if emo.isEmpty {
                emotionImageView.image = UIImage()
            } else {
                guard let imgPath = emo.imgPath else {
                    return
                }
                emotionImageView.image = UIImage(contentsOfFile: imgPath)
            }
        }
    }
    
    // MARK:- 懒加载
    private lazy var emotionImageView: UIImageView = {
        return UIImageView()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(emotionImageView)
        //emotionImageView.frame = self.contentView.frame
        _ = emotionImageView.sd_layout().topSpaceToView(self.contentView,2.5)?.centerXEqualToView(self.contentView)?.widthIs(32)?.heightIs(32)
        
        }
    
    class func identity()->String{
        return "StaticChatEmotionCell"
    }
    
    }

// 动态图表情
class DynamicChatEmotionCell: UICollectionViewCell {
    
    var emotion: MChatEmotion? {
        didSet{
            guard let emo = emotion else {return}
            guard let imgPath = emo.imgPath else {return }
            guard let label = emo.text else {return }
            
            emotionImageView.image = UIImage.init(contentsOfFile: imgPath)
            // 去除 括号[]，保留字符
            let characterSet = CharacterSet.init(charactersIn: "[]")
            name.text  = label.trimmingCharacters(in: characterSet)
        }
    }
    
    private lazy var emotionImageView: UIImageView = {
       return UIImageView()
    }()
    
    private lazy var name: UILabel = {
       var lb = UILabel.init()
        lb.font = UIFont.systemFont(ofSize: 10)
        lb.textColor = UIColor.black
        lb.textAlignment = .center
        return lb
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(emotionImageView)
        self.contentView.addSubview(name)
        _ = emotionImageView.sd_layout().topSpaceToView(self.contentView,2.5)?.centerXEqualToView(self.contentView)?.widthIs(60)?.heightIs(60)
        _ = name.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(emotionImageView,1)?.widthIs(60)?.heightIs(20)
        
    }
    
    class func identity()->String{
        return "DynamicChatEmotionCell"
    }
    
}

