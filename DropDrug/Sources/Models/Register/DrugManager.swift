// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

extension PrescriptionDrugVC { //get
    func getDrugsList(completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.getDrug) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map([DrugResponse].self)
                    self.drugs = []
                    for drugData in response {
                        let countString = "\(drugData.count)"
                        self.drugs.append(PrescriptionDrug(date: drugData.date, duration: countString))
                    }
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error)")
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
    func setupPostDrugDTO(_ date: String, _ count : Int) -> drugSaveRequest {
        return drugSaveRequest(count: count, date: date)
    }
    
    func postNewDrug(_ userParameter: drugSaveRequest, completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.postDrug(param: userParameter)) { result in
            switch result {
            case .success(let response):
                do {
                    let _ = try response.map(IdResponse.self)
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error)")
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

extension DiscardPrescriptionDrugVC { //delete
    func setupDeleteDrugDTO(_ drugIDs : [Int]) -> drugDeleteRequest {
        return drugDeleteRequest(id: drugIDs)
    }
    
    func getDrugsList(completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.getDrug) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map([DrugResponse].self)
                    self.drugList = response
                    completion(true)
                } catch {
                    print("Failed to decode response: \(error)")
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
    
    func deleteDrugs(_ userParameter: drugDeleteRequest, completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.deleteDrug(param: userParameter)) { result in
            switch result {
            case .success(let response):
                completion(true)
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
