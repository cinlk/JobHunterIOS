//
//  pagetitleView.swift
//  internals
//
//  Created by ke.liang on 2018/1/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


protocol pagetitleViewDelegate: class {
    func ScrollContentAtIndex(index:Int, _ titleView: pagetitleView)
    
}



class pagetitleView: UIView {

    
    var kScrollLineH : CGFloat = 2
    var kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
    var kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)
    
    var labelTitles:[UILabel] = []
    var startIndex:Int = 0
    var titles:[String]?
    var lineCenter:Bool = false
    
    weak var delegate:pagetitleViewDelegate?
    
    //private var lineWidth:CGFloat = 30
    lazy var moveLine:UIView = {
       let v = UIView.init(frame: CGRect.zero)
       v.backgroundColor = UIColor.orange
       return v
    }()
    
    
    lazy var subline:UIView = { [unowned self] in
        let v = UIView.init(frame: CGRect.init(x: 0, y: self.bounds.height-1, width: ScreenW, height: 1))
        v.backgroundColor = UIColor.init(r: 100, g: 100, b: 100, alpha: 0.5)
        return v
    }()
    
    
    init(frame:CGRect, titles:[String], lineCenter:Bool = false) {
        super.init(frame: frame)
        self.titles = titles
        self.lineCenter = lineCenter
        self.setViews()
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension pagetitleView{
 
    private func setViews(){
        self.backgroundColor = UIColor.white
        self.creatLabels()
        self.layoutSubviews()
        self.addSubview(moveLine)
        self.addSubview(subline)
        guard let firstLabel = labelTitles.first else {
            return
        }
        if lineCenter{
          
            moveLine.frame = CGRect.init(x: firstLabel.center.x - 15 , y: frame.height - 5, width: 30, height: kScrollLineH)
        }else{
            moveLine.frame = CGRect.init(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH , width: firstLabel.frame.width, height: kScrollLineH)
        }
        
    }
    
    private func creatLabels(){
        guard let labels = self.titles else {
            return
        }
        
        if lineCenter{
            kNormalColor = (50,50,50)
            kSelectColor = (255,255,255)
            
        }
        let count = labels.count
        // 以4为单位
       
        //let width:CGFloat = ScreenW / CGFloat(count)
        
        var labelsView:[UILabel] = []
        
        for (index, item) in  labels.enumerated() {
            //  调用用setupAutoMarginFlowItems 后 父view的高度和label高度一样（保持一致）
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: self.bounds.height))
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = index == 0 ? UIColor.init(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2) : UIColor.init(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.text = item
            label.tag = index
            
            //label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
            self.addGuesture(label: label)
            //label.sizeToFit()
            label.textAlignment = .center
            self.labelTitles.append(label)
            labelsView.append(label)
            //self.addSubview(label)
            
        }
        self.sd_addSubviews(labelsView)
        if count >= 4{
            if self.lineCenter{
                // 缩短间隔距离
                self.setupAutoMarginFlowItems(labelsView, withPerRowItemsCount: count, itemWidth: 60, verticalMargin: 0, verticalEdgeInset: 0, horizontalEdgeInset: 30)
            }else{
                self.setupAutoMarginFlowItems(labelsView, withPerRowItemsCount: count, itemWidth: (ScreenW - 20) / CGFloat(count), verticalMargin: 0, verticalEdgeInset: 0, horizontalEdgeInset: 5)
            }
        }else{
             let diff = 4 - count
             // horizoneEdge 与最近父view的边距
             self.setupAutoMarginFlowItems(labelsView, withPerRowItemsCount: count, itemWidth: (ScreenW - 20) / CGFloat(4)  , verticalMargin: 0, verticalEdgeInset: 0, horizontalEdgeInset: CGFloat(diff*30))
        }
            
    }
    private func addGuesture(label:UILabel){
        label.isUserInteractionEnabled = true
        let guestTap = UITapGestureRecognizer.init()
        guestTap.addTarget(self, action: #selector(labelClick(guest:)))
        label.addGestureRecognizer(guestTap)
    }
    
    
    // 点击label
    @objc func labelClick(guest:UITapGestureRecognizer){
        if guest.state != .ended{
            return
        }
        guard let label = guest.view as? UILabel else {
            return
        }
       
        
        
        let currentIndex = label.tag
        if currentIndex == startIndex {
            return
        }
        
        let oldIabel = labelTitles[startIndex]
        let distance = labelTitles[currentIndex].frame.origin.x - oldIabel.frame.origin.x
        let centerDistance =  labelTitles[currentIndex].center.x - oldIabel.center.x

        
        print("current \(currentIndex)", "start \(startIndex)")
        self.labelTitles[currentIndex].textColor = UIColor.init(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        self.labelTitles[startIndex].textColor = UIColor.init(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        startIndex = currentIndex
        
        

        
        UIView.animate(withDuration: 0.15) { [unowned self] in
            if self.lineCenter{
                
                self.moveLine.center.x = oldIabel.center.x + centerDistance
            }else{
                self.moveLine.frame.origin.x = oldIabel.frame.origin.x + distance

            }
        }
        
        
        
        self.delegate?.ScrollContentAtIndex(index: currentIndex, self)
    }
}


extension pagetitleView{
    func changeTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int){
        
        let sourceLabel = labelTitles[sourceIndex]
        let targetLabel = labelTitles[targetIndex]
        
        let distance = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let centerDistance = targetLabel.center.x - sourceLabel.center.x
        if lineCenter{
            self.moveLine.center.x = sourceLabel.center.x + centerDistance*progress
        }else{
            moveLine.frame.origin.x = sourceLabel.frame.origin.x + distance*progress
        }
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        

       
        startIndex = targetIndex
    }
}


