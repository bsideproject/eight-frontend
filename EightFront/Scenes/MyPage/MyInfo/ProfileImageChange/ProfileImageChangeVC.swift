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
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        configure()
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
        
        view.addSubview(profileImageCollectionView)
        profileImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ProfileImageChangeVC: UICollectionViewDelegateFlowLayout {
    
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 48) / 2
        let hieght = CGFloat(131)
        return CGSize(width: width, height: hieght)
    }
    
}


