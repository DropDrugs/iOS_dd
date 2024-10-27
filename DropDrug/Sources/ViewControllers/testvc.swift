// Copyright © 2024 RT4. All rights reserved
import UIKit
import PinLayout
import CoreLocation

class TestVC: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "empty"
        label.textAlignment = .center
        //label.font = UIFont.ptdBoldFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.text = "DropDrug"
        //label.font = UIFont.roRegularFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 라벨을 뷰에 추가
        view.addSubview(label1)
        view.addSubview(label2)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission()
        print("권한요청")
    }
    
    func requestLocationPermission() {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization() // 요청을 명확하게 표시
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            startLocationUpdates()
        } else {
            print("Location services denied.")
        }
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geocoder = CLGeocoder()
        if let location = locationManager.location {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error)")
                    return
                }
                if let placemark = placemarks?.first, let address = placemark.locality {
                    print(address)
                } else {
                }
            }
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // label1을 화면 중앙에 배치
        label1.pin
            .center()
            .sizeToFit()  // 텍스트에 맞게 사이즈 조절
        
        // label2를 label1 아래에 배치하고 간격을 추가
        label2.pin
            .below(of: label1)
            .marginTop(16)   // 첫 번째 라벨과의 간격
            .hCenter()       // 수평 중앙 정렬
            .sizeToFit()     // 텍스트에 맞게 사이즈 조절
    }
}
