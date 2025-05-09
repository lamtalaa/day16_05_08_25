//
//  ViewController.swift
//  LocationApp
//
//  Created by Yassine Lamtalaa on 5/8/25.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    let locationService = LocationService()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.delegate = self
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        locationService.requestLocation()
    }
}

extension ViewController: LocationServiceDelegate {
    func didUpdateLocation(address: String, flag: String) {
        DispatchQueue.main.async {
            self.flagLabel.text = flag
            self.locationLabel.text = address
        }
    }

    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.locationLabel.text = "Error: \(error.localizedDescription)"
        }
    }

    func didChangeAuthorization(status: CLAuthorizationStatus) {
        print("Authorization changed: \(status.rawValue)")
    }
}
