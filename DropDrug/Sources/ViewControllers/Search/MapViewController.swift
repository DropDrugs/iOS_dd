// Copyright © 2024 RT4. All rights reserved

import UIKit
import NMapsMap
import CoreLocation
import Moya

class MapViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewTouchDelegate {
    
    let provider = MoyaProvider<MapAPI>(plugins: [ BearerTokenPlugin(), NetworkLoggerPlugin() ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mapView
        mapView.backgroundMap.mapView.touchDelegate = self
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
    }
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var lat = 0.0 //현재 위치 저장
    private var lng = 0.0 //현재 위치 저장
    private var siDo = ""
    private var siGu = ""
    private var selectedMarker: NMFMarker? // 현재 선택된 마커
    private var currentBottomSheet: UIViewController? // 현재 띄워진 장소상세뷰
    
    public var groupedMarkers: [String: [NMFMarker]] = [
        "동사무소": [],
        "우체통": [],
        "약국": [],
        "보건소": [],
        "기타": []
    ]

    private lazy var mapView: MapView = {
        let v = MapView()
        //v.backgroundMap.positionMode = .direction
        v.townOfficeFltBtn.addTarget(self, action: #selector(townTapped), for: .touchUpInside)
        v.mailboxFltBtn.addTarget(self, action: #selector(mailTapped), for: .touchUpInside)
        v.pharmFltBtn.addTarget(self, action: #selector(pharmTapped), for: .touchUpInside)
        v.healthCenterFltBtn.addTarget(self, action: #selector(healtCenterTapped), for: .touchUpInside)
        v.etcFltBtn.addTarget(self, action: #selector(etcTapped), for: .touchUpInside)
        return v
    }()
    
    @objc
    private func goToTownList() {
        let vc = PlaceListViewController()
        vc.placeListView.title.text = "폐의약품 수거 동사무소 리스트"
        vc.type = "동사무소"
        vc.lat = lat
        vc.lng = lng
        vc.siDo = siDo
        vc.siGu = siGu
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func goToMailList() {
        let vc = PlaceListViewController()
        vc.placeListView.title.text = "폐의약품 수거 우체국 리스트"
        vc.type = "우체국"
        vc.lat = lat
        vc.lng = lng
        vc.siDo = siDo
        vc.siGu = siGu
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    private func goToPharmList() {
        let vc = PlaceListViewController()
        vc.placeListView.title.text = "폐의약품 수거 약국 리스트"
        vc.type = "약국"
        vc.lat = lat
        vc.lng = lng
        vc.siDo = siDo
        vc.siGu = siGu
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    private func goToHealtCenterList() {
        let vc = PlaceListViewController()
        vc.placeListView.title.text = "폐의약품 수거 보건소 리스트"
        vc.type = "보건소"
        vc.lat = lat
        vc.lng = lng
        vc.siDo = siDo
        vc.siGu = siGu
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    private func goToEtcList() {
        let vc = PlaceListViewController()
        vc.placeListView.title.text = "폐의약품 수거 기타 리스트"
        vc.type = "기타"
        vc.lat = lat
        vc.lng = lng
        vc.siDo = siDo
        vc.siGu = siGu
        navigationController?.pushViewController(vc, animated: true)
    }

    
    //MARK: - 플로팅 버튼 이벤트 설정
    
    @objc
    private func townTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "officeBtnSelect")?.withRenderingMode(.alwaysOriginal), for: .selected)
            sender.setTitleColor(.white, for: .normal)
            mapView.mailboxFltBtn.isSelected = false
            mapView.mailboxFltBtn.setImage(UIImage(named: "mailBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.pharmFltBtn.isSelected = false
            mapView.pharmFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.healthCenterFltBtn.isSelected = false
            mapView.healthCenterFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.etcFltBtn.isSelected = false
            mapView.etcFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            for marker in groupedMarkers["동사무소"] ?? [] {
                marker.mapView = mapView.backgroundMap.mapView // 지도에 표시
            }
            for marker in groupedMarkers["우체통"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["약국"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["보건소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["기타"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            mapView.listBtn.removeTarget(nil, action: nil, for: .allEvents)
            mapView.listBtn.addTarget(self, action: #selector(goToTownList), for: .touchUpInside)
        } else {
            sender.setImage(UIImage(named: "officeBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.setTitleColor(.black, for: .normal)
            for marker in groupedMarkers["동사무소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            mapView.listBtn.removeTarget(nil, action: nil, for: .allEvents)
        }
    }
    
    @objc
    private func mailTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "mailBtnSelect")?.withRenderingMode(.alwaysOriginal), for: .selected)
            sender.setTitleColor(.white, for: .normal)
            mapView.townOfficeFltBtn.isSelected = false
            mapView.townOfficeFltBtn.setImage(UIImage(named: "officeBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.pharmFltBtn.isSelected = false
            mapView.pharmFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.healthCenterFltBtn.isSelected = false
            mapView.healthCenterFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.etcFltBtn.isSelected = false
            mapView.etcFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            // 동사무소만 마커 띄움
            for marker in groupedMarkers["우체통"] ?? [] {
                marker.mapView = mapView.backgroundMap.mapView // 지도에 표시
            }
            for marker in groupedMarkers["동사무소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["약국"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["보건소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["기타"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            mapView.listBtn.removeTarget(nil, action: nil, for: .allEvents)
            mapView.listBtn.addTarget(self, action: #selector(goToMailList), for: .touchUpInside)
        } else {
            sender.setImage(UIImage(named: "mailBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.setTitleColor(.black, for: .normal)
            for marker in groupedMarkers["우체통"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            mapView.listBtn.removeTarget(nil, action: nil, for: .allEvents)
        }
    }
    
    @objc
    private func pharmTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "pharmBtnSelect")?.withRenderingMode(.alwaysOriginal), for: .selected)
            sender.setTitleColor(.white, for: .normal)
            mapView.townOfficeFltBtn.isSelected = false
            mapView.townOfficeFltBtn.setImage(UIImage(named: "officeBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.mailboxFltBtn.isSelected = false
            mapView.mailboxFltBtn.setImage(UIImage(named: "mailBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.healthCenterFltBtn.isSelected = false
            mapView.healthCenterFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.etcFltBtn.isSelected = false
            mapView.etcFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            for marker in groupedMarkers["약국"] ?? [] {
                marker.mapView = mapView.backgroundMap.mapView // 지도에 표시
            }
            for marker in groupedMarkers["우체통"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["동사무소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["보건소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["기타"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            mapView.listBtn.removeTarget(nil, action: nil, for: .allEvents)
            mapView.listBtn.addTarget(self, action: #selector(goToPharmList), for: .touchUpInside)
        } else {
            sender.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.setTitleColor(.black, for: .normal)
            for marker in groupedMarkers["약국"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            mapView.listBtn.removeTarget(nil, action: nil, for: .allEvents)
        }
    }
    
    @objc
    private func healtCenterTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "pharmBtnSelect")?.withRenderingMode(.alwaysOriginal), for: .selected)
            sender.setTitleColor(.white, for: .normal)
            mapView.mailboxFltBtn.isSelected = false
            mapView.mailboxFltBtn.setImage(UIImage(named: "mailBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.pharmFltBtn.isSelected = false
            mapView.pharmFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.townOfficeFltBtn.isSelected = false
            mapView.townOfficeFltBtn.setImage(UIImage(named: "officeBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.etcFltBtn.isSelected = false
            mapView.etcFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            for marker in groupedMarkers["보건소"] ?? [] {
                marker.mapView = mapView.backgroundMap.mapView // 지도에 표시
            }
            for marker in groupedMarkers["우체통"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["약국"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["동사무소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["기타"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            mapView.listBtn.removeTarget(nil, action: nil, for: .allEvents)
            mapView.listBtn.addTarget(self, action: #selector(goToHealtCenterList), for: .touchUpInside)
        } else {
            sender.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.setTitleColor(.black, for: .normal)
            for marker in groupedMarkers["보건소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            mapView.listBtn.removeTarget(nil, action: nil, for: .allEvents)
        }
    }
    
    @objc
    private func etcTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(named: "pharmBtnSelect")?.withRenderingMode(.alwaysOriginal), for: .selected)
            sender.setTitleColor(.white, for: .normal)
            mapView.mailboxFltBtn.isSelected = false
            mapView.mailboxFltBtn.setImage(UIImage(named: "mailBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.pharmFltBtn.isSelected = false
            mapView.pharmFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.townOfficeFltBtn.isSelected = false
            mapView.townOfficeFltBtn.setImage(UIImage(named: "officeBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.healthCenterFltBtn.isSelected = false
            mapView.healthCenterFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            for marker in groupedMarkers["기타"] ?? [] {
                marker.mapView = mapView.backgroundMap.mapView // 지도에 표시
            }
            for marker in groupedMarkers["우체통"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["약국"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["동사무소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            for marker in groupedMarkers["보건소"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            mapView.listBtn.removeTarget(nil, action: nil, for: .allEvents)
            mapView.listBtn.addTarget(self, action: #selector(goToEtcList), for: .touchUpInside)
        } else {
            sender.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.setTitleColor(.black, for: .normal)
            for marker in groupedMarkers["기타"] ?? [] {
                marker.mapView = nil // 지도에서 제거
            }
            mapView.listBtn.removeTarget(nil, action: nil, for: .allEvents)
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
        lat = currentLocation.coordinate.latitude
        lng = currentLocation.coordinate.longitude
        print("현재 위치: \(lat), \(lng)")
        
        geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                return
            }
            //            print(self.processString(placemark.description))
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
            let components = strAddr.split(separator: " ")
            
            if let first = components.first, let second = components.dropFirst().first {
                self.siDo = String(first)
                self.siGu = String(second)
                
                self.fetchPlaces()
            } else {
                print("값이 충분하지 않습니다.")
            }
        }
        
        // 현재 위치를 지도 중심으로 설정
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .easeIn
        mapView.backgroundMap.mapView.moveCamera(cameraUpdate)
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
    
    //MARK: - 마커 처리 로직
    
    private func showCustomInfoWindow(_ marker: NMFMarker, lat: Double, lng: Double, placeName: String, address: String, photo: String) {
        
        // 이전 선택된 마커 해제
        if let previousMarker = selectedMarker {
            if let normalImage = previousMarker.userInfo["normalImage"] as? String {
                previousMarker.iconImage = NMFOverlayImage(name: normalImage)
            }
        }
        
        // 새로운 마커 선택
        selectedMarker = marker
        if let selectedImage = marker.userInfo["selectedImage"] as? String {
            marker.iconImage = NMFOverlayImage(name: selectedImage)
        }
        if let currentSheet = currentBottomSheet {
            currentSheet.dismiss(animated: true) { [weak self] in
                self?.presentNewBottomSheet(marker, placeName: placeName, address: address, photo: photo)
            }
        } else {
            presentNewBottomSheet(marker, placeName: placeName, address: address, photo: photo)
        }
    }
    
    private func presentNewBottomSheet(_ marker: NMFMarker, placeName: String, address: String, photo: String) {
        let bottomSheetVC = PlaceDetailViewController()
        bottomSheetVC.modalPresentationStyle = .pageSheet

        if let sheetPresentationController = bottomSheetVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("customHeight")) { _ in 140 }
            sheetPresentationController.detents = [customDetent]
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.preferredCornerRadius = 16
            sheetPresentationController.largestUndimmedDetentIdentifier = .init("customHeight")
        }

        // 바텀 시트 내용 설정
        bottomSheetVC.placeDetailView.name.text = placeName
        bottomSheetVC.placeDetailView.address.text = address
        bottomSheetVC.placeDetailView.imageURL = photo

        // 현재 바텀 시트 추적
        currentBottomSheet = bottomSheetVC

        // 새 바텀 시트 표시
        present(bottomSheetVC, animated: true, completion: nil)
    }

    //MARK: 장소 API 호출
    func getPlaceInfo(addrLvl1: String, addrLvl2: String, type: String, completion: @escaping (Bool) -> Void) {
        provider.request(.getPlaceInfo(addrLvl1: addrLvl1, addrLvl2: addrLvl2, type: type)) { result in
            switch result {
            case .success(let response):
                print(response.statusCode)
                do {
                    let responseData = try response.map([MapResponse].self)
                    print(responseData)
                    var placeType = ""
                    responseData.forEach { place in
                        if type == "동사무소" {
                            placeType = "Office"
                        } else if type == "우체국" {
                            placeType = "Mail"
                        } else if type == "약국" {
                            placeType = "Pharm"
                        } else if type == "보건소" {
                            placeType = "Pharm"
                        } else if type == "기타" {
                            placeType = "Pharm"
                        }
                        let marker = NMFMarker()
                        marker.position = NMGLatLng(lat: Double(place.lat)!, lng: Double(place.lng)!)
                        marker.iconImage = NMFOverlayImage(name: "normal\(placeType)") // 기본 마커 이미지
                        marker.userInfo = ["normalImage": "normal\(placeType)",
                                           "selectedImage": "select\(placeType)"] // 띄우는 마커 이미지 저장 (default, select)
                        marker.touchHandler = { [weak self] _ in
                            marker.iconImage = NMFOverlayImage(name: "select\(placeType)")
                            self?.showCustomInfoWindow(
                                marker,
                                lat: Double(place.lat)!,
                                lng: Double(place.lng)!,
                                placeName: place.name!,
                                address: place.address,
                                photo: place.locationPhoto
                            )
                            return true
                        }
                        if type == "동사무소" {
                            // 동사무소 그룹에 추가
                            self.groupedMarkers["동사무소"]?.append(marker)
                        } else if type == "우체국" {
                            self.groupedMarkers["우체통"]?.append(marker)
                        } else if type == "약국" {
                            self.groupedMarkers["약국"]?.append(marker)
                        } else if type == "보건소" {
                            self.groupedMarkers["보건소"]?.append(marker)
                        } else if type == "기타" {
                            self.groupedMarkers["기타"]?.append(marker)
                        }
                    }
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
    
    private func fetchPlaces() {
        groupedMarkers = ["동사무소": [], "우체국": [], "약국": [], "보건소": [], "기타": []]
        let types = ["동사무소", "우체국", "약국", "보건소", "기타"]
        for type in types {
            getPlaceInfo(addrLvl1: siDo, addrLvl2: siGu, type: type) { [weak self] isSuccess in
                if isSuccess {
                    DispatchQueue.main.async {
                        print("\(type) 정보 호출 성공")
                    }
                } else {
                    print("\(type) 정보 호출 실패")
                }
            }
        }
    }
}
