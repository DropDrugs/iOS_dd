// Copyright © 2024 RT4. All rights reserved

import UIKit
import SnapKit

class SelectDrugTypeVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var collectionView: UICollectionView!
    
    struct DrugCategory {
        let id: Int           // 고유 인덱스
        let name: String      // 이름
        let imageName: String // 이미지 에셋 이름
        let backgroundColor: UIColor // 배경색
    }
    
    let categories: [DrugCategory] = [
        DrugCategory(id: 0, name: "알약", imageName: "알약", backgroundColor: Constants.Colors.skyblue!.withAlphaComponent(0.4)),
        DrugCategory(id: 1, name: "물약", imageName: "물약", backgroundColor: Constants.Colors.coralpink!.withAlphaComponent(0.4)),
        DrugCategory(id: 2, name: "연고", imageName: "연고", backgroundColor: Constants.Colors.lightblue!.withAlphaComponent(0.4)),
        DrugCategory(id: 3, name: "가루약", imageName: "가루약", backgroundColor: Constants.Colors.pink!.withAlphaComponent(0.4))
    ]
    
    private lazy var backButton: CustomBackButton = {
        let button = CustomBackButton(title: "  종류 선택")
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("폐기 인증하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.skyblue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(confirmSelection), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        // 뒤로 가기 버튼 추가
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DrugTypeCollectionViewCell.self, forCellWithReuseIdentifier: "DrugTypeCell")
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        
        view.addSubview(collectionView)
        view.addSubview(confirmButton)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerX.equalToSuperview()
            make.width.equalTo(superViewWidth * 0.9)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Compositional Layout 생성
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let padding: CGFloat = 16
        let cardSize: CGFloat = (UIScreen.main.bounds.width - padding * 3) / 2

        // 아이템 크기 설정
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cardSize), heightDimension: .absolute(cardSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

        // 그룹 설정 (한 줄에 두 개의 카드)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cardSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(padding)

        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrugTypeCell", for: indexPath) as? DrugTypeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.item]
        cell.configure(
            title: category.name,
            assetName: category.imageName,
            backgroundColor: category.backgroundColor
        )
        
        print("Drug ID: \(category.id)") // 고유 ID 확인
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.item]
        print("Selected: \(selectedCategory.id)")
        
        // 선택된 셀을 스타일 변경 (예: 배경 강조)
        if let cell = collectionView.cellForItem(at: indexPath) as? DrugTypeCollectionViewCell {
            cell.contentView.layer.borderColor = Constants.Colors.red?.cgColor
            cell.contentView.layer.borderWidth = 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.item]
        print("Deselected: \(selectedCategory.id)")
        
        // 선택 해제된 셀의 스타일 복구
        if let cell = collectionView.cellForItem(at: indexPath) as? DrugTypeCollectionViewCell {
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.borderWidth = 0
        }
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func moveToMainScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func confirmSelection() {
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else { return }
        
        let selectedCategories = selectedIndexPaths.map { categories[$0.item] }
        
        print("선택된 약물:")
        for category in selectedCategories {
            print("ID: \(category.id)")
        }
        
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
            showAlert(title: "오류", message: "카메라를 사용할 수 없습니다.")
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            print("이미지를 선택했습니다: \(selectedImage)")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
