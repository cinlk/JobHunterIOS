//
//  LocationMessageCell.swift
//  internals
//
//  Created by ke.liang on 2019/4/11.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

fileprivate let mapSize = CGSize.init(width: 160, height: 120)


@objcMembers class LocationMessageCell: UITableViewCell {

    
    // 回调方法显示地图
   
    var navigate2Map:((_:LocationMessage?)->Void)?
    
    private lazy var avartar:UIImageView = {
        var v = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.AvatarSize.width, height: GlobalConfig.AvatarSize.height))
        v.contentMode = .scaleToFill
        v.clipsToBounds = true
        return v
        
    }()
    
    private lazy var address:UILabel = {
        let l = UILabel.init()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textAlignment = NSTextAlignment.left
        l.textColor = UIColor.black
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    private lazy var tapMap:UITapGestureRecognizer  = { [unowned self] in
        let tap = UITapGestureRecognizer.init()
        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: #selector(showMap(_:)))
        return tap
    }()
    
 
    
    // 地图位置截图image
    private lazy var  mapImage: UIImageView = { [unowned self] in
        let imageV = UIImageView.init()
        imageV.contentMode = UIView.ContentMode.scaleAspectFill
        imageV.clipsToBounds = true
        imageV.isUserInteractionEnabled = true
        imageV.addGestureRecognizer(tapMap)
        return imageV
    }()
    
    // 包裹标签和地图内容的view
    private lazy var wrapperView:UIView = { [unowned self] in 
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: mapSize.width, height: mapSize.height))
        v.backgroundColor = UIColor.white
        v.isUserInteractionEnabled = true
        v.addSubview(address)
        v.addSubview(mapImage)
        _ = self.address.sd_layout()?.leftSpaceToView(v, 5)?.rightEqualToView(v)?.topEqualToView(v)?.autoHeightRatio(0)
       _ = self.mapImage.sd_layout()?.leftEqualToView(v)?.rightEqualToView(v)?.topSpaceToView(self.address,0)?.bottomEqualToView(v)
        
        self.address.setMaxNumberOfLinesToShow(2)
        
        return v
    }()

    
    private lazy var coordinate:CLLocation = CLLocation.init(latitude: 0, longitude: 0)
    
    dynamic var mode: LocationMessage?{
        didSet{
            guard let m = mode else{
                avartar.isHidden = true
                return
            }
            
            if let url = GlobalUserInfo.shared.getIcon(){
                self.avartar.kf.indicatorType = .activity
                self.avartar.kf.setImage(with: Source.network(url), placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            
            // 背景图片拉伸
            let stretchInset = UIEdgeInsets(top: 30, left: 28, bottom: 23, right: 28)
            var stretchImage:UIImage!
            var bubbleMaskImage:UIImage!
            
            self.address.text = m.address
            // 设置地图属性
            if (self.coordinate.coordinate.latitude != m.latitude || self.coordinate.coordinate.longitude != m.longitude ) {
                self.coordinate = CLLocation.init(latitude: m.latitude!, longitude: m.longitude!)
                
                
                let coords = CLLocationCoordinate2D(latitude: m.latitude!, longitude:m.longitude!)
                let distanceInMeters: Double = 300
                
                let options = MKMapSnapshotter.Options()
                options.region = MKCoordinateRegion(center: coords, latitudinalMeters: distanceInMeters, longitudinalMeters: distanceInMeters)
                options.size = mapSize
                options.scale = UIScreen.main.scale
                
        
                let bgQueue = DispatchQueue.global(qos: .background)
                let pin = MKPinAnnotationView()

                // 位置截图
                let snapShotter = MKMapSnapshotter(options: options)
                snapShotter.start(with: bgQueue, completionHandler: { [weak self] (snapshot, error) in
                    guard error == nil else {
                        return
                    }
                    
                    if let snapShotImage = snapshot?.image, let coordinatePoint = snapshot?.point(for: coords), let pinImage = pin.image {
                        UIGraphicsBeginImageContextWithOptions(snapShotImage.size, true, snapShotImage.scale)
                        snapShotImage.draw(at: CGPoint.zero)
                        
                        let fixedPinPoint = CGPoint(x: coordinatePoint.x - pinImage.size.width / 2, y: coordinatePoint.y - pinImage.size.height)
                        pinImage.draw(at: fixedPinPoint)
                        let mapImage = UIGraphicsGetImageFromCurrentImageContext()
 
                        DispatchQueue.main.async {
                            self?.mapImage.image = mapImage
                        }
                        UIGraphicsEndImageContext()
                    }
                })
                
                
            }
            
 
            
            // 自己发的消息
            if m.senderId == GlobalUserInfo.shared.getId(){
                avartar.frame = CGRect.init(x: GlobalConfig.ScreenW - 45 - 5, y: 5, width: GlobalConfig.AvatarSize.width, height: GlobalConfig.AvatarSize.height)
                
                stretchImage = UIImage.init(named: "senderImageMask")
                bubbleMaskImage = stretchImage?.resizableImage(withCapInsets: stretchInset, resizingMode: .stretch)
                
                _ = wrapperView.sd_layout()?.rightSpaceToView(self.avartar, 10)?.widthIs(mapSize.width)?.topEqualToView(self.avartar)?.heightIs(mapSize.height)
                
                
            }else{
                avartar.frame = CGRect.init(x: 5, y: 5, width: GlobalConfig.AvatarSize.width, height: GlobalConfig.AvatarSize.height)
                
                stretchImage = UIImage.init(named: "receiverImageMask")
                bubbleMaskImage = stretchImage?.resizableImage(withCapInsets: stretchInset, resizingMode: .stretch)
                
                 _ = wrapperView.sd_layout()?.leftSpaceToView(self.avartar, 10)?.widthIs(mapSize.width)?.topEqualToView(self.avartar)?.heightIs(mapSize.height)
                
            }
 
            let layer = CALayer()
            layer.contents = bubbleMaskImage?.cgImage
            layer.contentsCenter = self.CGRectCenterRectForResizableImage(bubbleMaskImage!)
            layer.frame = CGRect.init(x: 0, y: 0, width: mapSize.width, height: mapSize.height)
            
            layer.contentsScale = UIScreen.main.scale
            layer.opacity = 1
     
            self.wrapperView.layer.mask = layer
            self.wrapperView.layer.masksToBounds = true
            
    
        }
        
    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.contentView.addSubview(avartar)
        self.contentView.addSubview(wrapperView)
        avartar.setCircle()
        
    }
    deinit {
        print("deinit locationCellView \(String.init(describing: self))")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
   

}


extension LocationMessageCell{
    static func identity() -> String{
        return "locationMessage"
    }
    
    
    // 由于背景图被拉伸过，告诉图层拉伸的比例
    private func  CGRectCenterRectForResizableImage(_ image: UIImage) -> CGRect{
        return CGRect(x: image.capInsets.left / image.size.width, y: image.capInsets.top / image.size.height, width: (image.size.width - image.capInsets.right - image.capInsets.left) / image.size.width, height: (image.size.height - image.capInsets.bottom - image.capInsets.top) / image.size.height)
    }
    
}


extension LocationMessageCell{
    
    @objc private func showMap(_ guest: UITapGestureRecognizer){
        if guest.state == .ended{
            self.navigate2Map?(self.mode)
        }
       
    }
}


extension LocationMessageCell: MKMapViewDelegate{
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuserId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserId)
            as? MKPinAnnotationView
        if pinView == nil {
            //创建一个大头针视图
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
            pinView?.canShowCallout = true
            pinView?.animatesDrop = false
            
            //设置大头针颜色
            pinView?.pinTintColor = UIColor.green
            //设置大头针点击注释视图的右侧按钮样式
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
}
