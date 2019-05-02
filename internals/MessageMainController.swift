//
//  MessageMain.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

fileprivate let CollectionCellID = "cell"
fileprivate let segList:[String] = ["聊天", "看过我", "系统消息"]

private class contentCollectionView:UICollectionView {
    
    
    private lazy var dispose = DisposeBag()
    private var vcs:BehaviorRelay<[UIViewController]> = BehaviorRelay<[UIViewController]>.init(value: [])
    
    convenience  init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, vcs:[UIViewController]) {
        self.init(frame: frame, collectionViewLayout: layout)
        self.vcs.accept(vcs)
        
        self.vcs.debug().bind(to: self.rx.items(cellIdentifier: CollectionCellID, cellType: UICollectionViewCell.self)){
            (index, mode, cell ) in
        
            mode.view.frame = cell.contentView.frame
            cell.contentView.addSubview(mode.view)
            //print(cell)
            
        }.disposed(by: self.dispose)
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionCellID)
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        self.isScrollEnabled  = false
        self.bounces = false
        
        self.rx.setDelegate(self).disposed(by: self.dispose)
        self.scrollsToTop = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    
}

extension contentCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height:  collectionView.frame.height)
    }
    
    
}


private class topSegMentView:UISegmentedControl{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.insertSegment(withTitle: segList[0], at: 0, animated: false)
        self.insertSegment(withTitle: segList[1], at: 1, animated: false)
        self.insertSegment(withTitle: segList[2], at: 2, animated: false)
        self.selectedSegmentIndex = 0
        self.backgroundColor = UIColor.orange
        self.tintColor = UIColor.white
        
        // 监听显示 message 的 badge通知
        _ = NotificationCenter.default.rx.notification(NotificationName.messageBadge, object: nil).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (notify) in
            
            // 查询 所有的message badge
            let total =  DBFactory.shared.getConversationDB().getAllUnreadCount()
            
            total > 0 ? self?.setBagdge(index: 0, show: true): self?.setBagdge(index: 0, show: false)
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        // 监听 显示系统消息的 badge 通知
        _ = NotificationCenter.default.rx.notification(NotificationName.systemMessageBadge, object: nil).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (notify) in
            if HasForumReply2Me.has || HasNewSystemMessage.has || HasNewThumbUpMessage.has{
                self?.setBagdge(index: 2, show: true)
            }else{
                self?.setBagdge(index: 2, show: false)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setBagdge(index:Int, show:Bool){
        
        
        self.subviews.forEach { (v) in
            v.subviews.forEach({ (sv) in
                
                if let label = sv as? UILabel, label.text ==  segList[index] {
                    if show{
                        label.pp.addDot(color: UIColor.red)
                        label.pp.showBadge()
                    }else{
                        label.pp.hiddenBadge()
                        
                    }
                }
            })
           
        }
    }
}


class MessageMainController: UIViewController {

    
    private var chidVCs:[UIViewController] = []
    
    
    private var vm: MessageViewModel =  MessageViewModel.shared
    
    private lazy var collections:UICollectionView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collv = contentCollectionView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH), collectionViewLayout: layout, vcs:self.chidVCs)
        collv.contentInsetAdjustmentBehavior = .never 
        return collv
    }()
    
    // 切换菜单
    private lazy var segeMentView:topSegMentView = {
        let sg = topSegMentView.init(frame: CGRect.zero)
        //sg.addTarget(self, action: #selector(switchItem(_:)), for: .valueChanged)
        return sg
        
    }()
    
    
    // 聊天vc
    private lazy var chatVC:ChatListViewController = ChatListViewController()
    // 看过我vc
    private lazy var visitorVC:MyVisitor = MyVisitor()
    // 系统消息
    private lazy var system:SystemMessageViewController = SystemMessageViewController()

    
    private lazy var dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setViewModel()
        
        
     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)
        
        self.showUnreadMessageBadge()
        
    
    
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 监听推送的消息类型 来更新对应的数据 TODO
        if let userId = GlobalUserInfo.shared.getId(){
            // 检查是否有最新的 访问者
            self.vm.existVisitor.onNext(userId)
            // 检查是否有最新的系统 通知
            self.vm.existNewSystemMessage.onNext(userId)
            // 检查是否有最新的赞
            self.vm.existThumbUpMessage.onNext(userId)
            // 检查是否有最新回复我的
            self.vm.existReply2Me.onNext(userId)
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
        
    }
    
   
    
    
    deinit {
        print("deinit MessageMainVC \(String.init(describing: self))")
    }
    

}


extension MessageMainController {
    
    private func setViews(){
        
        self.navigationController?.navigationBar.settranslucent(true)
        self.chidVCs.append(contentsOf: [chatVC, visitorVC, system])

        chidVCs.forEach{ [weak self] in
            self?.addChild($0)
        }
       
        self.view.addSubview(collections)
        self.navigationItem.titleView = segeMentView
        self.navigationController?.view.backgroundColor = UIColor.white

        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    
    private func setViewModel(){
        self.segeMentView.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] index in
            guard let `self` = self else{
                return
            }
            
            //self.segeMentView.setBagdge(index: index, show: false)
            
            let offsetX = CGFloat(index)*self.collections.frame.width
            self.collections.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: false)
            
            // 选择了看过我 更新时间
            if index == 1, let userId = GlobalUserInfo.shared.getId(){
                self.vm.updateVisitorTime.onNext(userId)
                self.segeMentView.setBagdge(index: 1, show: false)
                // 刷新看过我数据
                NotificationCenter.default.post(name: NotificationName.visitor, object: nil)
            }
            
        }).disposed(by: self.dispose)
        
        //
        self.vm.existNewVisitor.asDriver(onErrorJustReturn: false).drive(onNext: { [weak self] exist in
            self?.segeMentView.setBagdge(index: 1, show: exist)
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        //  系统消息的红点 依赖 系统消息 ，赞 和 看过我的状态 TODO
        self.vm.newSystemMessage.asDriver(onErrorJustReturn: false).drive(onNext: {  (exist) in
//            if exist{
//                self?.segeMentView.setBagdge(index: 2, show: true)
//            }
            // 通知发送给 系统消息cell, 第一次通知发送 但是vc 还未初始化, 消息不存在??
            
            HasNewSystemMessage.has = exist
            if exist{
                NotificationCenter.default.post(name: NotificationName.systemMessage, object: nil, userInfo: ["system" : exist])
            }
            
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
    
        
        self.vm.newThumbUpMessage.asDriver(onErrorJustReturn: true).drive(onNext: { (exist) in
            HasNewThumbUpMessage.has = exist
            if exist{
                NotificationCenter.default.post(name: NotificationName.systemMessage, object: nil, userInfo: ["thumbUp": exist])
            }
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        self.vm.newReply2MeMessage.asDriver(onErrorJustReturn: false).drive(onNext: { (exist) in
            HasForumReply2Me.has = exist
            if exist{
                NotificationCenter.default.post(name: NotificationName.systemMessage, object: nil, userInfo: ["reply": exist])
            }
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        
    }

}



extension MessageMainController{
    // 监听新未读消息 显示冒泡 TODO
    
    private func showUnreadMessageBadge(){
        let messageBadge = DBFactory.shared.getConversationDB().getAllUnreadCount()
        messageBadge > 0 ? self.segeMentView.setBagdge(index: 0, show: true) :
            self.segeMentView.setBagdge(index: 0, show: false)
    }
}
