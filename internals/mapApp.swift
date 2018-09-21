//
//  mapApp.swift
//  internals
//
//  Created by ke.liang on 2017/9/5.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

public enum PazNavigationApp {
    case AppleMaps
    case GoogleMaps
    case Navigon
    case TomTom
    case Waze
    
    public static let AllValues: [PazNavigationApp] = [.AppleMaps, .GoogleMaps, .Navigon, .TomTom, .Waze]
    
    public static var AvailableServices: [PazNavigationApp] {
        var availableServices = [PazNavigationApp]()
        for app in self.AllValues {
            if app.available {
                availableServices.append(app)
            }
        }
        return availableServices
    }
    
    public var name: String {
        switch self {
        case .AppleMaps:
            return "苹果地图"
        case .GoogleMaps:
            return "谷歌地图"
        case .Navigon:
            return "Navigon"
        case .TomTom:
            return "TomTom"
        case .Waze:
            return "Waze"
        }
    }
    
    public var urlString: String {
        switch self {
        case .AppleMaps:
            return "maps.apple.com://"
        case .GoogleMaps:
            return "comgooglemaps://"
        case .Navigon:
            return "navigon://"
        case .TomTom:
            return "tomtomhome://"
        case .Waze:
            return "waze://"
        }
        
    }
    
    public var url: URL? {
        return URL(string: self.urlString)
    }
    
    public var available: Bool {
        if self == .AppleMaps {
            return true
        }
        guard let url = self.url else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    public func directionsUrlString(coordinate: CLLocationCoordinate2D, name: String = "Destination") -> String {
        var urlString = self.urlString
        switch self {
        case .AppleMaps:
            urlString.append("?q=\(coordinate.latitude),\(coordinate.longitude)=d&t=h")
        case .GoogleMaps:
            urlString.append("?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving")
        case .Navigon:
            urlString.append("coordinate/\(name)/\(coordinate.longitude)/\(coordinate.latitude)")
        case .TomTom:
            urlString.append("geo:action=navigateto&lat=\(coordinate.latitude)&long=\(coordinate.longitude)&name=\(name)")
        case .Waze:
            urlString.append("?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=yes")
        }
        let urlwithPercentEscapes = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? urlString
        
        return urlwithPercentEscapes
    }
    
    
    public func directionsUrl(coordinate: CLLocationCoordinate2D, name: String = "Destination") -> URL? {
        let urlString = self.directionsUrlString(coordinate: coordinate, name: name)
        return URL(string: urlString)
    }
    
    public func openWithDirections(coordinate: CLLocationCoordinate2D, name: String = "Destination", completion: ((Bool) -> Swift.Void)? = nil) {
        if self == .AppleMaps {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = name
            
            let regionDistance:CLLocationDistance = 100
            
            let coordinates = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
            
            
            let regionSpan =  MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            
            let options = [
                
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                
            ]
            
            let success = mapItem.openInMaps(launchOptions: options)
            completion?(success)
        }
        guard let url = self.directionsUrl(coordinate: coordinate, name: name) else {
            completion?(false)
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(url.absoluteString): \(success)")
                completion?(success)
            })
        } else {
            let success = UIApplication.shared.openURL(url)
            completion?(success)
        }
    }
    
  
   
    
    
    
    // locate 2D
    public static func directionsAlertController(coordinate: CLLocationCoordinate2D, name: String = "Destination", title: String = "Directions Using", message: String? = nil, completion: ((Bool) -> Swift.Void)? = nil) -> UIAlertController {
        let directionsAlertView = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        for navigationApp in PazNavigationApp.AvailableServices {
            directionsAlertView.addAction(UIAlertAction(title: navigationApp.name, style: UIAlertAction.Style.default, handler: { (action) in
                navigationApp.openWithDirections(coordinate: coordinate, name: name, completion: { (success) in
                    completion?(success)
                })
            }))
        }
        directionsAlertView.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (action) in
            completion?(false)
        }))
        return directionsAlertView
    }
    
}
