// Copyright © 2024 RT4. All rights reserved

import UIKit
import NMapsMap
import CoreLocation
import Moya
import SwiftyToaster

class MapViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    
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
    private var hasFetchedInitialPlaces = false
    private let geocoder = CLGeocoder()
    private var lat = 0.0 //현재 위치 저장
    private var lng = 0.0 //현재 위치 저장
    private var siDo = ""
    private var siGu = ""
    private var selectedMarker: NMFMarker? // 현재 선택된 마커
    private var currentBottomSheet: UIViewController? // 현재 띄워진 장소상세뷰
    private var isUserInteracting: Bool = false
    
    public var groupedMarkers: [String: [NMFMarker]] = [
        "동사무소": [],
        "우체국": [],
        "약국": [],
        "보건소": [],
        "기타": []
    ]

    private lazy var mapView: MapView = {
        let v = MapView()
        v.townOfficeFltBtn.addTarget(self, action: #selector(townTapped), for: .touchUpInside)
        v.mailboxFltBtn.addTarget(self, action: #selector(mailTapped), for: .touchUpInside)
        v.pharmFltBtn.addTarget(self, action: #selector(pharmTapped), for: .touchUpInside)
        v.healthCenterFltBtn.addTarget(self, action: #selector(healtCenterTapped), for: .touchUpInside)
        v.etcFltBtn.addTarget(self, action: #selector(etcTapped), for: .touchUpInside)
        v.resetLocaBtn.addTarget(self, action: #selector(doReSearch), for: .touchUpInside)
        v.resetLocaBtn.addTarget(self, action: #selector(didTapFloatingBtn), for: .touchUpInside)
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
        currentBottomSheet?.dismiss(animated: true)
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
        currentBottomSheet?.dismiss(animated: true)
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
        currentBottomSheet?.dismiss(animated: true)
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
        currentBottomSheet?.dismiss(animated: true)
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
        currentBottomSheet?.dismiss(animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func doReSearch() {
        for (_, markers) in groupedMarkers {
            for marker in markers {
                marker.mapView = nil // 지도에서 마커 제거
            }
        }
        groupedMarkers = ["동사무소": [], "우체국": [], "약국": [], "보건소": [], "기타": []]
        
        mapView.townOfficeFltBtn.isSelected = false
        mapView.townOfficeFltBtn.setImage(UIImage(named: "officeBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        mapView.mailboxFltBtn.isSelected = false
        mapView.mailboxFltBtn.setImage(UIImage(named: "mailBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        mapView.pharmFltBtn.isSelected = false
        mapView.pharmFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        mapView.healthCenterFltBtn.isSelected = false
        mapView.healthCenterFltBtn.setImage(UIImage(named: "healthBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        mapView.etcFltBtn.isSelected = false
        mapView.etcFltBtn.setImage(UIImage(named: "etcBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        let cameraPosition = mapView.backgroundMap.mapView.cameraPosition
        let latitude = cameraPosition.target.lat
        let longitude = cameraPosition.target.lng
        
        let testLocation = CLLocation(latitude: latitude, longitude: longitude) // 서울 좌표
        reverseGeocodeAndProcess(location: testLocation) { result in
            switch result {
            case .success(let (siDo, siGu)):
                self.siDo = siDo 
                self.siGu = siGu
                self.fetchPlaces(addr1: siDo, addr2: siGu)
            case .failure(let error):
                print("에러 발생: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func didTapFloatingBtn() {
        // 눌렸을 때 애니메이션
        let originalColor = mapView.resetLocaBtn.backgroundColor
        let highlightColor = Constants.Colors.gray700?.withAlphaComponent(0.7) // 원하는 강조 색상
        
        // 버튼 색상을 변경하는 애니메이션
        UIView.animate(withDuration: 0.1, animations: {
            self.mapView.resetLocaBtn.backgroundColor = highlightColor // 색상 변경
        }) { _ in
            // 애니메이션이 끝난 후 원래 색상으로 돌아오기
            UIView.animate(withDuration: 0.1) {
                self.mapView.resetLocaBtn.backgroundColor = originalColor // 원래 색상으로 되돌리기
            }
        }
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
            mapView.healthCenterFltBtn.setImage(UIImage(named: "healthBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.etcFltBtn.isSelected = false
            mapView.etcFltBtn.setImage(UIImage(named: "etcBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            for marker in groupedMarkers["동사무소"] ?? [] {
                marker.mapView = mapView.backgroundMap.mapView // 지도에 표시
            }
            for marker in groupedMarkers["우체국"] ?? [] {
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
            mapView.healthCenterFltBtn.setImage(UIImage(named: "healthBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.etcFltBtn.isSelected = false
            mapView.etcFltBtn.setImage(UIImage(named: "etcBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            // 동사무소만 마커 띄움
            for marker in groupedMarkers["우체국"] ?? [] {
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
            for marker in groupedMarkers["우체국"] ?? [] {
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
            mapView.healthCenterFltBtn.setImage(UIImage(named: "healthBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.etcFltBtn.isSelected = false
            mapView.etcFltBtn.setImage(UIImage(named: "etcBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            for marker in groupedMarkers["약국"] ?? [] {
                marker.mapView = mapView.backgroundMap.mapView // 지도에 표시
            }
            for marker in groupedMarkers["우체국"] ?? [] {
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
            sender.setImage(UIImage(named: "healthBtnSelect")?.withRenderingMode(.alwaysOriginal), for: .selected)
            sender.setTitleColor(.white, for: .normal)
            mapView.mailboxFltBtn.isSelected = false
            mapView.mailboxFltBtn.setImage(UIImage(named: "mailBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.pharmFltBtn.isSelected = false
            mapView.pharmFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.townOfficeFltBtn.isSelected = false
            mapView.townOfficeFltBtn.setImage(UIImage(named: "officeBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.etcFltBtn.isSelected = false
            mapView.etcFltBtn.setImage(UIImage(named: "etcBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            for marker in groupedMarkers["보건소"] ?? [] {
                marker.mapView = mapView.backgroundMap.mapView // 지도에 표시
            }
            for marker in groupedMarkers["우체국"] ?? [] {
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
            sender.setImage(UIImage(named: "healthBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
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
            sender.setImage(UIImage(named: "etcBtnSelect")?.withRenderingMode(.alwaysOriginal), for: .selected)
            sender.setTitleColor(.white, for: .normal)
            mapView.mailboxFltBtn.isSelected = false
            mapView.mailboxFltBtn.setImage(UIImage(named: "mailBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.pharmFltBtn.isSelected = false
            mapView.pharmFltBtn.setImage(UIImage(named: "pharmBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.townOfficeFltBtn.isSelected = false
            mapView.townOfficeFltBtn.setImage(UIImage(named: "officeBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            mapView.healthCenterFltBtn.isSelected = false
            mapView.healthCenterFltBtn.setImage(UIImage(named: "healthBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
            for marker in groupedMarkers["기타"] ?? [] {
                marker.mapView = mapView.backgroundMap.mapView // 지도에 표시
            }
            for marker in groupedMarkers["우체국"] ?? [] {
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
            sender.setImage(UIImage(named: "etcBtnNSelect")?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        
        reverseGeocodeAndProcess(location: currentLocation) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let (siDo, siGu)):
                self.siDo = siDo
                self.siGu = siGu
                
                if !self.hasFetchedInitialPlaces {
                    self.hasFetchedInitialPlaces = true
                    self.fetchPlaces(addr1: siDo, addr2: siGu)
                }
            case .failure(let error):
                print("Reverse geocoding failed: \(error.localizedDescription)")
            }
        }
                
        // 사용자 조작 중이 아니면 카메라 이동
        if !isUserInteracting {
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
            cameraUpdate.animation = .easeIn
            mapView.backgroundMap.mapView.moveCamera(cameraUpdate)
        }
    }
    
    func mapViewCameraWillChange(_ mapView: NMFMapView, byReason reason: Int, animated: Bool) {
        if reason == -1 { // 사용자 조작
            isUserInteracting = true
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        isUserInteracting = false // 사용자 조작 종료
    }
    
    func reverseGeocodeAndProcess(location: CLLocation, completion: @escaping (Result<(String, String), Error>) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(.failure(NSError(domain: "ReverseGeocode", code: -1, userInfo: [NSLocalizedDescriptionKey: "No placemarks found"])))
                return
            }
            
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
            if let siDo = components.first, let siGu = components.dropFirst().first {
                completion(.success((String(siDo), String(siGu))))
            } else {
                completion(.failure(NSError(domain: "ReverseGeocode", code: -1, userInfo: [NSLocalizedDescriptionKey: "Insufficient address components"])))
            }
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
                            placeType = "Health"
                        } else if type == "기타" {
                            placeType = "Etc"
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
                                photo: place.locationPhoto ?? "OB1"
                            )
                            return true
                        }
                        if type == "동사무소" {
                            // 동사무소 그룹에 추가
                            self.groupedMarkers["동사무소"]?.append(marker)
                        } else if type == "우체국" {
                            self.groupedMarkers["우체국"]?.append(marker)
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
    
    private func fetchPlaces(addr1: String, addr2: String) {
        groupedMarkers = ["동사무소": [], "우체국": [], "약국": [], "보건소": [], "기타": []]
        let types = ["동사무소", "우체국", "약국", "보건소", "기타"]
        for type in types {
            getPlaceInfo(addrLvl1: addr1, addrLvl2: addr2, type: type) { [weak self] isSuccess in
                if isSuccess {
                    DispatchQueue.main.async {
//                        Toaster.shared.makeToast("\(type) 정보 호출 성공")
                        print("\(type) 정보 호출 성공")
                    }
                } else {
                    print("\(type) 정보 호출 실패")
                    Toaster.shared.makeToast("\(type) 정보 호출 실패")
                }
            }
        }
    }
}
