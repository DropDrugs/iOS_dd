// Copyright © 2024 RT4. All rights reserved

import UIKit

struct Constants {
    static let seoulDistrictsList: [DistrictsDataModel] = [
            DistrictsDataModel(name: "강남구", image: "강남구", url: "https://www.gangnam.go.kr/board/waste/list.do?mid=ID02_011109#collapse21"),
            DistrictsDataModel(name: "강동구", image: "강동구", url: "https://www.gangdong.go.kr/web/newportal/contents/gdp_005_004_010_001"),
            DistrictsDataModel(name: "강북구", image: "강북구", url: "https://www.gangbuk.go.kr:18000/portal/bbs/B0000089/list.do?menuNo=200294"),
            DistrictsDataModel(name: "강서구", image: "강서구", url: "https://www.gangseo.seoul.kr/env/env010501"),
            DistrictsDataModel(name: "관악구", image: "관악구", url: "https://www.gwanak.go.kr/site/gwanak/09/10903060000002023030704.jsp"),
            DistrictsDataModel(name: "광진구", image: "광진구", url: "https://www.gwangjin.go.kr/dong/bbs/B0000127/view.do?nttId=6197129&menuNo=600909&dongCd=09"),
            DistrictsDataModel(name: "구로구", image: "구로구", url: "https://www.guro.go.kr"),
            DistrictsDataModel(name: "금천구", image: "금천구", url: "https://www.geumcheon.go.kr/portal/contents.do?key=4409"),
            DistrictsDataModel(name: "노원구", image: "노원구", url: "https://www.nowon.kr/dong/user/bbs/BD_selectBbs.do?q_bbsCode=1042&q_bbscttSn=20230713101112740"),
            DistrictsDataModel(name: "도봉구", image: "도봉구", url: "https://www.dobong.go.kr/subsite/waste/Contents.asp?code=10010125"),
            DistrictsDataModel(name: "동대문구", image: "동대문구", url: "https://www.ddm.go.kr/www/contents.do?key=858"),
            DistrictsDataModel(name: "동작구", image: "동작구", url: "https://www.dongjak.go.kr/portal/main/contents.do?menuNo=201627"),
            DistrictsDataModel(name: "마포구", image: "마포구", url: "https://mbs.mapo.go.kr/mapoapp/hotnews_view.asp?idx=16423"),
            DistrictsDataModel(name: "서대문구", image: "서대문구", url: "https://www.sdm.go.kr/health/board/1/10410?activeMenu=0104010000"),
            DistrictsDataModel(name: "서초구", image: "서초구", url: "https://www.seocho.go.kr/site/seocho/04/10414020800002023100603.jsp"),
            DistrictsDataModel(name: "성동구", image: "성동구", url: "https://www.sd.go.kr/main/contents.do?key=4522&"),
            DistrictsDataModel(name: "성북구", image: "성북구", url: "https://www.sb.go.kr/main/cop/bbs/selectBoardArticle.do?bbsId=B0319_main&nttId=9502165&menuNo=94000000&subMenuNo=94110000&thirdMenuNo=&fourthMenuNo="),
            DistrictsDataModel(name: "송파구", image: "송파구", url: "https://www.songpa.go.kr/ehealth/selectBbsNttView.do?nttNo=19240469&pageUnit=10&bbsNo=179&key=4713&pageIndex=1"),
            DistrictsDataModel(name: "양천구", image: "양천구", url: "https://www.yangcheon.go.kr/site/yangcheon/05/10507040000002023122903.jsp"),
            DistrictsDataModel(name: "영등포구", image: "영등포구", url: "https://www.ydp.go.kr/www/contents.do?key=5982&"),
            DistrictsDataModel(name: "용산구", image: "용산구", url: "https://www.yongsan.go.kr/portal/main/contents.do?menuNo=201150"),
            DistrictsDataModel(name: "은평구", image: "은평구", url: "https://www.ep.go.kr/www/contents.do?key=4499"),
            DistrictsDataModel(name: "종로구", image: "종로구", url: "https://www.jongno.go.kr"),
            DistrictsDataModel(name: "중구", image: "중구", url: "https://www.junggu.seoul.kr/content.do?cmsid=15918"),
            DistrictsDataModel(name: "중랑구", image: "중랑구", url: "https://dong.jungnang.go.kr/dong/bbs/view/B0000002/31788?menuNo=500012")
        ]
    static let commonDisposalInfoList : [CommonDisposalDataModel] = []
    
    struct Colors {
        static let black = UIColor(named: "Black")
        static let coralPink = UIColor(named: "CoralPink")
        static let gray800 = UIColor(named: "Gray800")
        static let lightblue = UIColor(named: "Lightblue")
        static let pink = UIColor(named: "Pink")
        static let red = UIColor(named: "Red")
        static let skyblue = UIColor(named: "skyblue")
    }
}