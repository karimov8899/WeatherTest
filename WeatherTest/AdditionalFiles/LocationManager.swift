//
//  LocationManager.swift
//  WeatherTest
//
//  Created by Davron on 11.07.2021.
//

import Foundation
import CoreLocation

class LocationManager {
    static let shared = LocationManager()
    
    public func findLocations(with query: String, completion: @escaping (([MainLocation]) -> Void)) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            let models: [MainLocation] = places.compactMap({place in
                var name = ""
                if let locationName = place.name {
                    name += locationName
                }
                
                if let country = place.country {
                    name += ", \(country)"
                }
                let result = MainLocation(title: name, coordinates: place.location?.coordinate)
                return result
            })
            
            completion(models)
        }
    }
    
    public func getAddress(location: CLLocation, completion: @escaping ((String) -> Void)) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (place, error) in
            guard let place = place, error == nil else {
                completion("")
                return
            }
            var name = ""
            
            place.compactMap({ place in
                if let locationName = place.name {
                    name += locationName
                }
                if let country = place.country {
                    name += ", \(country)"
                }
            })
            completion(name) 
        }
    }
}
