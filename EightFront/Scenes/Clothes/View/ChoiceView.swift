//
//  ChoiceView.swift
//  EightFront
//
//  Created by wargi on 2022/11/05.
//

import Then
import SnapKit
import UIKit
//MARK: 버릴까말까 선택 ChoiceView
final class ChoiceView: UIView {
    //MARK: - Properties
    let imageView = UIImageView()
    let titleLabel = UILabel().then {
        $0.font = Fonts.Templates.body2.font
    }
    
    //MARK: - Initializer
    init(isLeftImage: Bool) {
        super.init(frame: .zero)
        
        makeUI(isLeftImage: isLeftImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI(isLeftImage: Bool) {
        layer.cornerRadius = 23
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(isLeftImage ? 5.5 : -5.5)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(22)
        }
        
        if isLeftImage {
            imageView.snp.makeConstraints {
                $0.right.equalTo(titleLabel.snp.left).offset(-1)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(10)
                $0.height.equalTo(20)
            }
        } else {
            imageView.snp.makeConstraints {
                $0.left.equalTo(titleLabel.snp.right).offset(1)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(10)
                $0.height.equalTo(20)
            }
        }
    }
}
