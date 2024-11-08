// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class InfoMainViewController: UIViewController {
    
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
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.register(SeoulCollectionViewCell.self, forCellWithReuseIdentifier: "SeoulCollectionViewCell")
        collectionView.tag = 1

        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
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
        commonPageCollectionView.backgroundColor = .white
        commonPageCollectionView.register(KindCollectionViewCell.self, forCellWithReuseIdentifier: "KindCollectionViewCell")
        commonPageCollectionView.tag = 0
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
            make.height.equalTo(742)
            make.bottom.equalToSuperview().offset(-15)
        }
        
//        contentView.snp.makeConstraints { make in
//            make.bottom.equalTo(seoulPageCollectionView.snp.bottom).offset(15)
//        }
    }
}

extension InfoMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return Constants.commonDisposalInfoList.count
        }
        else if collectionView.tag == 1 {
            return SeoulModel.list().count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KindCollectionViewCell", for: indexPath) as? KindCollectionViewCell else {
                return KindCollectionViewCell()
            }
            
            cell.configure(backgroundImg: Constants.commonDisposalInfoList[indexPath.row].name, name: Constants.commonDisposalInfoList[indexPath.row].name)
            
            return cell
        }
        else if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeoulCollectionViewCell", for: indexPath) as? SeoulCollectionViewCell else {
                return SeoulCollectionViewCell()
            }
            
            let list = SeoulModel.list()
            
            cell.image.image = UIImage(named: list[indexPath.row].image)
            cell.name.text = list[indexPath.row].name
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: 160, height: 160) // 아이템 크기 설정
        }
        else if collectionView.tag == 1 {
            return CGSize(width: 84, height: 106)
        }
        return CGSize()
    }
    
}
