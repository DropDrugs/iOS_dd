// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class InfoMainViewController: UIViewController {
    
    private let logoLabelView = LogoLabelView()
    private let subLabel1View = SubLabelView()
    private let subLabel2View = SubLabelView()
    
    var commonPageCollectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationBar()
        setCollectionView()
        setCollectionViewLayout()
        setComponentsLayout()
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setComponentsLayout() {
        subLabel1View.text = "공통 폐기 방법"
        subLabel2View.text = "서울특별시 구 별 폐기 방법"
        [logoLabelView, commonPageCollectionView, subLabel1View, subLabel2View].forEach {
            view.addSubview($0)
        }
        setLayout()
    }
    
    func setCollectionView() {
        commonPageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        commonPageCollectionView.dataSource = self
        commonPageCollectionView.delegate = self
        commonPageCollectionView.backgroundColor = .white
        commonPageCollectionView.register(KindCollectionViewCell.self, forCellWithReuseIdentifier: "KindCollectionViewCell")
    }
    
    func setCollectionViewLayout() {
        layout.scrollDirection = .horizontal // 가로 스크롤 설정
        layout.minimumLineSpacing = 16 // 아이템 간 간격 설정
    }
    
    func setLayout() {
        logoLabelView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subLabel1View.snp.makeConstraints { make in
            make.top.equalTo(logoLabelView.snp.bottom).offset(33)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        commonPageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subLabel1View.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(180)
        }
        
        subLabel2View.snp.makeConstraints { make in
            make.top.equalTo(commonPageCollectionView.snp.bottom).offset(33)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

extension InfoMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.commonDisposalInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KindCollectionViewCell", for: indexPath) as? KindCollectionViewCell else {
            return KindCollectionViewCell()
        }
        
        cell.configure(backgroundImg: Constants.commonDisposalInfoList[indexPath.row].name, name: Constants.commonDisposalInfoList[indexPath.row].name)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 160) // 아이템 크기 설정
    }
    
}
