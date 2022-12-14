//
//  ProfileImageChangeCollectionVIewCell.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/12/03.
//

import UIKit

import Combine

class ProfileImageChangeCollectionViewCell: UICollectionViewCell {
    
    var bag = Set<AnyCancellable>()
    var profileImage: ProfileImage?
    static let identifier = "ProfileImageChangeCollectionViewCell"
    
    let profileView = UIView().then {
        $0.layer.borderColor = Colors.gray006.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let titleLabel = UILabel().then {
        $0.font = Fonts.Templates.caption1.font
        $0.textColor = Colors.gray005.color
    }
    
    override func prepareForReuse() {
        profileView.layer.borderColor = Colors.gray006.color.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: ProfileImage) {
        self.profileImage = item
        titleLabel.text = item.rawValue
        profileImageView.image = item.image
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
