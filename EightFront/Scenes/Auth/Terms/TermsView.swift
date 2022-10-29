//
//  TermsView.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/20.
//

import UIKit

final class TermsView: UIView {
    
    //MARK: - Properties
    
    let titleLabel = UILabel().then {
        $0.font = Fonts.Templates.subheader.font
        $0.textColor = Colors.gray005.color
    }
    
    let chkeckButton = UIButton().then {
        $0.setImage(Images.Report.checkboxSelect.image, for: .normal)
        $0.clipsToBounds = true
    }
    
    // MARK: - LifeCycle
    
    init(borderColor: UIColor? = .clear, title: String? = "") {
        super.init(frame: .zero)
        configure(borderColor: borderColor, title: title)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(borderColor: UIColor? = .clear, title: String? = "") {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
        
        self.titleLabel.text = title
        self.layer.borderColor = borderColor?.cgColor
    }
    
    private func makeUI() {
        addSubview(titleLabel)
        addSubview(chkeckButton)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        chkeckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
