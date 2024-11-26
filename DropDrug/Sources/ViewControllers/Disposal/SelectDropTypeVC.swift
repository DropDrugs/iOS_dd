// Copyright © 2024 RT4. All rights reserved

import Foundation
import UIKit
import SnapKit

class SelectDropTypeVC : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var collectionView: UICollectionView!
    // TODO: 이미지 에셋 추가
    let categories = [
        ("일반 의약품", "OB1"),
        ("병원 처방약", "OB3")
    ]
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  의약품 드롭하기")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        setupView()
    
    }
    
    
    private func setupView() {
        view.backgroundColor = .white
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(KindCollectionViewCell.self, forCellWithReuseIdentifier: "KindCell")
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    // MARK: - Compositional Layout 생성
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        // 패딩과 카드 크기 설정
        let padding: CGFloat = superViewWidth * 0.05
        let cardSize: CGFloat = superViewWidth * 0.85

        // 아이템 크기 설정 (카드의 절대 너비와 높이로 설정)
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cardSize), heightDimension: .absolute(cardSize / 2))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 그룹에 포함된 아이템 간격을 padding으로 설정
        item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: 0, bottom: 0, trailing: -padding)

        // 그룹 설정
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cardSize / 2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: 0, trailing: 0)
        
        // 레이아웃 생성 및 반환
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KindCell", for: indexPath) as? KindCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let (name, backgroundImg) = categories[indexPath.item]
        cell.configure(backgroundImg: backgroundImg, name: name)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            let SelectDrugTypeVC = SelectDrugTypeVC()
            navigationController?.pushViewController(SelectDrugTypeVC, animated: true)
        case 1:
            let SelectDrugTypeVC = SelectDrugTypeVC()
            navigationController?.pushViewController(SelectDrugTypeVC, animated: true)
//            let prescriptionDrugVC = PrescriptionDrugVC()
//            navigationController?.pushViewController(prescriptionDrugVC, animated: true)
        default:
            print("알 수 없는 카테고리 선택됨")
        }
    }
    
    // MARK: Actions
    @objc private func didTapBackButton() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
}
