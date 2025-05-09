//
//  LocationService.swift
//  LocationApp
//
//  Created by Yassine Lamtalaa on 5/9/25.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation(address: String, flag: String)
    func didFailWithError(error: Error)
    func didChangeAuthorization(status: CLAuthorizationStatus)
}

class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.didChangeAuthorization(status: status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                return
            }

            if let placemark = placemarks?.first,
               let city = placemark.locality,
               let countryCode = placemark.isoCountryCode,
               let country = placemark.country {

                let flag = self.flagEmoji(for: countryCode)
                var address = ""

                if countryCode == "US",
                   let state = placemark.administrativeArea {
                    address = "\(city), \(state), \(country)"
                } else {
                    address = "\(city), \(country)"
                }

                self.delegate?.didUpdateLocation(address: address, flag: flag)
            }


        }
    }
    
    func flagEmoji(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var flag = ""
        for scalar in countryCode.uppercased().unicodeScalars {
            if let scalarValue = UnicodeScalar(base + scalar.value) {
                flag.unicodeScalars.append(scalarValue)
            }
        }
        return flag
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }
}
