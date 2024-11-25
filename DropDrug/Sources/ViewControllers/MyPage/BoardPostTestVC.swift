// Copyright © 2024 RT4. All rights reserved

import UIKit
import Moya

class BoardPostTestVC: UIViewController {
    //    NoticeData(title: "폐의약품 정보 페이지 안내", content: "현재 일부 지자체에서 폐의약품 분리배출 방법에 대한 공식 안내 홈페이지를 운영하지 않고 있습니다. 해당 지역들은 기본 구청 홈페이지로 연결되며, 관련 홈페이지 생성에 대한 민원 제안을 드렸습니다. 이 부분 참고하시어 <정보> 페이지에서 서울특별시 공통 폐기 방법 안내 페이지를 이용하시기 바랍니다.", date: "2024-11-13T16:25:11.183Z"),
    //    NoticeData(title: "의약품 드롭하기 사진 인증 안내", content: "현재 네이버 클로바 AI의 OCR 분석을 통한 Text 인식을 통해 정확도가 높은 단어만 검출합니다. 의약품 드롭 인증에 실패하신 경우 손글씨로 작성하신 단어의 명확함을 재조정하시어 인증하시길 바랍니다.", date: "2024-11-23T12:25:11.183Z"),
    //    NoticeData(title: "신규 캐릭터 업데이트 안내", content: "신규 캐릭터를 업데이트하였으니 마이페이지 > 캐릭터 변경 창에서 확인하시길 바랍니다.", date: "2024-12-01T10:25:11.183Z"),
    
    let boardProvider = MoyaProvider<BoardService>(plugins: [BearerTokenPlugin(), NetworkLoggerPlugin()])
    
    func setUpData(title : String, content: String) -> AddBoardRequest {
        return AddBoardRequest(content: content, title: title)
    }
    
    func callPostBoard(titleString : String, contentString : String) {
        boardProvider.request(.postBoard(param: setUpData(title: titleString, content: contentString))) { result in
            switch result {
            case .success(let response) :
                print("성공")
            case .failure(let error) :
                print("Error: \(error.localizedDescription)")
                if let response = error.response {
                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllPosts()
//        callPostBoard(titleString: "폐의약품 분리배출 정보 페이지 안내", contentString: "현재 일부 지자체에서 폐의약품 분리배출 방법에 대한 공식 안내 홈페이지를 운영하지 않고 있습니다. 해당 지역들은 기본 구청 홈페이지로 연결되며, 관련 홈페이지 생성에 대한 민원 제안을 드렸습니다. 이 부분 참고하시어 <정보> 페이지에서 서울특별시 공통 폐기 방법 안내 페이지를 이용하시기 바랍니다.")
//        callPostBoard(titleString: "의약품 드롭하기 사진 인증 안내", contentString: "현재 네이버 클로바 AI의 OCR 분석을 통한 Text 인식을 통해 정확도가 높은 단어만 검출합니다. 따라서 손글씨가 첨부된 사진을 통해 의약품 드롭하기 인증을 시도하신 경우, 글자 크기 혹은 글자의 정확도를 다시 조정하신 뒤 인증을 시도하시기 바랍니다.")
//        callPostBoard(titleString: "신규 캐릭터 업데이트 안내", contentString: "신규 캐릭터가 업데이트되었습니다! 마이페이지 > 캐릭터 변경 창에서 신규 캐릭터를 확인하실 수 있습니다.")
    }
    
    func callAllPosts() {
        let posts = [
            ("폐의약품 분리배출 정보 페이지 안내",
             "현재 일부 지자체에서 폐의약품 분리배출 방법에 대한 공식 안내 홈페이지를 운영하지 않고 있습니다. 해당 지역들은 기본 구청 홈페이지로 연결되며, 관련 홈페이지 생성에 대한 민원 제안을 드렸습니다. 이 부분 참고하시어 <정보> 페이지에서 서울특별시 공통 폐기 방법 안내 페이지를 이용하시기 바랍니다."),
            
            ("의약품 드롭하기 사진 인증 안내",
             "현재 네이버 클로바 AI의 OCR 분석을 통한 Text 인식을 통해 정확도가 높은 단어만 검출합니다. 따라서 손글씨가 첨부된 사진을 통해 의약품 드롭하기 인증을 시도하신 경우, 글자 크기 혹은 글자의 정확도를 다시 조정하신 뒤 인증을 시도하시기 바랍니다."),
            
            ("신규 캐릭터 업데이트 안내",
             "신규 캐릭터가 업데이트되었습니다! 마이페이지 > 캐릭터 변경 창에서 신규 캐릭터를 확인하실 수 있습니다.")
        ]
        
        for (index, post) in posts.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 10.0) {
                self.callPostBoard(titleString: post.0, contentString: post.1)
            }
        }
    }
}
