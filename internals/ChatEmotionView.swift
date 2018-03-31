//
//  ChatEmotionView.swift
//  internals
//
//  Created by ke.liang on 2017/10/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

// 表情符
fileprivate let kEmotionCellNumberOfOneRow = 8
fileprivate let kEmotionCellRow = 3
fileprivate let kEmotionCellNumberOfOnePage = kEmotionCellRow * kEmotionCellNumberOfOneRow

// gif 图
fileprivate let MEmotionCellNumberOfOneRow = 4
fileprivate let MEmotionCellRow = 2
fileprivate let MEmotionCellNumberOfOnePage  = MEmotionCellRow * MEmotionCellNumberOfOneRow




protocol ChatEmotionViewDelegate: class {
    // 输入emotion到textview
    func chatEmotionView(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion)
    // 发送emotion
    func chatEmotionViewSend(emotionView: ChatEmotionView)
    // 发送gif 图片
    func chatEmotionGifSend(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion, type:MessgeType)
    
}

enum emotionType:Int {
    case emotion
    case santa
    case chick
    case money
    
}

class ChatEmotionView: UIView {

    // emotion model
    private lazy var emotions:[MChatEmotion] = {
       
        return ChatEmotionHelper.getAllEmotions()
    }()
    
    // 第一个gif 图
    private lazy var emotion2: [MChatEmotion] = {
        return ChatEmotionHelper.getAllEmotion2(emotionName:"emotion2", type: ".gif")
    }()
    
