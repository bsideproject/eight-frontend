//
//  BottomAddressView.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import Then
import SnapKit
import UIKit
//MARK: BottomAddressView
final class BottomAddressView: UIView {
    //MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.text = "의류 수거함 주소"
        $0.font = Fonts.Pretendard.semiBold.font(size: 16)
    }
    let addressLabel = UILabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = Colors.gray008.color
        $0.font = Fonts.Templates.subheader.font
        $0.textColor = Colors.gray001.color
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    let submitButton = UIButton().then {
        $0.setTitle("등록하기")
        $0.setTitleColor(Colors.point.color)
        $0.titleLabel?.font = Fonts.Templates.subheader.font
        $0.backgroundColor = Colors.gray002.color
        $0.layer.cornerRadius = 4
    }
    private let editImageView = UIImageView().then {
        $0.image = Images.Map.boxEdit.image
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
        clipsToBounds = false
        backgroundColor = .white
        layer.cornerRadius = 8.0
        
        addSubview(titleLabel)
        addSubview(addressLabel)
        addSubview(editImageView)
        addSubview(submitButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(16)
        }
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
        editImageView.snp.makeConstraints {
            $0.centerY.equalTo(addressLabel.snp.centerY)
            $0.right.equalTo(addressLabel.snp.right).offset(-16)
            $0.width.equalTo(23)
            $0.height.equalTo(24)
        }
        submitButton.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(25)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(58)
        }
        
        layer.applyFigmaShadow(x: 0, y: -4,
                               color: Colors.shadow001.color.withAlphaComponent(0.12),
                               blur: 15.0, spread: -2.0)
    }
}
