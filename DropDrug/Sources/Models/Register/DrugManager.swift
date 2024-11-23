// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

extension PrescriptionDrugVC { //get
    func fetchMemberInfo(completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.getDrug) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
                completion(false)
            }
        }
    }
}

extension EnrollDetailViewController { //post
    func setupPostDrugDTO() -> drugSaveRequest? {
        return drugSaveRequest(count: 0, date: "dd")
    }
    
    func fetchMemberInfo(_ userParameter: drugSaveRequest, completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.postDrug(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    DispatchQueue.main.async {
                        //데이터 받아오기
                    }
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure(let error):
                completion(false)
            }
        }
    }
}

extension DiscardPrescriptionDrugVC { //delete
    func setupDeleteDrugDTO() -> drugDeleteRequest? {
        return drugDeleteRequest(id: [1,2,3])
    }
    func fetchMemberInfo(_ userParameter: drugDeleteRequest, completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.deleteDrug(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    DispatchQueue.main.async {
                        //데이터 받아오기
                    }
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure(let error):
                completion(false)
            }
        }
    }
}
