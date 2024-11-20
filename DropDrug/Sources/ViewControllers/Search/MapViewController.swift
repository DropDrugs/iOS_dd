// Copyright © 2024 RT4. All rights reserved

import UIKit
import NMapsMap
import CoreLocation
import Moya

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let provider = MoyaProvider<MapAPI>(plugins: [ BearerTokenPlugin() ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mapView
        setupLocationManager()
        addMarker(mark: "Pharm", lat: 37.5665, lng: 126.9780, placeName: "서울특별시청", address: "서울특별시 마포구 동교로15길 7")
        getPlaceInfo { [weak self] isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    
                }
            } else {
                print("GET 호출 실패")
            }
        }
    }
    
    private let locationManager = CLLocationManager()
    private var customInfoWindow: UIView?
    
    public var groupedMarkers: [String: [NMFMarker]] = [
        "동사무소": [],
        "우체통": [],
        "약국" : []
    ]

    private lazy var mapView: MapView = {
        let v = MapView()
        v.backgroundMap.positionMode = .direction
        v.townOfficeFltBtn.addTarget(self, action: #selector(townTapped), for: .touchUpInside)
        v.mailboxFltBtn.addTarget(self, action: #selector(mailTapped), for: .touchUpInside)
        v.pharmFltBtn.addTarget(self, action: #selector(pharmTapped), for: .touchUpInside)
        return v
    }()
    
    //MARK: - 플로팅 버튼 이벤트 설정
    
    @objc
    private func townTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "selectOffice")?.withRenderingMode(.alwaysOriginal), for: .selected)
            sender.backgroundColor = Constants.Colors.skyblue
            sender.setTitleColor(.white, for: .normal)
            // 동사무소만 마커 띄움
            for marker in groupedMarkers["동사무소"] ?? [] {
                marker.mapView = mapView.backgroundMap // 지도에 표시
            }

        } else {
            sender.setImage(UIImage(named: "nSelectOffice")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            // 그 외 마커 제거
            for marker in groupedMarkers["우체통"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["약국"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
        }
    }
    
    @objc
    private func mailTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "selectMail")?.withRenderingMode(.alwaysOriginal), for: .selected)
            sender.backgroundColor = Constants.Colors.pink
            sender.setTitleColor(.white, for: .normal)
            // 동사무소만 마커 띄움
            for marker in groupedMarkers["우체통"] ?? [] {
                marker.mapView = mapView.backgroundMap // 지도에 표시
            }
        } else {
            sender.setImage(UIImage(named: "nSelectMail")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            // 그 외 마커 제거
            for marker in groupedMarkers["동사무소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["약국"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
        }
    }
    
    @objc
    private func pharmTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "selectPharm")?.withRenderingMode(.alwaysOriginal), for: .selected)
            sender.backgroundColor = UIColor(hex: "#FFE23F")
            sender.setTitleColor(.white, for: .normal)
            // 동사무소만 마커 띄움
            for marker in groupedMarkers["약국"] ?? [] {
                marker.mapView = mapView.backgroundMap // 지도에 표시
            }
        } else {
            sender.setImage(UIImage(named: "nSelectPharm")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            // 그 외 마커 제거
            for marker in groupedMarkers["우체통"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["동사무소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
        }
    }
    //MARK: - 현재 위치 설정
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1 // 10미터 이동 시 업데이트
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // 높은 정확도
        locationManager.startUpdatingLocation()
    }
    
    // 위치 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let lat = currentLocation.coordinate.latitude
        let lng = currentLocation.coordinate.longitude
        print("현재 위치: \(lat), \(lng)")
        
        // 현재 위치를 지도 중심으로 설정
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .easeIn
        mapView.backgroundMap.moveCamera(cameraUpdate)
    }
    //MARK: - 마커 처리 로직
    
    private func addMarker(mark: String, lat: Double, lng: Double, placeName: String, address: String) {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.iconImage = NMFOverlayImage(name: "normal\(mark)") // 기본 마커 이미지
        marker.mapView = mapView.backgroundMap
        
        // 마커 클릭 이벤트 처리
        marker.touchHandler = { [weak self] _ in
            marker.iconImage = NMFOverlayImage(name: "select\(mark)")
            self?.showCustomInfoWindow(lat: lat, lng: lng, placeName: placeName, address: address)
            return true
        }
    }
    
    private func showCustomInfoWindow(lat: Double, lng: Double, placeName: String, address: String) {
        // 기존 정보창 제거
        customInfoWindow?.removeFromSuperview()
        
        // 커스텀 정보창 생성
        let infoWindow = createCustomInfoWindow(placeName: placeName, address: address)
        customInfoWindow = infoWindow
        
        // 지도에 추가
        let screenPosition = mapView.backgroundMap.projection.point(from: NMGLatLng(lat: lat, lng: lng))
        infoWindow.center = CGPoint(x: screenPosition.x, y: screenPosition.y - 100) // 마커 위에 배치
        view.addSubview(infoWindow)
    }
    
    private func createCustomInfoWindow(placeName: String, address: String) -> UIView {
        let infoWindow = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        infoWindow.backgroundColor = .white
        infoWindow.layer.cornerRadius = 8
        infoWindow.layer.borderWidth = 1
        infoWindow.layer.borderColor = UIColor.lightGray.cgColor
        infoWindow.layer.shadowColor = UIColor.black.cgColor
        infoWindow.layer.shadowOpacity = 0.3
        infoWindow.layer.shadowOffset = CGSize(width: 0, height: 2)
        infoWindow.layer.shadowRadius = 5
        
        // 장소 이름
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 180, height: 20))
        titleLabel.text = placeName
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .black
        infoWindow.addSubview(titleLabel)
        
        // 주소

        // 닫기 버튼
        let closeButton = UIButton(frame: CGRect(x: 170, y: 10, width: 20, height: 20))
        closeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(hideCustomInfoWindow), for: .touchUpInside)
        infoWindow.addSubview(closeButton)
        
        return infoWindow
    }
    
    @objc private func hideCustomInfoWindow() {
        customInfoWindow?.removeFromSuperview()
        customInfoWindow = nil
    }
    
    //MARK: 장소 API 호출
    func getPlaceInfo(completion: @escaping (Bool) -> Void) {
        provider.request(.getPlaceInfo) { result in
            switch result {
            case .success(let response):
                print(response.statusCode)
                do {
                    let responseData = try response.map([MapResponse].self)
                    print(responseData)
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
