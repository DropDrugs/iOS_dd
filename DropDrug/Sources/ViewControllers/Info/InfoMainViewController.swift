// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class InfoMainViewController: UIViewController {
    
    private let logoLabelView = LogoLabelView()
    
    var commonPageCollectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setCollectionView()
        setCollectionViewLayout()
        
        setComponentsLayout()
    }
    
    func setComponentsLayout() {
        view.addSubview(logoLabelView)
        view.addSubview(commonPageCollectionView)
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(44)
        }
        
        commonPageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(logoLabelView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(180)
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
