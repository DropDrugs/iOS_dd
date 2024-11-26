// Copyright © 2024 RT4. All rights reserved

import Foundation
import Moya

extension CharacterSettingsVC {
    func fetchMemberInfo(completion: @escaping (Bool) -> Void) {
        MemberProvider.request(.fetchMemberInfo) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(MemberInfo.self)
                    self.ownedChar = data.ownedChars
                    self.selectedChar = data.selectedChar
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
    
    func purchaseCharacter(_ index: Int, completion: @escaping (Bool) -> Void) {
        MemberProvider.request(.purchaseCharacter(characterId: index)) { result in
            switch result {
            case .success(let response):
                do {
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
    
    func updateCharacter(_ index: Int, completion: @escaping (Bool) -> Void) {
        MemberProvider.request(.updateCharacter(characterId: index)) { result in
            switch result {
            case .success(let response):
                do {
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
