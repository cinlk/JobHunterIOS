//
//  location.swift
//  internals
//
//  Created by ke.liang on 2019/1/6.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import CoreLocation


class UserLocationManager: NSObject, CLLocationManagerDelegate{
    
    private var col: CLLocationManager?
    static let shared:UserLocationManager = UserLocationManager()
    
    required override init() {
        super.init()
        self.col = CLLocationManager()
        self.col?.desiredAccuracy =  kCLLocationAccuracyBest
        self.col?.distanceFilter = 10
        
        
        self.col?.delegate = self
        
    }
    
    
    open func getLocation() -> Bool {
        
        if CLLocationManager.locationServicesEnabled() == false {
            return false
        }
        
        switch CLLocationManager.authorizationStatus() {
        // 第一次使用时 会显示授权
        case .notDetermined:
            self.col?.requestAlwaysAuthorization()
            
        case .denied:
            return false
        case .restricted:
            return false
        default:
            self.col?.startUpdatingLocation()
            
        }
        return true
        
    }
    
    open func getOneTimeLocation(){
        self.col?.requestLocation()
    }
    
    
    private func getCity(location: CLLocation){
        let geocoder:CLGeocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if  error == nil{
                //print(placemarks?.count)
                if let place = placemarks?.last{
                    //print(place.name)
                    var address = ""
                    if let country = place.country {
                        address.append("\(country) ")
                    }
                    if let administrativeArea = place.administrativeArea {
                        address.append("\(administrativeArea)")
                    }
                    if let subAdministrativeArea = place.subAdministrativeArea {
                        address.append("\(subAdministrativeArea)")
                    }
                    if let locality = place.locality {
                        address.append("\(locality)")
                    }
                    if let subLocality = place.subLocality {
                        address.append("\(subLocality)")
                    }
                    if let thoroughfare = place.thoroughfare {
                        address.append("\(thoroughfare)")
                    }
                    // 获取不到门牌 ???
                    if let subThoroughfare = place.subThoroughfare {
                        address.append("门牌：\(subThoroughfare)\n")
                    }
                    
                   
                    //print(address)
                    SingletoneClass.shared.setAddress(address: address)
                
                }else{
                    print("获取不到位置")
                }
            }
        }
        
    }
    
    
    
}




extension UserLocationManager{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        print("find location \(locations.count)")
        if let location:CLLocation = locations.first, location.horizontalAccuracy > 0{
            SingletoneClass.shared.setUserLocation(location: location)
            
            print("纬度\(location.coordinate.latitude)")
            print("经度\(location.coordinate.longitude)")
            //print(manager.location?.coordinate.latitude, manager.location?.coordinate.longitude)
            getCity(location: location)
        }
        
        manager.stopUpdatingLocation()
    }
    

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            self.col?.startUpdatingLocation()
            //SingletoneClass.shared.setUserLocation(permit: true)
            
        default:
            //SingletoneClass.shared.setUserLocation(permit: false)
            break
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("get location didFailWithError", error.localizedDescription)
        
        manager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
        
        switch (error as NSError?)?.code {
        case 0:
            print("位置不可用")
        case 1:
            print("用户关闭")
        default:
            break
        }
        print("get location error \(String.init(describing: error))")
        
        manager.stopUpdatingLocation()
    }
    
    
}
