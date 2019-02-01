//
//  UserGuideViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

fileprivate class CollectionView:UICollectionView{
    
    private lazy var flowLayout:UICollectionViewFlowLayout = { [unowned self] in
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        flow.itemSize = self.bounds.size
        
        return flow
        
    }()
    
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.collectionViewLayout = flowLayout
        self.isPagingEnabled = true
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.register(UserGuideItemCell.self, forCellWithReuseIdentifier: UserGuideItemCell.identity())
        self.register(UserGuideLogginCell.self, forCellWithReuseIdentifier: UserGuideLogginCell.identity())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    
}


fileprivate class clickBtn:UIButton {
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(type: UIButton.ButtonType, title:String) {
        self.init(type: type)
        self.setTitle(title, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitleColor(UIColor.orange, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UserGuideViewController: UIViewController, UICollectionViewDelegate {

    private var datas:[GuideItems] = []
    
    private var dispose: DisposeBag = DisposeBag.init()
    
   
    private lazy var collectionView:UICollectionView = {
        let cv = CollectionView.init(frame: self.view.bounds, collectionViewLayout: UICollectionViewLayout.init())
        cv.rx.setDelegate(self).disposed(by: dispose)
        return cv
        
    }()
    
    
    private lazy var continueBtn:UIButton = {
        let btn =  clickBtn.init(type: UIButton.ButtonType.custom, title: "继续")
        return btn
    }()
    
    private lazy var skipBtn:UIButton = {
        
        let btn = clickBtn.init(type: UIButton.ButtonType.custom, title: "跳过")
        return btn
    }()
    
    private lazy var pageController:UIPageControl = {
        let pc = UIPageControl.init()
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = UIColor.orange
        pc.contentMode = .center
        pc.pageIndicatorTintColor = UIColor.lightGray
        return pc
    }()
    
    
    private var pageConrollerOriginY:CGFloat = 0
    private var skipBtnOriginY:CGFloat = 0
    private var continueBtnOriginY:CGFloat = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setData()
        setViewModel()
        
        // Do any additional setup after loading the view.
    }


    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = UIColor.white
        pageConrollerOriginY = pageController.origin.y
        skipBtnOriginY = skipBtn.origin.y
        continueBtnOriginY = continueBtn.origin.y
        
        // 如果没有获取到hguide数据，页面渲染
        self.changeView(last: self.pageController.currentPage == self.datas.count)
        
    }
    
}



extension UserGuideViewController{
    
    private func setViews(){
        
        
        self.view.addSubview(collectionView)
        self.view.addSubview(continueBtn)
        self.view.addSubview(pageController)
        self.view.addSubview(skipBtn)
        
        _ = continueBtn.sd_layout().rightSpaceToView(self.view,20)?.topSpaceToView(self.view, 40)?.widthIs(60)?.heightIs(30)
        _ = skipBtn.sd_layout().topEqualToView(continueBtn)?.bottomEqualToView(continueBtn)?.widthRatioToView(continueBtn,1)?.leftSpaceToView(self.view,20)
        
        _ = pageController.sd_layout().bottomSpaceToView(self.view,40)?.widthIs(120)?.heightIs(20)?.centerXEqualToView(self.view)
        
       
        
    }
    
    
}


extension UserGuideViewController{
    
    
    private func setViewModel(){
        
        // rx button
        self.continueBtn.rx.tap.asDriver().drive(onNext: {
            self.pageController.currentPage += 1
            // 最后登录界面
            self.changeView(last: self.pageController.currentPage == self.datas.count)
            
            
        }).disposed(by: dispose)
        
        
        
        self.skipBtn.rx.tap.asDriver().drive(onNext: {
            self.pageController.currentPage = self.datas.count
            self.changeView(last: true)
           
        }).disposed(by: dispose)
        
        
        
        // rx collection data
        self.collectionView.rx.willEndDragging.asDriver().drive(onNext: { (arg0) in
            let (_, targetContentOffset) = arg0
            
            let index: Int = Int(targetContentOffset.pointee.x / self.view.frame.width)
            self.pageController.currentPage = index
            self.changeView(last: index == self.datas.count)
        }).disposed(by: dispose)
        
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, GuideItems>>(configureCell: { (dataSource, cv, indexPath, element) -> UICollectionViewCell in
            
            if indexPath.row == self.datas.count {
                let cell = cv.dequeueReusableCell(withReuseIdentifier: UserGuideLogginCell.identity(), for: indexPath)
                return cell
            }
            
            
            if let cell = cv.dequeueReusableCell(withReuseIdentifier: UserGuideItemCell.identity(), for: indexPath) as? UserGuideItemCell{
                
                cell.mode = element
                return cell
            }
            
            return UICollectionViewCell.init()
            
            
        })
        
    
        // 这里多一个默认数据
        Observable.just([SectionModel.init(model: "", items: self.datas + [GuideItems(JSON: ["image_url":"fake", "title":"fake", "detail":"fake"])!])]).bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: dispose)
        
    }
    
    
    private func changeView(last: Bool){
        self.collectionView.scrollToItem(at: IndexPath.init(row: self.pageController.currentPage, section: 0), at: .centeredHorizontally, animated: true)

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
           
            self.pageController.origin.y = last ?  GlobalConfig.ScreenH + 10 : self.pageConrollerOriginY
            self.skipBtn.origin.y  = last ? -50 : self.skipBtnOriginY
            self.continueBtn.origin.y = last ? -50 : self.continueBtnOriginY
            self.skipBtn.isEnabled = !last
            self.continueBtn.isEnabled = !last
        })
        
    }
}


extension UserGuideViewController{
    
    private func setData(){
        
        if let data = SingletoneClass.shared.guidanceData{
            self.datas = data.body!
        }
        // 最后一个cell 页面单独显示
        self.pageController.numberOfPages = datas.count + 1
       
    }
}