    // 第二个gif图
    private lazy var emotion3: [MChatEmotion] = {
        return ChatEmotionHelper.getAllEmotion2(emotionName: "emotion3", type: ".gif")
    }()
    // MARK 代理
    weak var delegate: ChatEmotionViewDelegate?
    
    

    
    private lazy var sendButton: UIButton = { [unowned self] in
        let sendBtn = UIButton(type: .custom)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        sendBtn.backgroundColor = UIColor(red:0.13, green:0.41, blue:0.79, alpha:1.00)
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: .touchUpInside)
        return sendBtn
        }()
    
    private lazy var emotionButton: UIButton = { [unowned self] in
        let emotionBtn = UIButton(type: .custom)
        emotionBtn.backgroundColor = UIColor.white
        emotionBtn.addTarget(self, action: #selector(emotionBtnClick(_:)), for: .touchUpInside)
        emotionBtn.setImage(#imageLiteral(resourceName: "emotion_1"), for: .normal)
        emotionBtn.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        
        
        return emotionBtn
    }()
    private lazy var santaButton:UIButton = { [unowned self] in
        let santa = UIButton.init(type: UIButtonType.custom)
        santa.backgroundColor = UIColor.white
        santa.addTarget(self, action: #selector(santaBtnClick(_:)), for: .touchUpInside)
        santa.setImage(#imageLiteral(resourceName: "santa"), for: .normal)
        santa.backgroundColor = UIColor.white
        return santa
        
        
    }()
    
    private lazy var chickenButton:UIButton = { [unowned self ] in
        let cb = UIButton.init(type: UIButtonType.custom)
        cb.backgroundColor = UIColor.white
        cb.addTarget(self, action: #selector(chickenBtnClick(_:)), for: .touchUpInside)
        cb.setImage(#imageLiteral(resourceName: "chicken"), for: .normal)
        cb.backgroundColor = UIColor.white
        return cb
        
    }()
    
    private lazy var moneyButton:UIButton = { [unowned self] in
        let money = UIButton.init(type: UIButtonType.custom)
        money.backgroundColor = UIColor.white
        money.setImage(#imageLiteral(resourceName: "jing"), for: .normal)
        money.addTarget(self, action: #selector(moneyClick(_:)), for: .touchUpInside)
        
        money.backgroundColor = UIColor.white
        return money
        
    }()
    
    private lazy var bottomView:UIView = { [unowned self] in
        let bottom = UIView.init()
        bottom.backgroundColor = UIColor.white
        bottom.addSubview(self.sendButton)
        bottom.addSubview(self.emotionButton)
        bottom.addSubview(self.moneyButton)
        bottom.addSubview(self.santaButton)
        bottom.addSubview(self.chickenButton)
        
        return bottom
        }()
    
    // first emotionView
    private lazy var emotionView: UICollectionView = { [unowned self] in
        let collectV = UICollectionView(frame: CGRect.zero, collectionViewLayout: ChatHorizontalLayout(column: kEmotionCellNumberOfOneRow, row: kEmotionCellRow))
        collectV.backgroundColor = UIColor.backGroundColor()
        collectV.isPagingEnabled = true
        collectV.dataSource = self
        collectV.delegate = self
        collectV.showsVerticalScrollIndicator = false
        collectV.showsHorizontalScrollIndicator = false
        collectV.register(StaticChatEmotionCell.self, forCellWithReuseIdentifier: StaticChatEmotionCell.identity())
        return collectV
        }()
    // second emotionView
    private lazy var emotion2View: UICollectionView = { [unowned self] in
        let collectV = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: ChatHorizontalLayout(column: MEmotionCellNumberOfOneRow, row: MEmotionCellRow))
        
        collectV.backgroundColor  = UIColor.backGroundColor()
        collectV.isPagingEnabled = true
        collectV.delegate  = self
        collectV.dataSource = self
        collectV.showsVerticalScrollIndicator = false
        collectV.showsHorizontalScrollIndicator = false
        collectV.isHidden = true
        collectV.register(DynamicChatEmotionCell.self, forCellWithReuseIdentifier: DynamicChatEmotionCell.identity())
        return collectV
    }()
    
    // third emotionView
    private lazy var emootion3View: UICollectionView = { [unowned self] in
        let collectV = UICollectionView.init(frame: CGRect.zero, collectionViewLayout:
        ChatHorizontalLayout(column: MEmotionCellNumberOfOneRow, row: MEmotionCellRow))
        
        collectV.backgroundColor  = UIColor.backGroundColor()
        collectV.isPagingEnabled = true
        collectV.delegate  = self
        collectV.dataSource = self
        collectV.showsVerticalScrollIndicator = false
        collectV.showsHorizontalScrollIndicator = false
        collectV.isHidden = true
        collectV.register(DynamicChatEmotionCell.self, forCellWithReuseIdentifier: DynamicChatEmotionCell.identity())
        return collectV
    }()

    lazy var pageControl: UIPageControl = { [unowned self] in
        let pageC = UIPageControl()
        pageC.numberOfPages = self.emotions.count / kEmotionCellNumberOfOnePage + (self.emotions.count % kEmotionCellNumberOfOnePage == 0 ? 0 : 1)
        
        pageC.currentPage = 0
        pageC.pageIndicatorTintColor = UIColor.lightGray
        pageC.currentPageIndicatorTintColor = UIColor.gray
        pageC.backgroundColor = UIColor.backGroundColor()
        return pageC
        }()
    
    override  func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(bottomView)
        self.addSubview(emotionView)
        
        //
        self.addSubview(emotion2View)
        self.addSubview(emootion3View)
        self.addSubview(pageControl)

        
        
        _ = self.bottomView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(38)
        
        _ = self.emotionButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftEqualToView(bottomView)?.widthIs(45)
        
        _ = self.santaButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftSpaceToView(emotionButton,0)?.widthIs(45)
        _ = self.chickenButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftSpaceToView(santaButton,0)?.widthIs(45)
        _ = self.moneyButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftSpaceToView(chickenButton,0)?.widthIs(45)
        
        _ = self.sendButton.sd_layout().topEqualToView(bottomView)?.rightEqualToView(bottomView)?.bottomEqualToView(bottomView)?.widthIs(53)
        _ = self.emotionView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomSpaceToView(self.bottomView,0)
        _ = self.emotion2View.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomSpaceToView(self.bottomView,0)
        _ = self.emootion3View.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomSpaceToView(self.bottomView,0)
        
        _ = self.pageControl.sd_layout().bottomSpaceToView(bottomView,5)?.heightIs(10)?.widthIs(60)?.centerXEqualToView(bottomView)
        
        
        
    }
}


extension ChatEmotionView {
    
    func addBtnClick(_ btn: UIButton) {
        
    }
    
    @objc func emotionBtnClick(_ btn: UIButton) {
        self.changeCollectionCell(type: .emotion)
    }
    @objc func sendBtnClick(_ btn: UIButton) {
         delegate?.chatEmotionViewSend(emotionView: self)
        
        //delegate?.chatEmotionViewSend(emotionView: self)
    }
    @objc func santaBtnClick(_ btn: UIButton) {
        self.changeCollectionCell(type: .santa)
    }
    @objc func moneyClick(_ btn: UIButton){
        self.changeCollectionCell(type: .money)
    }
    
    @objc func chickenBtnClick(_ btn: UIButton){
        self.changeCollectionCell(type: .chick)
    }
    
    func changeCollectionCell(type:emotionType){
        self.emotionButton.backgroundColor = UIColor.white
        self.santaButton.backgroundColor = UIColor.white
        self.moneyButton.backgroundColor = UIColor.white
        self.chickenButton.backgroundColor = UIColor.white
        
        switch type{
        case .emotion:
            self.emotionButton.backgroundColor = UIColor.backGroundColor()
            
            self.emotion2View.isHidden = true
            self.emootion3View.isHidden = true
            self.emotionView.isHidden = false
            
            self.emotionView.contentOffset.x = 0
            
            self.pageControl.numberOfPages = self.emotions.count / kEmotionCellNumberOfOnePage + (self.emotions.count % kEmotionCellNumberOfOnePage == 0 ? 0 : 1)
            self.pageControl.currentPage = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.sendButton.frame = CGRect.init(x: self.bottomView.frame.width-53, y: 0, width: 53, height: self.bottomView.frame.height)
            })
            
        case .santa:
            self.santaButton.backgroundColor = UIColor.backGroundColor()
          
            self.emotion2View.isHidden = false
            self.emotionView.isHidden = true
            self.emootion3View.isHidden = true
            
            self.emotion2View.contentOffset.x = 0
            
            UIView.animate(withDuration: 0.3, animations: {

                self.sendButton.frame = CGRect.init(x: self.bottomView.frame.width, y: 0, width: 53, height: self.bottomView.frame.height)
            })
            self.pageControl.numberOfPages = self.emotion2.count /  MEmotionCellNumberOfOnePage + (self.emotion2.count % MEmotionCellNumberOfOnePage == 0 ? 0 : 1)
            self.pageControl.currentPage = 0
            
        case .chick:
            self.chickenButton.backgroundColor = UIColor.backGroundColor()
            self.emotionView.isHidden = true
            self.emotion2View.isHidden = true
            self.emootion3View.isHidden = false
            
            self.emootion3View.contentOffset.x = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.sendButton.frame = CGRect.init(x: self.bottomView.frame.width, y: 0, width: 53, height: self.bottomView.frame.height)
            })
            self.pageControl.numberOfPages  = self.emotion3.count /  MEmotionCellNumberOfOnePage + (self.emotion3.count % MEmotionCellNumberOfOnePage == 0 ? 0 : 1)
            self.pageControl.currentPage = 0
            
            
        case .money:
            self.moneyButton.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        
        }
    }
}

extension ChatEmotionView: UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == emotionView{
            return emotions.count
        }else if collectionView == emotion2View{
            //
            return emotion2.count
        }else if collectionView == emootion3View{
            return emotion3.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emotionView{
            let emo = emotions[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StaticChatEmotionCell.identity(), for: indexPath) as? StaticChatEmotionCell
            cell?.emotion = emo
            return cell!
        }else if collectionView == emotion2View{
            //
            let emo = emotion2[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DynamicChatEmotionCell.identity(), for: indexPath) as? DynamicChatEmotionCell
            
            cell?.emotion = emo
            return cell!
            
        }else if collectionView == emootion3View{
            let emo = emotion3[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DynamicChatEmotionCell.identity(), for: indexPath) as? DynamicChatEmotionCell
            cell?.emotion = emo
            
            return cell!
        }
        else{
            return UICollectionViewCell.init()
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView  == emotionView{
            let emo = emotions[indexPath.row]
            delegate?.chatEmotionView(emotionView: self, didSelectedEmotion: emo)
            
        }else if collectionView == emotion2View{
            let emo  = emotion2[indexPath.row]
            delegate?.chatEmotionGifSend(emotionView: self, didSelectedEmotion: emo, type:.smallGif)
            
        }else if collectionView == emootion3View{
            let emo = emotion3[indexPath.row]
            delegate?.chatEmotionGifSend(emotionView: self, didSelectedEmotion: emo, type: .bigGif)
        }
    }
    
}

extension ChatEmotionView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
        
    }
}
