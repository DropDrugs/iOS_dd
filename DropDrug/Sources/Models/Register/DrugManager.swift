// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya
import SwiftyToaster

extension PrescriptionDrugVC { //get
    func getDrugsList(completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.getDrug) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map([DrugResponse].self)
                    self.drugs = []
                    for drugData in response {
                        let countString = "\(drugData.count)일치"
                        self.drugs.append(PrescriptionDrug(date: drugData.date, duration: countString))
                    }
                    completion(true)
                } catch {
                    Toaster.shared.makeToast("데이터를 불러오는데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
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
                    Toaster.shared.makeToast("데이터를 불러오는데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
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
                    Toaster.shared.makeToast("데이터를 불러오는데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
    
    func deleteDrugs(_ userParameter: drugDeleteRequest, completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.deleteDrug(param: userParameter)) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
}

extension SelectDiscardPrescriptionDrugVC {
    func getDrugsList(completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.getDrug) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map([DrugResponse].self)
                    self.drugList = response
                    completion(true)
                } catch {
                    Toaster.shared.makeToast("데이터를 불러오는데 실패했습니다.")
                    completion(false)
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
}

extension CertificationSuccessVC { //delete
    func setupDeleteDrugDTO(_ drugIDs : [Int]) -> drugDeleteRequest {
        return drugDeleteRequest(id: drugIDs)
    }
    
    func deleteDrugs(_ userParameter: drugDeleteRequest, completion: @escaping (Bool) -> Void) {
        DrugProvider.request(.deleteDrug(param: userParameter)) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(false)
            }
        }
    }
}
