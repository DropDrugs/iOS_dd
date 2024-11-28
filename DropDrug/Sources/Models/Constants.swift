// Copyright © 2024 RT4. All rights reserved

import UIKit

struct Constants {
    static var currentPosition : String = ""
    static let disposalGuide = """
    전용 수거함 및 우체통 : 모든 약을 봉투에 모아서 배출(겉표기에 ‘폐의약품’ 표시 후 배출)하거나 전용 봉투를 주민센터나 우체국에서 받아서 사용
    - 물약 : 마개를 잘 잠그고 용기 그대로 배출. (우체통에 배출 불가)
    - 알약(조제약) : 포장지 그대로 개봉하지 말고 배출
    - 알약(정제형) : 겉 포장지(종이)만 제거 후 플라스틱 등으로 포장된 알약은 개봉하지 말고 배출
    - 가루약 : 포장된 상태 그대로 배출
    - 특수용기 : 연고, 천식 흡입제, 스프레이 등 겉포장(종이)박스만 제거 후 마개를 잠그고 용기 그대로 배출
    - 폐의약품 수거함에 버리면 안되는 물품 : 폐의약품 외 물품(홍삼, 자양강장제 등)
    """
    
    struct NetworkManager {
        static let baseURL = "http://54.180.45.153:8080/"
        static let OCRSecretKey = "Uk1PYVR2RFVaYWVHRlpxcWpxRVZkQUl0bHRvTGpCU3Q="
        static let OCRAPIURL = "https://slpfshoip0.apigw.ntruss.com/custom/v1/36244/694e6b5877aed073a41eb1c45d2be8b6126ed5808e1311a2e48e5800ccdd233f"
    }
    
    static let CharacterList: [CharacterModel] = [
        CharacterModel(id: 0, name: "웃는 드롭이", image: "char0" , price: 0),
        CharacterModel(id: 1, name: "화난 드롭이", image: "char1", price: 0),
        CharacterModel(id: 2, name: "난처 드롭이", image: "char2", price: 0),
        CharacterModel(id: 3, name: "미안 드롭이", image: "char3", price: 0),
        CharacterModel(id: 4, name: "웃는 드럭이", image: "char4", price: 0),
        CharacterModel(id: 5, name: "화난 드럭이", image: "char5", price: 0),
        CharacterModel(id: 6, name: "난처 드럭이", image: "char6", price: 0),
        CharacterModel(id: 7, name: "미안 드럭이", image: "char7", price: 0)
    ]

