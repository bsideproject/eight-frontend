//
//  FilterView.swift
//  EightFront
//
//  Created by wargi on 2022/11/05.
//

import Then
import SnapKit
import UIKit
//MARK: 버릴까말까 선택 ChoiceView
final class FilterView: UIView {
    //MARK: - Properties
    let backgroundImageView = UIImageView().then {
        $0.image = Images.Trade.filterBackground.image
    }
    let titleLabel = UILabel().then {
        $0.font = Fonts.Templates.body2.font
    }
    let bottomArrowImage = UIImageView().then {
        let image = Images.Trade.bottomArrow.image.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
        $0.image = image
        $0.tintColor = Colors.gray005.color
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = .clear
        
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(bottomArrowImage)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-9)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(22)
        }
        bottomArrowImage.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(6)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(12)
            $0.height.equalTo(6)
        }
    }
}
