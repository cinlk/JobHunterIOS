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
        //l.setSingleLineAutoResizeWithMaxWidth()
        l.backgroundColor = UIColor.clear
        return l
    }()
    
    private lazy var tapMap:UITapGestureRecognizer  = { [unowned self] in
        let tap = UITapGestureRecognizer.init()
        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: #selector(showMap(_:)))
        return tap
    }()
    
    private lazy var map:MKMapView = { [unowned self] in 
        let m = MKMapView.init()
       
        m.isScrollEnabled = false
        m.isRotateEnabled = false
        m.mapType = MKMapType.standard
        m.delegate = self
        //self.tapMap.numberOfTouchesRequired = 1
        m.addGestureRecognizer(tapMap)
        
        return m
    }()
    
    // 包裹标签和地图内容的view
    private lazy var wrapperView:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: mapSize.width, height: mapSize.height))
        v.backgroundColor = UIColor.white
        v.isUserInteractionEnabled = true
        v.addSubview(address)
        v.addSubview(map)
        _ = self.address.sd_layout()?.leftSpaceToView(v, 5)?.rightEqualToView(v)?.topEqualToView(v)?.autoHeightRatio(0)
        _ = self.map.sd_layout()?.leftEqualToView(v)?.rightEqualToView(v)?.topSpaceToView(self.address,0)?.bottomEqualToView(v)
        
        self.address.setMaxNumberOfLinesToShow(2)
        
        return v
    }()

    
    dynamic var mode: LocationMessage?{
        didSet{
            guard let m = mode else{
                avartar.isHidden = true
                return
            }
            
            if let url = GlobalUserInfo.shared.getIcon(){
                self.avartar.kf.setImage(with: Source.network(url), placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            
            // 背景图片拉伸
            let stretchInset = UIEdgeInsets(top: 30, left: 28, bottom: 23, right: 28)
            var stretchImage:UIImage!
            var bubbleMaskImage:UIImage!
            
            self.address.text = m.address
            // 添加大头针
            let addressAnnotation = MKPointAnnotation.init()
           // addressAnnotation.
            addressAnnotation.coordinate = CLLocation.init(latitude: m.latitude!, longitude: m.longitude!).coordinate
            
            self.map.addAnnotation(addressAnnotation)
            
            // 设置显示区域
            let latDelta = 0.005
            let longDelta = 0.005

            let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let center:CLLocation = CLLocation.init(latitude: m.latitude!, longitude: m.longitude!)
            let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,
                                                                      span: currentLocationSpan)
            self.map.setRegion(currentRegion, animated: false)
            // 设置region 需要zoom 可用，现在设置完了，关闭zoom
            self.map.isZoomEnabled = false

//
            
            // 自己发的消息
            if m.senderId == GlobalUserInfo.shared.getId(){
                avartar.frame = CGRect.init(x: GlobalConfig.ScreenW - 45 - 5, y: 5, width: GlobalConfig.AvatarSize.width, height: GlobalConfig.AvatarSize.height)
                
                stretchImage = UIImage.init(named: "senderImageMask")
                bubbleMaskImage = stretchImage?.resizableImage(withCapInsets: stretchInset, resizingMode: .stretch)
                
//                _ = self.address.sd_layout()?.rightSpaceToView(self.avartar,10)?.widthIs(mapSize.width)?.topEqualToView(self.avartar)?.autoHeightRatio(0)
//
//                _ = self.map.sd_layout()?.topSpaceToView(address,0)?.leftEqualToView(address)?.rightEqualToView(address)?.heightIs(mapSize.height)
                _ = wrapperView.sd_layout()?.rightSpaceToView(self.avartar, 10)?.widthIs(mapSize.width)?.topEqualToView(self.avartar)?.heightIs(mapSize.height)
                
                
            }else{
                avartar.frame = CGRect.init(x: 5, y: 5, width: GlobalConfig.AvatarSize.width, height: GlobalConfig.AvatarSize.height)
                
                stretchImage = UIImage.init(named: "receiverImageMask")
                bubbleMaskImage = stretchImage?.resizableImage(withCapInsets: stretchInset, resizingMode: .stretch)
                
//                 _ = self.address.sd_layout()?.leftSpaceToView(self.avartar,10)?.widthIs(mapSize.width)?.topEqualToView(self.avartar)?.autoHeightRatio(0)
//                 _ = self.map.sd_layout()?.topSpaceToView(address,0)?.leftEqualToView(address)?.rightEqualToView(address)?.heightIs(mapSize.height)
                 _ = wrapperView.sd_layout()?.leftSpaceToView(self.avartar, 10)?.widthIs(mapSize.width)?.topEqualToView(self.avartar)?.heightIs(mapSize.height)
                
            }
            //map.layer.cornerRadius = 5
            
            let layer = CALayer()
            layer.contents = bubbleMaskImage?.cgImage
            layer.contentsCenter = self.CGRectCenterRectForResizableImage(bubbleMaskImage!)
            layer.frame = CGRect.init(x: 0, y: 0, width: mapSize.width, height: mapSize.height)
            
            layer.contentsScale = UIScreen.main.scale
            layer.opacity = 1
            
            //self.map.layer.mask = layer
            //self.map.layer.masksToBounds = true
            self.wrapperView.layer.mask = layer
            self.wrapperView.layer.masksToBounds = true
            
            //self.setupAutoHeight(withBottomView: wrapperView, bottomMargin: 10)
        }
        
    }
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        //self.isUserInteractionEnabled = false
        self.contentView.addSubview(avartar)
        self.contentView.addSubview(wrapperView)
        //self.contentView.addSubview(address)
        //self.contentView.addSubview(map)
        avartar.setCircle()
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        _ = self.address.sd_layout()?.topEqualToView(self.contentView)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.autoHeightRatio(0)
//        _ = self.map.sd_layout()?.topSpaceToView(self.address,0)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(80)
//
//    }
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
