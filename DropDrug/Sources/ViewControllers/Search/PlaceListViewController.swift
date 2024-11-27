// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya

class PlaceListViewController: UIViewController {
    
    let provider = MoyaProvider<MapAPI>(plugins: [ BearerTokenPlugin(), NetworkLoggerPlugin() ])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.view = placeListView
        getPlaceInfo(addrLvl1: siDo, addrLvl2: siGu, type: type) { [weak self] isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    print("정보 호출 성공")
                }
            } else {
                print("정보 호출 실패")
            }
        }
    }
    
    var placeResults: [MapResponse] = []
    public var type = ""
    public var lat = 0.0 //현재 위치
    public var lng = 0.0 //현재 위치
    public var siDo = ""
    public var siGu = ""
    
    public lazy var placeListView: PlaceListView = {
        let v = PlaceListView()
        v.mapBtn.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
        v.placeListTableView.dataSource = self
        v.placeListTableView.dataSource = self
        v.placeListTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        v.placeListTableView.allowsSelection = false
        return v
    }()

    @objc
    private func goToMap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func calculateDistance(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
        let earthRadius = 6371000.0 // 지구 반지름 (미터)
        
        // 위도와 경도를 라디안 단위로 변환
        let dLat = (lat2 - lat1) * .pi / 180.0
        let dLng = (lng2 - lng1) * .pi / 180.0
        
        let a = sin(dLat / 2) * sin(dLat / 2) +
                cos(lat1 * .pi / 180.0) * cos(lat2 * .pi / 180.0) *
                sin(dLng / 2) * sin(dLng / 2)
        
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distance = earthRadius * c // 거리 계산
        
        return distance
    }
    
    func getPlaceInfo(addrLvl1: String, addrLvl2: String, type: String, completion: @escaping (Bool) -> Void) {
        provider.request(.getPlaceInfo(addrLvl1: addrLvl1, addrLvl2: addrLvl2, type: type)) { result in
            switch result {
            case .success(let response):
                print(response.statusCode)
                do {
                    var responseData = try response.map([MapResponse].self)
                    print(responseData)
                    responseData.forEach { place in
                        // 현재 위치와 각 장소 간 거리 계산 후 정렬
                        responseData.sort { (place1: MapResponse, place2: MapResponse) -> Bool in
                            let distance1 = self.calculateDistance(lat1: Double(self.lat), lng1: Double(self.lng), lat2: Double(place1.lat)!, lng2: Double(place1.lng)!)
                            let distance2 = self.calculateDistance(lat1: Double(self.lat), lng1: Double(self.lng), lat2: Double(place2.lat)!, lng2: Double(place2.lng)!)
                            print("distance1: \(distance1), distance2: \(distance2)")
                            return distance1 < distance2
                        }
                        
                        // 정렬된 결과를 placeResults에 저장
                        self.placeResults = responseData
                        
                        // 테이블 뷰 리로드
                        DispatchQueue.main.async {
                            self.placeListView.placeListTableView.reloadData()
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
}

extension PlaceListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceListTableViewCell", for: indexPath) as? PlaceListTableViewCell else {
            return UITableViewCell()
        }
        
        let place = placeResults[indexPath.row]
        cell.configure(place: place)
        
        return cell
    }
}
