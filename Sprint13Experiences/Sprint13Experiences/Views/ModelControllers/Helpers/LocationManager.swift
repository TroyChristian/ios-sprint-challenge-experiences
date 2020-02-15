//
//  LocationManager.swift
//  Sprint13Experiences
//
//  Created by Lambda_School_Loaner_219 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_219. All rights reserved.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    var group: DispatchGroup?
    
    private override init () {
        super.init()
        locationManager.delegate = self
        requestLocation()
    }
    
    func requestLocation() {
      let status = CLLocationManager.authorizationStatus()
        switch status {

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }


    func getCurrentLocation(completion:@escaping (CLLocationCoordinate2D) -> Void) {
        requestLocation()
        group = DispatchGroup()
        group?.enter()
        locationManager.requestLocation()
        group?.notify(queue: .main) {
            let coordinate = self.locationManager.location?.coordinate
            self.group = nil
            completion(coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
        }
    }


//    func getLocation() -> CLLocationCoordinate2D? {
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.startUpdatingLocation()
//        return locationManager.location?.coordinate
//
//    }
//}
}
