//
//  ChatEmotionView.swift
//  internals
//
//  Created by ke.liang on 2017/10/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

fileprivate let kEmotionCellNumberOfOneRow = 8
fileprivate let kEmotionCellRow = 3
fileprivate let kEmotionCellNumberOfOnePage = kEmotionCellRow * kEmotionCellNumberOfOneRow
fileprivate let kEmotionViewHeight: CGFloat = 162
//
fileprivate let MEmotionCellNumberOfOneRow = 4
fileprivate let MEmotionCellRow = 2
fileprivate let MEmotionCellNumberOfOnePage  = MEmotionCellRow * MEmotionCellNumberOfOneRow
fileprivate let MEmotionViewHeight =  162

fileprivate let kEmotionCellID = "emotionCellID"


protocol ChatEmotionViewDelegate: NSObjectProtocol {
    func chatEmotionView(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion)
    func chatEmotionViewSend(emotionView: ChatEmotionView)
}

class ChatEmotionView: UIView {

    // emotion model
    lazy var emotions:[MChatEmotion] = {
       
        return ChatEmotionHelper.getAllEmotions()
    }()
    
    // MARK 代理
    weak var delegate: ChatEmotionViewDelegate?
    
    
    lazy var bottomView:UIView = { [unowned self] in
        let bottom = UIView.init()
        bottom.backgroundColor = UIColor.lightGray
        bottom.addSubview(self.sendButton)
        bottom.addSubview(self.emotionButton)
        bottom.addSubview(self.moneyButton)
        bottom.addSubview(self.santaButton)
        
        return bottom
    }()
    
    lazy var sendButton: UIButton = { [unowned self] in
        let sendBtn = UIButton(type: .custom)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        sendBtn.backgroundColor = UIColor(red:0.13, green:0.41, blue:0.79, alpha:1.00)
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.addTarget(self, action: #selector(sendBtnClick(_:)), for: .touchUpInside)
        return sendBtn
        }()
    
    lazy var emotionButton: UIButton = {
        let emotionBtn = UIButton(type: .custom)
        emotionBtn.backgroundColor = UIColor.white
        emotionBtn.addTarget(self, action: #selector(emotionBtnClick(_:)), for: .touchUpInside)
        emotionBtn.setImage(#imageLiteral(resourceName: "smileEmotion"), for: .normal)
        return emotionBtn
    }()
    lazy var santaButton:UIButton = {
        let santa = UIButton.init(type: UIButtonType.custom)
        santa.backgroundColor = UIColor.white
       // santa.addTarget(self, action: #selector(santaBtnClick(_:)), for: .touchUpInside)
        santa.setImage(#imageLiteral(resourceName: "santa"), for: .normal)
        return santa
        
    }()
    
    lazy var moneyButton:UIButton = {
        let money = UIButton.init(type: UIButtonType.custom)
        money.backgroundColor = UIColor.white
        money.setImage(#imageLiteral(resourceName: "money"), for: .normal)
        return money
        
    }()
    
    lazy var emotionView: UICollectionView = { [unowned self] in
        let collectV = UICollectionView(frame: CGRect.zero, collectionViewLayout: LXFChatHorizontalLayout(column: kEmotionCellNumberOfOneRow, row: kEmotionCellRow))
        collectV.backgroundColor = UIColor.white
        collectV.isPagingEnabled = true
        collectV.dataSource = self
        collectV.delegate = self
        return collectV
        }()

//    lazy var emotionView: UIView = {
//        let view = UIView.init()
//        view.backgroundColor = UIColor.white
//        return view
//
//    }()
    
    lazy var pageControl: UIPageControl = { [unowned self] in
        let pageC = UIPageControl()
        pageC.numberOfPages = self.emotions.count / kEmotionCellNumberOfOnePage + (self.emotions.count % kEmotionCellNumberOfOnePage == 0 ? 0 : 1)
        
        pageC.currentPage = 0
        pageC.pageIndicatorTintColor = UIColor.lightGray
        pageC.currentPageIndicatorTintColor = UIColor.gray
        pageC.backgroundColor = UIColor.white
        return pageC
        }()
    
    override  func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(bottomView)
        self.addSubview(emotionView)
        self.addSubview(pageControl)
        
        
        _ = self.bottomView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(38)
        
        _ = self.emotionButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftEqualToView(bottomView)?.widthIs(45)
        
        _ = self.santaButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftSpaceToView(emotionButton,0)?.widthIs(45)
        _ = self.moneyButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftSpaceToView(santaButton,0)?.widthIs(45)
        
        _ = self.sendButton.sd_layout().topEqualToView(bottomView)?.rightEqualToView(bottomView)?.bottomEqualToView(bottomView)?.widthIs(53)
        _ = self.emotionView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.heightIs(162)
        _ = self.pageControl.sd_layout().bottomSpaceToView(bottomView,5)?.heightIs(10)?.widthIs(60)?.centerXEqualToView(bottomView)
        
        
        //注册emotionCell
        emotionView.register(ChatEmotionCell.self, forCellWithReuseIdentifier: kEmotionCellID)
    }
}


extension ChatEmotionView {
    func addBtnClick(_ btn: UIButton) {
        
    }
    func emotionBtnClick(_ btn: UIButton) {
       
    }
    func sendBtnClick(_ btn: UIButton) {
         delegate?.chatEmotionViewSend(emotionView: self)
        
        //delegate?.chatEmotionViewSend(emotionView: self)
    }
}

extension ChatEmotionView: UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let emo = emotions[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmotionCellID, for: indexPath) as? ChatEmotionCell
        cell?.emotion = emo
        return cell!
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emo = emotions[indexPath.row]
        delegate?.chatEmotionView(emotionView: self, didSelectedEmotion: emo)
        
    }
    
}

extension ChatEmotionView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let page = contentOffset / scrollView.frame.size.width + (Int(contentOffset) % Int(scrollView.frame.size.width) == 0 ? 0 : 1)
        pageControl.currentPage = Int(page)
        
    }
}
