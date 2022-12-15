//
//  ProfileImageChangeVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/12/03.
//

import UIKit

final class ProfileImageChangeVC: UIViewController {
    
    let viewModel = ProfileImageChangeViewModel()
    
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "프로필 이미지"
    }
    
    private let profileImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().then {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let selectedProfileView = UIView()
    private let selectedProfileImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = Colors.gray001.color.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = Colors.gray008.color
    }
    private let selectedProfileImage = UIImageView().then {
        $0.image = Images.dropIcon.image
        $0.contentMode = .scaleAspectFill
    }
    
    private let selectedTitlaLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = Fonts.Templates.body2.font
        $0.textColor = Colors.gray005.color
        $0.text = "현재\n"+"개인 이미지"+" 사용 중"
    }
    
    private let diver = UIView().then {
        $0.backgroundColor = Colors.gray008.color
    }
    
    private let changeButton = UIButton().then {
        $0.setTitle("변경하기")
        $0.setTitleColor(Colors.point.color, for: .normal)
        $0.setBackgroundColor(Colors.gray001.color, for: .normal)
        
        $0.setTitleColor(UIColor.white, for: .disabled)
        $0.setBackgroundColor(Colors.gray006.color, for: .disabled)
        
        $0.layer.cornerRadius = 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        configure()
        bind()
    }
    // MARK: - configure {
    private func configure() {
        profileImageCollectionView.register(ProfileImageChangeCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageChangeCollectionViewCell.identifier)
        profileImageCollectionView.delegate = self
        profileImageCollectionView.dataSource = self
    }
    
    // MARK: - makeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        view.addSubview(selectedProfileView)
        selectedProfileView.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(140)
            
            selectedProfileView.addSubview(selectedProfileImageView)
            selectedProfileImageView.snp.makeConstraints {
                $0.width.equalTo(163)
                $0.height.equalTo(109)
                $0.top.equalToSuperview().inset(16)
                $0.left.equalToSuperview().inset(16)
            }
            
            selectedProfileImageView.addSubview(selectedProfileImage)
            selectedProfileImage.snp.makeConstraints {
                $0.size.equalTo(70)
                $0.center.equalToSuperview()
            }
            
            selectedProfileView.addSubview(selectedTitlaLabel)
            selectedTitlaLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(selectedProfileImageView.snp.right).offset(16)
            }
        }
        
        view.addSubview(diver)
        diver.snp.makeConstraints {
            $0.top.equalTo(selectedProfileView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        view.addSubview(changeButton)
        changeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.bottom.equalToSuperview().inset(35)
            $0.height.equalTo(58)
        }
        
        view.addSubview(profileImageCollectionView)
        profileImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(diver.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(changeButton.snp.top)
        }
    }
    
    private func bind() {
        viewModel.$selectedImage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] profileImage in
                let image = profileImage.image
                self?.selectedProfileImage.image = image
                
                let label = "현재\n"+profileImage.rawValue+" 사용 중"
                self?.selectedTitlaLabel.text = label
                
                self?.profileImageCollectionView.reloadData()
                
            }.store(in: &viewModel.bag)
        
        viewModel.isChangeButtonValid.receive(on: DispatchQueue.main)
            .sink { [weak self] isButtonValid in
                self?.changeButton.isEnabled = isButtonValid
            }.store(in: &viewModel.bag)
        
        changeButton.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &viewModel.bag)
        
    }
}

extension ProfileImageChangeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath: indexPath)
    }
}

extension ProfileImageChangeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileImageChangeCollectionViewCell.identifier,
                for: indexPath
            ) as? ProfileImageChangeCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let item = viewModel.cellForItemAt(indexPath: indexPath)
        cell.configure(item: item)
        
        if viewModel.selectedImage == item {
            cell.profileView.layer.borderColor = Colors.gray001.color.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 48) / 2
        let hieght = CGFloat(131)
        return CGSize(width: width, height: hieght)
    }
    
}


