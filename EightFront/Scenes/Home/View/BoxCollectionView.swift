//
//  BoxCollectionView.swift
//  EightFront
//
//  Created by wargi on 2022/10/09.
//

import Then
import SnapKit
import UIKit
//MARK: BoxCollectionView
final class BoxCollectionView: UIView {
    //MARK: - Properties
    let thumnailImageView = UIImageView().then {
        $0.image = Images.Map.boxThumnail.image
    }
    let titleLabel = UILabel().then {
        $0.text = "수거함 이름"
        $0.numberOfLines = 1
        $0.font = Fonts.Pretendard.semiBold.font(size: 20)
    }
    let addressLabel = UILabel().then {
        $0.text = "주소"
        $0.numberOfLines = 1
        $0.font = Fonts.Pretendard.regular.font(size: 14)
    }
    let detailLabel = UILabel().then {
        $0.text = "상세주소"
        $0.numberOfLines = 1
        $0.font = Fonts.Pretendard.regular.font(size: 14)
    }
    let fixButton = UIButton().then {
        $0.setTitle("정보 수정")
        $0.setTitleColor(Colors.gray005.color)
        $0.titleLabel?.font = Fonts.Pretendard.regular.font(size: 16)
        $0.layer.borderColor = Colors.gray006.color.cgColor
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
    }
    let navigationButton = UIButton().then {
        $0.setTitle("경로 찾기")
        $0.setTitleColor(Colors.point.color)
        $0.titleLabel?.font = Fonts.Pretendard.regular.font(size: 16)
        $0.layer.backgroundColor = Colors.gray002.color.cgColor
        $0.layer.cornerRadius = 4
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = .white
        clipsToBounds = false
        
        addSubview(thumnailImageView)
        addSubview(titleLabel)
        addSubview(addressLabel)
        addSubview(detailLabel)
        addSubview(fixButton)
        addSubview(navigationButton)
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 38.0
        let fixButtonWidth = screenWidth / 3
        
        thumnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(33)
            $0.left.equalToSuperview().offset(16)
            $0.size.equalTo(83)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.left.equalTo(thumnailImageView.snp.right).offset(20)
            $0.right.equalToSuperview().offset(-16)
        }
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13)
            $0.left.right.equalTo(titleLabel)
        }
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(6)
            $0.left.right.equalTo(addressLabel)
        }
        fixButton.snp.makeConstraints {
            $0.top.equalTo(thumnailImageView.snp.bottom).offset(18)
            $0.left.equalTo(thumnailImageView)
            $0.width.equalTo(fixButtonWidth)
            $0.height.equalTo(50)
        }
        navigationButton.snp.makeConstraints {
            $0.top.equalTo(fixButton)
            $0.left.equalTo(fixButton.snp.right).offset(6)
            $0.right.equalTo(detailLabel.snp.right)
            $0.height.equalTo(50)
        }
        
        layer.applyFigmaShadow(x: 0, y: -4,
                               color: Colors.shadow001.color.withAlphaComponent(0.12),
                               blur: 15.0, spread: -2.0)
    }
}
