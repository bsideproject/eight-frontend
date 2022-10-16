//
//  CommonNavigationView.swift
//  EightFront
//
//  Created by wargi on 2022/10/07.
//

import Then
import SnapKit
import UIKit
//MARK: CommonNavigationView
final class CommonNavigationView: UIView {
    //MARK: - Properties
    let backButton = UIButton().then {
        $0.setImage(Images.Navigation.back.image, for: .normal)
        $0.setImage(Images.Navigation.back.image, for: .highlighted)
    }
    let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = Colors.gray001.color
        $0.font = Fonts.Pretendard.medium.font(size: 16)
    }
    let bottomLine = UIView().then {
        $0.backgroundColor = Colors.gray007.color
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
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(bottomLine)
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(5)
            $0.size.equalTo(44)
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        bottomLine.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
