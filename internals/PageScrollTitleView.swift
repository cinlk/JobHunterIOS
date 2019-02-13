//
//  PageScrollTitleView.swift
//  internals
//
//  Created by ke.liang on 2019/2/11.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation






class PageScrollTitleView:UIView {
    
    
    var kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
    var kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)
    
    
    private lazy var labels:[UILabel] = []
    private lazy var titles:[String] = []
    private lazy var labelWidth:CGFloat = 0
    private lazy var startIndex:Int = 0
    
    weak var delegate:pagetitleViewDelegate?
    
    lazy var subline:UIView = { [unowned self] in
        let v = UIView.init(frame: CGRect.init(x: 0, y: self.bounds.height-1, width: GlobalConfig.ScreenW, height: 1))
        v.backgroundColor = ConfigColor.PageTitleColor.SublineColor
        return v
    }()
    private lazy var scrollerView:UIScrollView = {
        
        let s = UIScrollView.init(frame: CGRect.zero)
        s.contentInsetAdjustmentBehavior = .never
        s.bounces = false
        s.scrollsToTop = false
        //s.contentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        s.showsVerticalScrollIndicator = false
        s.showsHorizontalScrollIndicator = false
        s.isPagingEnabled = false
        s.delegate = self
        //s.isUserInteractionEnabled = true
        return s
        
    }()
    
    
    
    init(frame: CGRect, titles:[String]) {
        
        super.init(frame: frame)
        self.titles = titles
        // 默认长度为 width 的四分之一， 方便滑动偏移设置
        self.labelWidth = ceil(frame.width  /  4)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        
        self.addSubview(self.scrollerView)
        self.addSubview(self.subline)
        _ = self.scrollerView.sd_layout()?.topEqualToView(self)?.leftEqualToView(self)?.bottomEqualToView(self)?.rightEqualToView(self)
        
        self.buildLabels()
        super.layoutSubviews()
        
    }
}


extension PageScrollTitleView: UIScrollViewDelegate{
    
    private func buildLabels(){
        
        // 创建label
         for (index, item) in    self.titles.enumerated(){
            let label = UILabel.init(frame: CGRect.init(x: CGFloat(index)*self.labelWidth, y: 0, width: self.labelWidth, height: self.frame.height))
            label.text = item
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            label.textColor  =  index == 0 ?  UIColor.init(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2) : UIColor.init(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            
            label.adjustsFontSizeToFitWidth = true 
            
    
            // 添加点击
            let tap = UITapGestureRecognizer.init()
            tap.addTarget(self, action: #selector(chooseLabel(gesture:)))
            label.addGestureRecognizer(tap)
            label.isUserInteractionEnabled = true
            label.tag = index
            self.scrollerView.addSubview(label)
            self.labels.append(label)
            
        }
        
        self.scrollerView.contentSize = CGSize.init(width: CGFloat(self.titles.count) * self.labelWidth, height: self.frame.height)
        
      
        
    }
    
    
    
}


extension PageScrollTitleView{
    
    
    
    @objc private func chooseLabel(gesture:UITapGestureRecognizer){
        
        
        guard  let lb = gesture.view as? UILabel else {
            return
        }
        if lb.tag == startIndex {
            return
        }
        if gesture.state == .ended {
         
            labels[startIndex].textColor = UIColor.init(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            labels[lb.tag].textColor = UIColor.init(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
            startIndex = lb.tag
            
            self.delegate?.ScrollContentAtIndex(index: startIndex)
        }
        
    }
    
    
    func changeTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int){
        
        let sourceLabel = labels[sourceIndex]
        let targetLabel = labels[targetIndex]
        
 

        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)

        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)

        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)

        // scroll 滑动
        let page = floor((CGFloat(targetIndex) * self.labelWidth / self.scrollerView.frame.width))
        
  
        self.scrollerView.contentOffset = CGPoint.init(x:  page * self.scrollerView.frame.width, y: 0)
        
        startIndex = targetIndex
    }
}
