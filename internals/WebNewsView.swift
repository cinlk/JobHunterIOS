//
//  WebNewsView.swift
//  internals
//
//  Created by ke.liang on 2018/1/11.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


class WebNewsView: UIWebView {

    
//    lazy var titleLabel:UILabel = {
//        let lable = UILabel.init(frame: CGRect.zero)
//        lable.text = "如何找到一份好工作，叫你正确投简历"
//        lable.font = UIFont.boldSystemFont(ofSize: 16)
//        lable.sizeToFit()
//
//        return lable
//
//    }()
    
    // tmp wait view
    lazy var waitView:UIView = {
        let wv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        wv.backgroundColor = UIColor.white
        let acv = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        acv.center = wv.center
        acv.startAnimating()
        wv.addSubview(acv)
        return wv
    }()
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews(){
        self.scalesPageToFit = true 
        //self.scrollView.addSubview(titleLabel)
        self.scrollView.addSubview(waitView)
        //let size = titleLabel.text?.getStringCGRect(size: CGSize.init(width: ScreenW, height: 0), font: UIFont.boldSystemFont(ofSize: 16))
        
        //_ = titleLabel.sd_layout().topEqualToView(self.scrollView)?.leftEqualToView(self.scrollView)?.rightEqualToView(self.scrollView)?.heightIs((size?.height)!)
        
    }
    

}
