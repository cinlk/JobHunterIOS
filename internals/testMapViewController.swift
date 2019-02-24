////
////  testMapViewController.swift
////  internals
////
////  Created by ke.liang on 2019/2/13.
////  Copyright © 2019 lk. All rights reserved.
////
//
//import UIKit
//
//class testMapViewController: UIViewController {
//    
//    
//    private lazy var locationRepresnt: MAUserLocationRepresentation = {
//        let location = MAUserLocationRepresentation.init()
//        location.showsAccuracyRing = true
//        location.showsHeadingIndicator = false
//        location.fillColor = UIColor.red
//        location.strokeColor = UIColor.blue
//        location.lineWidth = 2
//        location.enablePulseAnnimation = false
//        location.locationDotBgColor = UIColor.green
//        location.locationDotFillColor = UIColor.gray
//        return location
//        
//    }()
//    
//    private lazy var mapView:MAMapView = {
//        let map = MAMapView.init(frame: CGRect.zero)
//        map.delegate = self
//        map.showsUserLocation = true
//        map.userTrackingMode = .follow
//        map.update(self.locationRepresnt)
//        //map.scaleSize
//        map.isShowsIndoorMap = true
//        map.isRotateEnabled = false
//        //print(map.userLocation.location.coordinate)
//        return map
//    }()
//    // 中间圆点view
//    private lazy var centerPivot:UIImageView = {
//        let iv = UIImageView.init(frame: CGRect.zero)
//        iv.contentMode = .scaleAspectFit
//        iv.image = #imageLiteral(resourceName: "center_location")
//        iv.clipsToBounds = true
//        return iv
//    }()
//    
//    private lazy var tapGesture:UITapGestureRecognizer = {
//        let tap = UITapGestureRecognizer.init()
//        tap.addTarget(self, action: #selector(userLocation(gesture:)))
//        return tap
//    }()
//    
//    private lazy var coverUserLocation:UIView = {
//        let view = UIView.init(frame: CGRect.zero)
//        view.backgroundColor = UIColor.red
//        view.isUserInteractionEnabled = true
//        view.addGestureRecognizer(tapGesture)
//        return view
//    }()
//    
//    // 宣讲会
//    private lazy var meetingBtn:UIButton = {
//        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 60))
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        btn.setTitleColor(UIColor.black, for: .normal)
//        btn.setPositionWith(image: #imageLiteral(resourceName: "car").changesize(size: CGSize.init(width: 35, height: 35), renderMode: .alwaysOriginal), title: "附近宣讲会", titlePosition: UIView.ContentMode.bottom
//            , additionalSpacing: 0, state: .normal)
//        btn.backgroundColor = UIColor.clear
//        return btn
//    }()
//    
//    // 公司
//    private lazy var companyBtn:UIButton = {
//        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 60))
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        btn.setTitleColor(UIColor.black, for: .normal)
//        btn.setPositionWith(image: #imageLiteral(resourceName: "icons8-star-filled-40").changesize(size: CGSize.init(width: 35, height: 35), renderMode: .alwaysOriginal), title: "附近公司", titlePosition: UIView.ContentMode.bottom
//            , additionalSpacing: 0, state: .normal)
//        btn.backgroundColor = UIColor.clear
//        return btn
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.view.addSubview(mapView)
//        mapView.addSubview(coverUserLocation)
//        mapView.addSubview(centerPivot)
//        mapView.addSubview(meetingBtn)
//        mapView.addSubview(companyBtn)
//        
//        _ = mapView.sd_layout()?.topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
//        
//        _ = coverUserLocation.sd_layout()?.leftSpaceToView(mapView, 10)?.bottomSpaceToView(mapView, 50)?.heightIs(30)?.widthIs(30)
//        _ = centerPivot.sd_layout()?.centerXEqualToView(mapView)?.centerYEqualToView(mapView)?.widthIs(20)?.autoHeightRatio(1.5)
//        _ = meetingBtn.sd_layout()?.rightSpaceToView(mapView,20)?.bottomSpaceToView(mapView,80)?.widthIs(50)?.heightIs(60)
//        _ = companyBtn.sd_layout()?.topSpaceToView(meetingBtn,5)?.rightEqualToView(meetingBtn)?.widthRatioToView(meetingBtn,1)?.heightRatioToView(meetingBtn,1)
//        
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//
//extension testMapViewController:MAMapViewDelegate{
//    
//    func mapViewRegionChanged(_ mapView: MAMapView!) {
//        
//        print(mapView.centerCoordinate)
//        //mapView.centerCoordinate
//    }
//    
//    
//    @objc private func userLocation(gesture:UITapGestureRecognizer){
//        if gesture.state == .ended{
//            
//            self.mapView.setCenter(self.mapView.userLocation.location.coordinate, animated: true)
//        }
//    }
//}
