// Copyright © 2024 RT4. All rights reserved

import UIKit
import CoreLocation
import Moya
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let provider = MoyaProvider<HomeAPI>(plugins: [ BearerTokenPlugin(), NetworkLoggerPlugin() ])
    
    var selectedCharacterNum: Int = 0
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        
        configureLocationManager()
        configureMapView()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHomeInfo { [weak self] isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    self?.homeView.updateStarter()
                    self?.homeView.updatePoints()
                }
            } else {
                print("GET 호출 실패")
            }
        }
    }
    
    private let homeView: HomeView = {
        let hv = HomeView()
        hv.resetBtn.addTarget(self, action: #selector(resetBtnTapped), for: .touchUpInside)
        hv.goToSearchPlaceBtn.addTarget(self, action: #selector(goToSPBtnTapped), for: .touchUpInside)
        hv.floatingBtn.addTarget(self, action: #selector(didTapFloatingBtn), for: .touchUpInside)
        return hv
    }()
    
    @objc
    private func resetBtnTapped() {
        print("Reset button tapped")
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
    }
    
    @objc
    private func goToSPBtnTapped() {
        let vc = TestVC()
        navigationController?.pushViewController(vc, animated: true)
    }
        
    @objc private func didTapFloatingBtn() {
        // 눌렸을 때 애니메이션
        let originalColor = homeView.floatingBtn.backgroundColor
        let highlightColor = UIColor(named: "Gray700")?.withAlphaComponent(0.7) // 원하는 강조 색상
        
        // 버튼 색상을 변경하는 애니메이션
        UIView.animate(withDuration: 0.1, animations: {
            self.homeView.floatingBtn.backgroundColor = highlightColor // 색상 변경
        }) { _ in
            // 애니메이션이 끝난 후 원래 색상으로 돌아오기
            UIView.animate(withDuration: 0.1) {
                self.homeView.floatingBtn.backgroundColor = originalColor // 원래 색상으로 되돌리기
            }
        }
        let vc = SelectDropTypeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
        
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
        locationManager.stopUpdatingLocation()
    }
    
    private func reverseGeocode(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                completion(nil)
                return
            }
//            print(self.processString(placemark.description))
            var strAddr = ""
            var address = ""
            let addressArray = self.processString(placemark.description)
            
            addressArray.forEach { addr in
                if addr.contains("대한민국") {
                    address = addr
                }
            }
            if address == "" {
                address = "서비스 이용 가능 지역이 아닙니다"
            }
            
            print(address)
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
    
    func getHomeInfo(completion: @escaping (Bool) -> Void) {
        provider.request(.getHomeInfo) { result in
            switch result {
            case .success(let response):
                print(response.statusCode)
                do {
                    let responseData = try response.map(HomeResponse.self)
                    self.homeView.name = responseData.nickname
                    self.homeView.points = responseData.point
                    self.selectedCharacterNum = responseData.selectedChar
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(false)
                }
            case.failure(let error):
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
}
