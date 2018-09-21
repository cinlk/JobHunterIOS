//
//  ChatEmotionView.swift
//  internals
//
//  Created by ke.liang on 2017/10/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


protocol ChatEmotionViewDelegate: class {
    // 输入emotion到textview
    func chatEmotionView(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion)
    // 发送emotion
    func chatEmotionViewSend(emotionView: ChatEmotionView)
    // 发送gif 图片
    func chatEmotionGifSend(emotionView: ChatEmotionView, didSelectedEmotion emotion: MChatEmotion, type:MessgeType)
    
}


fileprivate let buttonH:CGFloat = 38


class ChatEmotionView: UIView {

 
    // MARK 代理
    weak var delegate: ChatEmotionViewDelegate?
    

  
  
    private lazy var datas:[[MChatEmotion]] = {
        var data:[[MChatEmotion]] = []
        data.append(ChatEmotionHelper.getAllEmotions())
        data.append(ChatEmotionHelper.getAllEmotion2(emotionName:"emotion2", type: ".gif", vType: .smallGif))
        data.append(ChatEmotionHelper.getAllEmotion2(emotionName: "emotion3", type: ".gif", vType: .bigGif))
        
        return data
        
    }()
    
    
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
        emotionBtn.addTarget(self, action: #selector(changeCollectionCell(_:)), for: .touchUpInside)
        emotionBtn.setImage(#imageLiteral(resourceName: "emotion_1"), for: .normal)
        emotionBtn.tag = 0
        emotionBtn.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        
        
        return emotionBtn
    }()
    private lazy var santaButton:UIButton = { [unowned self] in
        let santa = UIButton.init(type: UIButton.ButtonType.custom)
        santa.backgroundColor = UIColor.white
        santa.addTarget(self, action: #selector(changeCollectionCell(_:)), for: .touchUpInside)
        santa.setImage(#imageLiteral(resourceName: "santa"), for: .normal)
        santa.tag = 1
        santa.backgroundColor = UIColor.white
        return santa
        
        
    }()
    
    private lazy var chickenButton:UIButton = { [unowned self ] in
        let cb = UIButton.init(type: UIButton.ButtonType.custom)
        cb.backgroundColor = UIColor.white
        cb.addTarget(self, action: #selector(changeCollectionCell(_:)), for: .touchUpInside)
        cb.setImage(#imageLiteral(resourceName: "chicken"), for: .normal)
        cb.tag = 2
        cb.backgroundColor = UIColor.white
        return cb
        
    }()
    
    private lazy var moneyButton:UIButton = { [unowned self] in
        let money = UIButton.init(type: UIButton.ButtonType.custom)
        money.backgroundColor = UIColor.white
        money.setImage(#imageLiteral(resourceName: "jing"), for: .normal)
        money.tag = 3
        money.addTarget(self, action: #selector(changeCollectionCell(_:)), for: .touchUpInside)
        
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
    
   
    
    // collections
    private lazy var collectView:UICollectionView = { [unowned self] in
        
        let layout  = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize.init(width: ScreenW, height: self.bounds.height - buttonH)
        
        let coll = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        coll.register(baseEmotionView.self, forCellWithReuseIdentifier: baseEmotionView.identity())
        coll.register(gifEmotionView.self, forCellWithReuseIdentifier: gifEmotionView.identity())
        
        
        coll.delegate = self
        coll.dataSource = self
        coll.bounces = false
        coll.showsHorizontalScrollIndicator = false
        coll.isPagingEnabled = true
        
        return coll
        
    }()


    
    override  func layoutSubviews() {
        super.layoutSubviews()
        self.isUserInteractionEnabled = true
        self.addSubview(bottomView)
        self.addSubview(collectView)
        
        _ = self.bottomView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(buttonH)
        
        _ = self.emotionButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftEqualToView(bottomView)?.widthIs(45)
        
        _ = self.santaButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftSpaceToView(emotionButton,0)?.widthIs(45)
        _ = self.chickenButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftSpaceToView(santaButton,0)?.widthIs(45)
        _ = self.moneyButton.sd_layout().topEqualToView(bottomView)?.bottomEqualToView(bottomView)?.leftSpaceToView(chickenButton,0)?.widthIs(45)
        
        _ = self.sendButton.sd_layout().topEqualToView(bottomView)?.rightEqualToView(bottomView)?.bottomEqualToView(bottomView)?.widthIs(53)
        
        _ = collectView.sd_layout().bottomSpaceToView(bottomView,0)?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)
        
    
        
        
    }
}


extension ChatEmotionView {
    

    
    @objc private func sendBtnClick(_ btn: UIButton) {
         delegate?.chatEmotionViewSend(emotionView: self)
    }
   
    
    
    
   @objc private func changeCollectionCell(_ sender: UIButton ){
    
    
        let offsetX:CGFloat =  self.collectView.frame.width * CGFloat(sender.tag)
    
        self.collectView.contentOffset = CGPoint.init(x: offsetX, y: 0)

        switch sender.tag{
        case 0:
            
            UIView.animate(withDuration: 0.3, animations: {
                self.sendButton.frame = CGRect.init(x: self.bottomView.frame.width-53, y: 0, width: 53, height: self.bottomView.frame.height)
            })
        
        default:
            UIView.animate(withDuration: 0.3, animations: {
                
                self.sendButton.frame = CGRect.init(x: self.bottomView.frame.width, y: 0, width: 53, height: self.bottomView.frame.height)
            })
            
        }
    
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectView{
            let offsetX = scrollView.contentOffset.x
            if offsetX > 0{
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.sendButton.frame = CGRect.init(x: self.bottomView.frame.width, y: 0, width: 53, height: self.bottomView.frame.height)
                })
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.sendButton.frame = CGRect.init(x: self.bottomView.frame.width-53, y: 0, width: 53, height: self.bottomView.frame.height)
                })
                    
            }
        }
    }
}

extension ChatEmotionView: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectView.dequeueReusableCell(withReuseIdentifier: baseEmotionView.identity(), for: indexPath) as! baseEmotionView
            cell.emotions = datas[0]
            // 插入标签到输入框
            cell.insertEmotion = { emo in
                self.delegate?.chatEmotionView(emotionView: self, didSelectedEmotion: emo)
                
            }
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gifEmotionView.identity(), for: indexPath) as! gifEmotionView
            cell.emotions = datas[indexPath.row]
            // 区分不同类型 gif
            cell.sendGif = { emo in
                self.delegate?.chatEmotionGifSend(emotionView: self, didSelectedEmotion: emo, type: emo.type)
            }
            return cell
        }
       
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}


