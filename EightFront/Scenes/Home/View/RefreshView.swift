//
//  RefreshView.swift
//  EightFront
//
//  Created by wargi on 2022/12/05.
//

import Then
import SnapKit
import UIKit
//MARK: 이 지역 재검색
final class RefreshView: UIView {
    //MARK: - Properties
    let titleLabel = UILabel().then {
        $0.text = "이 지역 재검색"
        $0.textColor = Colors.gray002.color
        $0.font = Fonts.Pretendard.medium.font(size: 12)
    }
    let logoImageView = UIImageView().then {
        let image = Images.Home.refresh.image
        $0.image = image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .black
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
        layer.borderWidth = 1.0
        layer.borderColor = Colors.gray006.color.cgColor
        layer.cornerRadius = 13
        
        addSubview(titleLabel)
        addSubview(logoImageView)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-5.88)
            $0.centerY.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(2.08)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(9.7)
            $0.height.equalTo(10.56)
        }
    }
}
