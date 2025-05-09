//
//  LocationManager.swift
//  LocationApp
//
//  Created by Yassine Lamtalaa on 5/8/25.
//

import Foundation
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Not Determined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
        @unknown default:
            print("Unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    self.locationLabel.text = "Error: \(error.localizedDescription)"
                    return
                }
                
                if let placemark = placemarks?.first,
                   let city = placemark.locality {

                    var address = ""

                    if placemark.isoCountryCode == "US",
                       let state = placemark.administrativeArea {
                        address = "\(city), \(state)"
                    } else if let country = placemark.country {
                        address = "\(city), \(country)"
                    }

                    DispatchQueue.main.async {
                        self.locationLabel.text = address
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationLabel.text = "Error: \(error.localizedDescription)"
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        locationManager.requestLocation()
    }
}
