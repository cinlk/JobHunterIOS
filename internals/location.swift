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
        self.col?.distanceFilter = kCLLocationAccuracyKilometer
        self.col?.delegate = self
        
    }
    
    
    open func getLocation(){
        if SingletoneClass.shared.userLocationPermit{
            self.col?.startUpdatingLocation()
        }else{
            self.col?.requestAlwaysAuthorization()
            self.col?.requestWhenInUseAuthorization()
        }
        
    }
    
    open func getOneTimeLocation(){
        self.col?.requestLocation()
    }
    
    
    private func getCity(location: CLLocation){
        let geocoder:CLGeocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if  error == nil{
                if let place = placemarks?.first{
                    if let city = place.locality,   let zone =  place.subLocality,  let address = place.name{
                          SingletoneClass.shared.setAddress(city: city, zone: zone, address: address)
                    }
                
                    print("地址\(place.name)")
                    print("城市\(place.locality)")
                    print("区\(place.subLocality)")
                
                }else{
                    print("获取不到位置")
                }
            }
        }
        
    }
    
    
    
}




extension UserLocationManager{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        print("find location")
        if let location:CLLocation = locations.last, location.horizontalAccuracy > 0{
            SingletoneClass.shared.setUserLocation(location: location)
            
            print("纬度\(location.coordinate.latitude)")
            print("经度\(location.coordinate.longitude)")
            
            getCity(location: location)
        }
        
        manager.stopUpdatingLocation()
    }
    

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            SingletoneClass.shared.setUserLocation(permit: true)
        default:
            SingletoneClass.shared.setUserLocation(permit: false)
            
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
        print("get location error", error)
        
        manager.stopUpdatingLocation()
    }
    
    
}
