// Copyright © 2024 RT4. All rights reserved
import UIKit
import PinLayout
import CoreLocation

class TestVC: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "Label 1"
        label.textAlignment = .center
        label.font = UIFont.ptdBoldFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.text = "DropDrug"
        label.font = UIFont.roRegularFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Lightblue")
        
        // 라벨을 뷰에 추가
        view.addSubview(label1)
        view.addSubview(label2)
        setupLocationManager()
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
    
    //MARK: - Location parts
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("위치 서비스가 제한 또는 거부되었습니다.")
            self.locationManager.stopUpdatingLocation()
        case .notDetermined:
            print("위치 권한이 아직 결정되지 않았습니다.")
            self.locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("알 수 없는 권한 상태입니다.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // 위치 정보를 기반으로 주소를 가져옴
        reverseGeocode(location: location)
        
        locationManager.stopUpdatingLocation()
    }
    
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                print("역지오코딩 실패: \(error)")
                return
            }
            
            if let placemark = placemarks?.first {
                var address = ""

                
                if let administrativeArea = placemark.administrativeArea {
//                    print("== [시/도] administrativeArea : \(administrativeArea)")  //서울특별시, 경기도
                    address = "\(address) \(administrativeArea) "
                }
                
                if let locality = placemark.locality {
//                    print("== [도시] locality : \(locality)") //서울시, 성남시, 수원시
                    address = "\(address) \(locality) "
                }
                
                if let subLocality = placemark.subLocality {
//                    print("== [추가 도시] subLocality : \(subLocality)") //강남구
                    address = "\(address) \(subLocality) "
                }
                
                if let thoroughfare = placemark.thoroughfare {
//                    print("== [상세주소] thoroughfare : \(thoroughfare)") //강남대로106길, 봉은사로2길
                    address = "\(address) \(thoroughfare) "
                }
                
                if let subThoroughfare = placemark.subThoroughfare {
//                    print("== [추가 거리 정보] subThoroughfare : \(subThoroughfare)") //272-13
                    address = "\(address) \(subThoroughfare)"
                }
                print(address)
            }
        }
    }
}
