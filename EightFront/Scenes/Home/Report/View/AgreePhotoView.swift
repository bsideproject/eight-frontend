//
//  AgreePhotoView.swift
//  EightFront
//
//  Created by wargi on 2022/10/10.
//

import Then
import SnapKit
import UIKit
//MARK: AgreePhotoView
final class AgreePhotoView: UIView {
    //MARK: - Properties
    @Published var isSelected: Bool = false {
        didSet {
            checkboxImageView.image = isSelected ? Images.Report.checkboxSelect.image : Images.Report.checkboxNone.image
        }
    }
    let checkboxImageView = UIImageView().then {
        $0.image = Images.Report.checkboxNone.image
    }
    let titleLabel = UILabel().then {
        $0.text = "이미지 저작권 동의(필수)"
        $0.textColor = Colors.gray005.color
        $0.font = Fonts.Templates.caption1.font
    }
    let descriptionLabel = UILabel().then {
        $0.text = "등록된 이미지는 제보 내용 확인을 위해 사용됩니다."
        $0.textColor = Colors.gray005.color
        $0.font = Fonts.Templates.caption1.font
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
        addSubview(checkboxImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        checkboxImageView.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.size.equalTo(16)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(checkboxImageView.snp.right).offset(6)
            $0.right.equalToSuperview()
            $0.centerY.equalTo(checkboxImageView.snp.centerY)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(checkboxImageView.snp.bottom).offset(5)
            $0.left.right.equalToSuperview()
        }
    }
}
