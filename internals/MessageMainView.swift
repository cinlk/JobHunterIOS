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
fileprivate let segList:[String] = ["聊天", "看过我", "论坛"]

private class contentCollectionView:UICollectionView {
    
    
    private lazy var dispose = DisposeBag()
    private var vcs:BehaviorRelay<[UIViewController]> = BehaviorRelay<[UIViewController]>.init(value: [])
    
    convenience  init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, vcs:[UIViewController]) {
        self.init(frame: frame, collectionViewLayout: layout)
        self.vcs.accept(vcs)
        
        self.vcs.debug().bind(to: self.rx.items(cellIdentifier: CollectionCellID, cellType: UICollectionViewCell.self)){
            (index, mode, cell ) in
        
            mode.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(mode.view)
            print(cell)
            
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
        return CGSize.init(width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH)
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setBagdge(index:Int, show:Bool){
        if show == false{
            return
        }
        
        let seg = self.subviews[index]
        seg.subviews.forEach { (v) in
            if let label = v as? UILabel{
                label.pp.addDot(color: UIColor.red)
                label.pp.showBadge()
            }
        }
    }
}


class MessageMain: UIViewController {

    
    private var chidVCs:[UIViewController] = []
    
    
    private lazy var collections:UICollectionView = { [unowned self] in
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collv = contentCollectionView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH - GlobalConfig.NavH), collectionViewLayout: layout, vcs:self.chidVCs)
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
    // 论坛消息
    private lazy var forume:ForumMessageVC = ForumMessageVC()

    
    private lazy var dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setViewModel()
        
     }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)
        
        
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
        
    }
    
    

}


extension MessageMain {
    
    private func setViews(){
        
        self.navigationController?.navigationBar.settranslucent(true)
        self.chidVCs.append(contentsOf: [chatVC, visitorVC, forume])

        chidVCs.forEach{
            self.addChild($0)
        }
       
        self.view.addSubview(collections)
        self.navigationItem.titleView = segeMentView
        self.navigationController?.view.backgroundColor = UIColor.white

        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    
    private func setViewModel(){
        self.segeMentView.rx.selectedSegmentIndex .subscribe(onNext: { index in
            
            self.segeMentView.setBagdge(index: index, show: false)
            
            let offsetX = CGFloat(index)*self.collections.frame.width
            self.collections.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: false)
            
        }).disposed(by: self.dispose)
    }

}



extension MessageMain{
    // 监听新未读消息 显示冒泡 TODO
    
}
