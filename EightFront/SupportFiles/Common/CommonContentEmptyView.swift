//
//  CommonContentEmptyView.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/12/01.
//

import UIKit

class CommonContentEmptyView: UIView {
    
    private let threeDotView = UIImageView().then {
        let image = Images.threeDot.image
        $0.image = image
    }
    
    private let holeImageView = UIImageView().then {
        let image = Images.hole.image
        $0.image = image
    }
    
    var titleLabel = UILabel().then {
        $0.font = Fonts.Templates.subheader2.font
        $0.textColor = Colors.gray005.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        addSubview(threeDotView)
        threeDotView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(66)
            $0.height.equalTo(6)
        }
        
        addSubview(holeImageView)
        holeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(threeDotView.snp.bottom).offset(27)
            $0.width.equalTo(174)
            $0.height.equalTo(67)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(holeImageView.snp.bottom).offset(17)
//            $0.width.equalTo(150)
//            $0.height.equalTo(26)
        }
    }
    
}