    static let seoulDistrictsList: [DistrictsDataModel] = [
            DistrictsDataModel(name: "강남구", image: "Gangnam", url: "https://www.gangnam.go.kr/board/waste/list.do?mid=ID02_011109#collapse21"),
            DistrictsDataModel(name: "강동구", image: "Gangdong", url: "https://www.gangdong.go.kr/web/newportal/contents/gdp_005_004_010_001"),
            DistrictsDataModel(name: "강북구", image: "Gangbuk", url: "https://www.gangbuk.go.kr:18000/portal/bbs/B0000089/list.do?menuNo=200294"),
            DistrictsDataModel(name: "강서구", image: "Gangseo", url: "https://www.gangseo.seoul.kr/env/env010501"),
            DistrictsDataModel(name: "관악구", image: "Gwanak", url: "https://www.gwanak.go.kr/site/gwanak/09/10903060000002023030704.jsp"),
            DistrictsDataModel(name: "광진구", image: "Gwangjin", url: "https://www.gwangjin.go.kr/dong/bbs/B0000127/view.do?nttId=6197129&menuNo=600909&dongCd=09"),
            DistrictsDataModel(name: "구로구", image: "Guro", url: "https://www.guro.go.kr"),
            DistrictsDataModel(name: "금천구", image: "Geumcheon", url: "https://www.geumcheon.go.kr/portal/contents.do?key=4409"),
            DistrictsDataModel(name: "노원구", image: "Nowon", url: "https://www.nowon.kr/dong/user/bbs/BD_selectBbs.do?q_bbsCode=1042&q_bbscttSn=20230713101112740"),
            DistrictsDataModel(name: "도봉구", image: "Dobong", url: "https://www.dobong.go.kr/subsite/waste/Contents.asp?code=10010125"),
            DistrictsDataModel(name: "동대문구", image: "Dongdaemun", url: "https://www.ddm.go.kr/www/contents.do?key=858"),
            DistrictsDataModel(name: "동작구", image: "Dongjak", url: "https://www.dongjak.go.kr/portal/main/contents.do?menuNo=201627"),
            DistrictsDataModel(name: "마포구", image: "Mapo", url: "https://mbs.mapo.go.kr/mapoapp/hotnews_view.asp?idx=16423"),
            DistrictsDataModel(name: "서대문구", image: "Seodaemun", url: "https://www.sdm.go.kr/health/board/1/10410?activeMenu=0104010000"),
            DistrictsDataModel(name: "서초구", image: "Seocho", url: "https://www.seocho.go.kr/site/seocho/04/10414020800002023100603.jsp"),
            DistrictsDataModel(name: "성동구", image: "Seongdong", url: "https://www.sd.go.kr/main/contents.do?key=4522&"),
            DistrictsDataModel(name: "성북구", image: "Seongbuk", url: "https://www.sb.go.kr/main/cop/bbs/selectBoardArticle.do?bbsId=B0319_main&nttId=9502165&menuNo=94000000&subMenuNo=94110000&thirdMenuNo=&fourthMenuNo="),
            DistrictsDataModel(name: "송파구", image: "Songpa", url: "https://www.songpa.go.kr/ehealth/selectBbsNttView.do?nttNo=19240469&pageUnit=10&bbsNo=179&key=4713&pageIndex=1"),
            DistrictsDataModel(name: "양천구", image: "Yangcheon", url: "https://www.yangcheon.go.kr/site/yangcheon/05/10507040000002023122903.jsp"),
            DistrictsDataModel(name: "영등포구", image: "Yeongdeungpo", url: "https://www.ydp.go.kr/www/contents.do?key=5982&"),
            DistrictsDataModel(name: "용산구", image: "Yongsan", url: "https://www.yongsan.go.kr/portal/main/contents.do?menuNo=201150"),
            DistrictsDataModel(name: "은평구", image: "Eunpyeong", url: "https://www.ep.go.kr/www/contents.do?key=4499"),
            DistrictsDataModel(name: "종로구", image: "Jongno", url: "https://www.jongno.go.kr"),
            DistrictsDataModel(name: "중구", image: "Jung", url: "https://www.junggu.seoul.kr/content.do?cmsid=15918"),
            DistrictsDataModel(name: "중랑구", image: "Jungnang", url: "https://dong.jungnang.go.kr/dong/bbs/view/B0000002/31788?menuNo=500012")
        ]
    static let commonDisposalInfoList : [CommonDisposalDataModel] = [
        CommonDisposalDataModel(name: "서울특별시", image: "Seoul", url: "https://news.seoul.go.kr/env/archives/525122?listPage=1&s=%ED%8F%90%EC%9D%98%EC%95%BD%ED%92%88"),
        CommonDisposalDataModel(name: "세종특별자치시", image: "Sejong", url: "https://www.sejong.go.kr/recycle/sub03_04_02.do;jsessionid=07F33847FC24393EEC5EA67FF3E3BFAC.portal1"),
        CommonDisposalDataModel(name: "강원도 동해시", image: "Donghae", url: "https://www.dh.go.kr/www/contents.do?key=797"),
        CommonDisposalDataModel(name: "전라남도 나주시", image: "Naju", url: "https://www.naju.go.kr/www/field_info/environment/dedicated/medical"),
        CommonDisposalDataModel(name: "전라북도 임실군", image: "Imsil", url: "https://www.imsil.go.kr/board/view.imsil?menuCd=DOM_000000103001008000&boardId=BBS_0000025&dataSid=112737"),
        CommonDisposalDataModel(name: "전라북도 순창군", image: "Sunchang", url: "https://www.sunchang.go.kr/index.sunchang?menuCd=DOM_000000105004003002"),
        CommonDisposalDataModel(name: "광주광역시 광산구", image: "Gwangsan", url: "https://www.gwangsan.go.kr/health/boardView.do?boardId=BINFO&pageId=health172&searchSn=202"),
        CommonDisposalDataModel(name: "광주광역시 동구", image: "Dong", url: "https://www.donggu.kr/board.es?mid=a10101010000&bid=0001&act=view&list_no=36859"),
        CommonDisposalDataModel(name: "강원도 삼척시", image: "Samcheok", url: "https://www.samcheok.go.kr/main.web")
        
    ]
    
    struct Colors {
        static let black = UIColor(named: "black")
        static let white = UIColor(named: "white")
        static let coralpink = UIColor(named: "coralpink")
        static let gray0 = UIColor(named: "gray0")
        static let gray100 = UIColor(named: "gray100")
        static let gray200 = UIColor(named: "gray200")
        static let gray300 = UIColor(named: "gray300")
        static let gray400 = UIColor(named: "gray400")
        static let gray500 = UIColor(named: "gray500")
        static let gray600 = UIColor(named: "gray600")
        static let gray700 = UIColor(named: "Gray700")
        static let gray800 = UIColor(named: "gray800")
        static let gray900 = UIColor(named: "Gray900")
        static let lightblue = UIColor(named: "lightblue")
        static let pink = UIColor(named: "pink")
        static let red = UIColor(named: "red")
        static let skyblue = UIColor(named: "skyblue")
    }
    
}
