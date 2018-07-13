//
//  SearchBarView.swift
//  internals
//
//  Created by ke.liang on 2018/7/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class SearchBarView: UISearchBar{

    
    
    
    internal var textfield:UITextField?{
        get{
            return self.value(forKey: "searchField") as? UITextField
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 1
        self.tintColor = UIColor.blue
        self.backgroundColor = UIColor.clear
        self.backgroundImage = UIImage()
        self.returnKeyType = .search
    
        self.showsCancelButton = true
        // 屏蔽image 显示text的圆角
        self.setSearchFieldBackgroundImage(build_image(frame: CGRect.init(x: 0, y: 0, width: 1, height: searchBarH), color: UIColor.clear), for: .normal)
        setTextField()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension SearchBarView{
    private func setTextField(){
        let textField = self.value(forKey: "searchField") as? UITextField
        textField?.layer.cornerRadius = searchBarH/2
        textField?.layer.masksToBounds = true
        textField?.layer.borderWidth = 1
        textField?.layer.borderColor = UIColor.white.cgColor
        textField?.backgroundColor = UIColor.white
        textField?.textColor = UIColor.darkGray
        textField?.font = UIFont.systemFont(ofSize: 14)
        textField?.clearButtonMode = .whileEditing
        
    }
}

