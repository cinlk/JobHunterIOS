//
//  CitysView.swift
//  internals
//
//  Created by ke.liang on 2017/8/31.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu
import CoreLocation



class CityViewController:UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    // 定位
    private var activiyIndicator = UIActivityIndicatorView.init()
    
    private lazy var locatcityButton:UIButton = {
        let button = UIButton.init(type: UIButtonType.custom)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.7
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.masksToBounds = true
        button.setTitle("正在定位", for: .normal)
        button.addSubview(activiyIndicator)
        
        return button
    }()

    // 定位
    private lazy var locationM: CLLocationManager = {
        let locationM = CLLocationManager()
        locationM.delegate = self
        locationM.desiredAccuracy = kCLLocationAccuracyBest
        locationM.distanceFilter = kCLLocationAccuracyKilometer
        
        if #available(iOS 8.0, *) {
            locationM.requestWhenInUseAuthorization()
        }
        return locationM
    }()
    
    private lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    
    
    lazy var  errorView:ErrorPageView = {  [unowned self] in
        let eView = ErrorPageView.init(frame: self.view.bounds)
        eView.isHidden = true
        // 再次刷新
        eView.reload = reload
        return eView
    }()
    
    lazy var hub:MBProgressHUD = { [unowned self] in
        
        let  hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.mode = .indeterminate
        hub.label.text = "加载数据"
        hub.removeFromSuperViewOnHide = false
        hub.margin = 10
        hub.label.textColor = UIColor.black
        return hub
        
    }()
    
    //
    var localCity:String = "" {
        willSet{
            locatcityButton.setTitle(newValue, for: .normal)
        }
    }
    
   private var currentLocation:CLLocation!
    
   private var indexs:[String] = []
   private var citys:[String:[String]] = [:] {
        willSet{
            indexs = newValue.keys.sorted().reversed()
        }
       
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择城市"
        self.view.backgroundColor = UIColor.white
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.isScrollEnabled = true
        self.collectionView?.isMultipleTouchEnabled = false
        self.collectionView?.register(CollectionTextCell.self, forCellWithReuseIdentifier: CollectionTextCell.identity())
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "localCity")
        self.collectionView?.register(headerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
       
     
        activiyIndicator.activityIndicatorViewStyle = .gray
        //activiyIndicator.color = UIColor.blue  # 这里有BUG?
        activiyIndicator.hidesWhenStopped = true
        //citys =  getCitys(filename: CITYS)
        self.hub.show(animated: true)
        self.collectionView?.isHidden = true
        self.loadData()
        
        
    
    }
    
    init(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10)
        // 一行放置元素长度计算 =  （元素个数*widht + miniSpace*num）
        layout.itemSize = CGSize(width: (ScreenW - 4*10 - 40)/3 , height: 30)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        super.init(collectionViewLayout: layout)
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView()
        // start fetching location
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activiyIndicator.stopAnimating()
        self.navigationController?.removeCustomerView()
        
        
    }
    override func viewWillLayoutSubviews() {
        _ = activiyIndicator.sd_layout().rightSpaceToView(self.locatcityButton.titleLabel,10)?.topEqualToView(self.locatcityButton.titleLabel)?.bottomEqualToView(self.locatcityButton.titleLabel)?.widthIs(5)
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //第一个为定位城市
        return citys.count + 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            let sectionArray:NSArray = citys[indexs[section - 1 ]]! as NSArray
            return sectionArray.count
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if indexPath.section == 0 {
            // MARK
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "localCity", for: indexPath)
            cell.contentView.addSubview(locatcityButton)
            locatcityButton.frame = cell.contentView.frame
            return cell
            
        }else {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionTextCell.identity(), for: indexPath) as! CollectionTextCell
            
            //cell.name.addTarget(self, action: #selector(click(button:)), for: .touchUpInside)
            
        
            let content =  (citys[indexs[indexPath.section - 1]]! as NSArray).object(at: indexPath.row) as! String
            cell.name.text = content
            
            return cell
        }
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionTextCell
            let city = cell.name.text ?? "全国"
            self.navigationController?.popViewController(animated: true)
            

        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    // 更新visible cell
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //CityCollection. .append(collectionView.cellForItem(at: indexPath))
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! headerView
            if indexPath.section == 0 {
                header.name.text = "定位城市"
            }else{
                header.name.text = indexs[indexPath.section - 1]
            }
            return header
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        return footer
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width,height:20)
        
    }
    
}


extension CityViewController{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            self?.citys = ["GHIJ": ["桂林", "广州", "合肥", "呼和浩特", "海口", "杭州", "湖州", "济南", "济宁", "嘉兴", "江阴"], "热门城市": ["全国", "西安", "深圳", "武汉", "长沙", "苏州", "南京", "上海", "成都", "广州", "杭州", "北京"], "ABCDEF": ["鞍山", "安阳", "保定", "北京", "成都", "重庆", "长沙", "常州", "大连", "东营", "德州", "佛山", "福州"], "KLMN": ["特别长特别长特比长", "昆明", "昆山", "聊城", "廊坊", "洛阳", "连云港", "兰州", "绵阳", "宁波", "南京", "南宁", "南通"]]
            
            DispatchQueue.main.async(execute: {
                // 如果出现错出错
                // showError()
                
                self?.didFinisheLoadData()
            })
        }
        
    }
    
    private func didFinisheLoadData(){
        self.hub.hide(animated: true)
        self.collectionView?.isHidden = false
        self.collectionView?.reloadData()
        
        // 定位城市
        activiyIndicator.startAnimating()
        localCity = "正在定位"
        self.locationCity()
    }
    
    private func showError(){
        self.hub.hide(animated: true)
        self.errorView.isHidden = false
        self.collectionView?.isHidden = true
    }
    
    private func reload(){
        self.hub.show(animated: true)
        self.collectionView?.isHidden = true
    }
}

extension CityViewController: CLLocationManagerDelegate{
    

    func locationCity(){
        locationM.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard let newLocation = locations.last else {return}
        print(newLocation)//<+31.26514482,+121.61259089> +/- 50.00m (speed 0.00 mps / course -1.00) @ 2016/11/14 中国标准时间 14:49:51
        if newLocation.horizontalAccuracy < 0 { return }
        geoCoder.reverseGeocodeLocation(newLocation) { [unowned self] (pls: [CLPlacemark]?, error: Error?) in
            if error == nil {
                guard let pl = pls?.first else {return}
                print(pl.name!)//金京路
                print(pl.locality!)//上海市
                self.localCity = pl.locality!
                self.activiyIndicator.stopAnimating()

               
            }
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        
        // 测试
        self.localCity = "全国"
        activiyIndicator.stopAnimating()
    }
    
}









private class headerView: UICollectionReusableView {
    
    lazy var name:UILabel = {
        let name = UILabel.init()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = UIColor.blue//
        name.textAlignment = .left
        name.font = UIFont.systemFont(ofSize: 12)
        
        return name
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        self.addSubview(name)
        _ = name.sd_layout().topSpaceToView(self,2.5)?.bottomSpaceToView(self,2.5)?.leftSpaceToView(self,5)?.widthIs(120)?.heightIs(15)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


