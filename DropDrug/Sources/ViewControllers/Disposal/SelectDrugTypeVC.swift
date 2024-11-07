// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class SelectDrugTypeVC : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var collectionView: UICollectionView!
    
    let categories = [
        ("알약", "OB1"),
        ("물약", "OB1"),
        ("처방약", "OB1"),
        ("가루약", "OB1"),
        ("연고", "OB1"),
        ("기타", "OB1")
    ]

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left")?.withTintColor(UIColor(named: "gray500") ?? .systemGray , renderingMode: .alwaysOriginal), for: .normal)
        button.setTitle("  의약품 드롭하기", for: .normal) // 필요시 제목 설정
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.ptdBoldFont(ofSize: 24)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        setupView()
    }
    
    private func setupView() {
        view.addSubview(backButton)
        view.backgroundColor = .white
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(KindCollectionViewCell.self, forCellWithReuseIdentifier: "KindCell")
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
    }
    
    // MARK: - Compositional Layout 생성
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        // 패딩과 카드 크기 설정
        let padding: CGFloat = superViewWidth * 0.05
        let cardSize: CGFloat = superViewWidth * 0.425

        // 아이템 크기 설정 (카드의 절대 너비와 높이로 설정)
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cardSize), heightDimension: .absolute(cardSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 그룹에 포함된 아이템 간격을 padding으로 설정
        item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: 0, bottom: 0, trailing: 0)

        // 그룹 설정 (한 줄에 두 개의 아이템)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cardSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(padding) // 그룹 내 간격을 일정하게 설정

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
        // Alert 창 띄우기
        let alert = UIAlertController(title: "실천 사진 인증", message: "실시간 사진 인증을 하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel) { [weak self] _ in
            self?.moveToMainScreen()
        })
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            self?.presentCamera()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("카메라를 사용할 수 없습니다.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            // 선택된 이미지를 처리하는 코드 추가
            print("이미지를 선택했습니다: \(selectedImage)")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func moveToMainScreen() {
        navigationController?.popViewController(animated: true)
    }
    
}
