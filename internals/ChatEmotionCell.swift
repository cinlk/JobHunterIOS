//
//  ChatEmotionCell.swift
//  internals
//
//  Created by ke.liang on 2017/10/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class ChatEmotionCell: UICollectionViewCell {

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
    lazy var emotionImageView: UIImageView = {
        return UIImageView()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(emotionImageView)
        _ = emotionImageView.sd_layout().centerXEqualToView(self.contentView)?.widthIs(32)?.heightIs(32)
        
        }
    }

