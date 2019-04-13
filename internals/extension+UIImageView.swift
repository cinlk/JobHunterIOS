//
//  extension+UIImageView.swift
//  internals
//
//  Created by ke.liang on 2018/6/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


extension UIImageView{
    
    
    
    func setCircle(){
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.1
    }
    
   
    
    convenience init(frame: CGRect, image: UIImage?, highlightedImage: UIImage?) {
            self.init(image: image, highlightedImage: highlightedImage)
            self.frame = frame
            self.contentMode = .scaleAspectFill
    }
    
}



