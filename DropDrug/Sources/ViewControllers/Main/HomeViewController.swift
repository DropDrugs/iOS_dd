// Copyright © 2024 RT4. All rights reserved

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        
        configureLocationManager()
        configureMapView()
        
        navigationController?.navigationBar.isHidden = true
    }
    private let homeView: HomeView = {
        let hv = HomeView()
        return hv
    }()
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func configureMapView() {
        self.homeView.mapView.delegate = self
        self.homeView.mapView.showsUserLocation = true
    }
    
    // 위치 업데이트를 받을 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // HomeView의 지도 위치 업데이트
        let coordinate = location.coordinate
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        homeView.mapView.setRegion(region, animated: true)
        
        reverseGeocode(location: location) { [weak self] address in
            DispatchQueue.main.async {
                self?.homeView.presLoca.text = address
            }
        }
        
        // 위치 업데이트 중지
//        locationManager.stopUpdatingLocation()
    }
    
    private func reverseGeocode(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            print(self.processString(placemark.description))
            var strAddr = ""
            var address = ""
            for i in self.processString(placemark.description) {
                if i.contains("대한민국") {
                    address = i
                }
            }
            for i in address.components(separatedBy: " ") {
                if !i.contains("대한민국") {
                    strAddr += " \(i)"
                }
            }
            
            completion(strAddr.trimmingCharacters(in: .whitespaces))
        }
    }
    
    func processString(_ input: String) -> [String] {
        // 문자열을 ","로 분리
        let components = input.split(separator: ",")
        
        // 각 요소에서 "@" 뒤의 문자열 제거
        let processedComponents = components.map { component -> String in
            if let atIndex = component.firstIndex(of: "@") {
                return String(component[..<atIndex])
            } else {
                return String(component)
            }
        }
        
        return processedComponents
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        self.homeView.mapView.setRegion(region, animated: true)
    }
    
    
}
