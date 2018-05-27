//
//  UserGuideViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class UserGuideViewController: UIViewController {

    
    
    private var datas:[UserGuidePageItem] = []
    
    private lazy var flowLayout:UICollectionViewFlowLayout = { [unowned self] in
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        flow.itemSize = self.view.bounds.size
        
        return flow
        
    }()
    
    private lazy var collectionView:UICollectionView = {
        let cv = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        cv.isPagingEnabled = true
        cv.bounces = false
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(UserGuideItemCell.self, forCellWithReuseIdentifier: UserGuideItemCell.identity())
        cv.register(UserGuideLogginCell.self, forCellWithReuseIdentifier: UserGuideLogginCell.identity())
        
        return cv
        
    }()
    
    
    private lazy var continueBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("继续", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return btn
    }()
    
    private lazy var skipBtn:UIButton = {
        
        let btn = UIButton()
        btn.setTitle("跳过", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(lastPage), for: .touchUpInside)

        return btn
    }()
    
    private lazy var pageController:UIPageControl = {
        let pc = UIPageControl.init()
        pc.currentPage = 0
        //pc.tintColor = UIColor.lightGray
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
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageConrollerOriginY = pageController.origin.y
        skipBtnOriginY = skipBtn.origin.y
        continueBtnOriginY = continueBtn.origin.y
        
    }
    
}



extension UserGuideViewController{
    private func setViews(){
        self.view.backgroundColor = UIColor.white
        
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
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index: Int = Int(targetContentOffset.pointee.x / view.frame.width)
        pageController.currentPage = index
        
        if index == datas.count {
            changeView(last: true)
        } else {
            changeView(last: false)
        }
        
    }
    
    
    @objc private func nextPage(){
        
        
        pageController.currentPage += 1
        
        
        
        // 最后登录界面
        if pageController.currentPage == datas.count{
            changeView(last: true)
        }
        
        
        self.collectionView.scrollToItem(at: IndexPath.init(row: pageController.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        
        
        
    }
    
    @objc private func lastPage(){
        
        pageController.currentPage = datas.count
        changeView(last: true)
        
        self.collectionView.scrollToItem(at: IndexPath.init(row: pageController.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    private func changeView(last: Bool){
        // 影藏
       
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            if last{
                
                self.pageController.origin.y = ScreenH + 10
                self.skipBtn.origin.y  = -50
                self.continueBtn.origin.y = -50
                self.skipBtn.isEnabled = false
                self.continueBtn.isEnabled = false
                
            }else{
                // 显示
                self.pageController.origin.y =  self.pageConrollerOriginY
                self.skipBtn.origin.y  = self.skipBtnOriginY
                self.continueBtn.origin.y = self.continueBtnOriginY
                self.skipBtn.isEnabled = true
                self.continueBtn.isEnabled = true
            }
        })
      
        
        
    }
}

extension UserGuideViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == datas.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserGuideLogginCell.identity(), for: indexPath)
            return cell
        }
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserGuideItemCell.identity(), for: indexPath) as? UserGuideItemCell{
            
            cell.mode = datas[indexPath.row]
            return cell
        }
        
        return  UICollectionViewCell()
    }
    
    
    
}

extension UserGuideViewController{
    private func loadData(){
        
        datas.append(UserGuidePageItem(JSON: ["imageName":"finacial", "title":"发现更多", "detail":"在这里发现更多，做你想做的。\nE浏览附近感兴趣的群体，并加入他们。"])!)
        
        datas.append(UserGuidePageItem(JSON: ["imageName":"fly", "title":"更多灵感，更多思路", "detail":"遇见更多志同道合者。\n并与他们保持联系。"])!)
        datas.append(UserGuidePageItem(JSON: ["imageName":"ali", "title":"更加简洁", "detail":"比以前更加简洁\n为你打造更加便捷的使用体验，更加轻松的找到你想要的。"])!)
        
        
        pageController.numberOfPages = datas.count + 1
        collectionView.reloadData()
        
        
    }
}
