//
//  ProfileImageChangeCollectionVIewCell.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/12/03.
//

import UIKit

class ProfileImageChangeCollectionViewCell: UICollectionViewCell {
    
    let viewModel = ProfileImageChangeViewModel()
    
    static let identifier = "ProfileImageChangeCollectionViewCell"
    
    private let profileView = UIView().then {
        $0.layer.borderColor = Colors.gray006.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    private let profileImageView = UIImageView().then {
        let image = UIImage(systemName: "person")
        $0.image = image
        
        $0.contentMode = .scaleAspectFill
        
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Fonts.Templates.caption1.font
        $0.textColor = Colors.gray005.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: ProfileImage) {
        titleLabel.text = item.imageName
        guard let imageULR = URL(string: item.imageURLStr) else { return }
        profileImageView.kf.setImage(with: imageULR)
    }
    
    private func makeUI() {
        addSubview(profileView)
        profileView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(109)
            
            profileView.addSubview(profileImageView)
            profileImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(70)
            }
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}
