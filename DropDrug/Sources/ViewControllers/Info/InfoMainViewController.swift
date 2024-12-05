// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit
import SafariServices

class InfoMainViewController: UIViewController {
    
    let sortedCommonList = Constants.commonDisposalInfoList.sorted { fir, sec in
        return fir.name < sec.name
    }
    
    let sortedSeoulList = Constants.seoulDistrictsList.sorted { fir, sec in
        return fir.name < sec.name
    }

    public lazy var logoLabelView: UILabel = {
        let label = UILabel()
        label.text = "DropDrug"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.roRegularFont(ofSize: 26)
        label.textColor = Constants.Colors.skyblue
        return label
    }()
    
    public lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.showsVerticalScrollIndicator = false
        s.showsHorizontalScrollIndicator = false
        return s
    }()
    
    public lazy var contentView: UIView = {
        let v = UIView()
        return v
    }()
    
    //private let subLabel1View = SubLabelView()
    public lazy var subLabel1View: UILabel = {
        let label = UILabel()
        label.text = "공통 폐기 방법"
        label.textAlignment = .center
        label.font = UIFont.ptdSemiBoldFont(ofSize: 17)
        label.textColor = Constants.Colors.gray900
        return label
    }()
    
    //private let subLabel2View = SubLabelView()
    public lazy var subLabel2View: UILabel = {
        let label = UILabel()
        label.text = "서울특별시 구 별 폐기 방법"
        label.textAlignment = .center
        label.font = UIFont.ptdSemiBoldFont(ofSize: 17)
        label.textColor = Constants.Colors.gray900
        return label
    }()
    
    var commonPageCollectionView: UICollectionView!
    let commonLayout = UICollectionViewFlowLayout()
    
    lazy var seoulPageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let itemsPerRow: CGFloat = 4
        let totalSpacing = (screenWidth / (itemsPerRow * 2 - 1))*0.6
        let itemWidth = (screenWidth - totalSpacing * 3)/4
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth) // 셀 크기 설정
        layout.minimumInteritemSpacing = totalSpacing * 0.5 // 셀 사이의 간격 설정
        layout.minimumLineSpacing = totalSpacing * 0.3 // 줄 사이의 간격 설정 (1:2 비율)
        layout.sectionInset = UIEdgeInsets(top: 0, left: totalSpacing * 0.3, bottom: 0, right: totalSpacing * 0.5) // 좌우 여백 설정
        

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = Constants.Colors.white
        collectionView.isScrollEnabled = false
        collectionView.register(SeoulCollectionViewCell.self, forCellWithReuseIdentifier: "SeoulCollectionViewCell")
        collectionView.tag = 1

        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.Colors.white
        setNavigationBar()
        setCommonCollectionView()
        setCommonCollectionViewLayout()
        setComponentsLayout()
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setComponentsLayout() {
        //subLabel1View.text = "공통 폐기 방법"
        //subLabel2View.text = "서울특별시 구 별 폐기 방법"
        [logoLabelView, scrollView].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentView)
        [subLabel1View, commonPageCollectionView, subLabel2View, seoulPageCollectionView].forEach {
            contentView.addSubview($0)
        }
        setLayout()
    }
    
    func setCommonCollectionView() {
        commonPageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: commonLayout)
        commonPageCollectionView.dataSource = self
        commonPageCollectionView.delegate = self
        commonPageCollectionView.backgroundColor = Constants.Colors.white
        commonPageCollectionView.register(KindCollectionViewCell.self, forCellWithReuseIdentifier: "KindCollectionViewCell")
        commonPageCollectionView.tag = 0
        commonPageCollectionView.showsHorizontalScrollIndicator = false
        commonPageCollectionView.showsVerticalScrollIndicator = false
    }
    
    func setCommonCollectionViewLayout() {
        commonLayout.scrollDirection = .horizontal // 가로 스크롤 설정
        commonLayout.minimumLineSpacing = 16 // 아이템 간 간격 설정
        commonLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func setLayout() {
        logoLabelView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(logoLabelView.snp.bottom).offset(13)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView) // 스크롤뷰의 모든 가장자리에 맞춰 배치
            make.width.equalTo(scrollView) // 가로 스크롤을 방지, 스크롤뷰와 같은 너비로 설정
        }
        
        subLabel1View.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.leading.equalToSuperview().inset(20)
        }
        
        commonPageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subLabel1View.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(160)
        }
        
        subLabel2View.snp.makeConstraints { make in
            make.top.equalTo(commonPageCollectionView.snp.bottom).offset(59)
            make.leading.equalToSuperview().inset(20)
        }
        
        seoulPageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subLabel2View.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(850)
            make.bottom.equalToSuperview().offset(-15)
        }
        
//        contentView.snp.makeConstraints { make in
//            make.bottom.equalTo(seoulPageCollectionView.snp.bottom).offset(15)
//        }
    }
}

extension InfoMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var urlString : String = ""
        if collectionView.tag == 0 {
            urlString = self.sortedCommonList[indexPath.row].url
        }
        else if collectionView.tag == 1 {
            urlString = self.sortedSeoulList[indexPath.row].url
        }
        if let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return sortedCommonList.count
        }
        else if collectionView.tag == 1 {
            return sortedSeoulList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KindCollectionViewCell", for: indexPath) as? KindCollectionViewCell else {
                return KindCollectionViewCell()
            }
            
            cell.configure(backgroundImg: sortedCommonList[indexPath.row].image, name: sortedCommonList[indexPath.row].name)
            
            return cell
        }
        else if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeoulCollectionViewCell", for: indexPath) as? SeoulCollectionViewCell else {
                return SeoulCollectionViewCell()
            }
            
            cell.image.image = UIImage(named: sortedSeoulList[indexPath.row].image)
            cell.name.text = sortedSeoulList[indexPath.row].name
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            let cardSize = superViewWidth * 0.4
            return CGSize(width: cardSize, height: cardSize) // 아이템 크기 설정
        }
        else if collectionView.tag == 1 {
            let screenWidth = UIScreen.main.bounds.width
            let itemsPerRow: CGFloat = 4
            let totalSpacing = (screenWidth / (itemsPerRow * 2 - 1))*0.6
            let itemWidth = (screenWidth - totalSpacing * 3)/4
            return CGSize(width: itemWidth, height: itemWidth * 1.25) // 원하는 높이 비율로 설정
        }
        return CGSize()
    }
    
}
