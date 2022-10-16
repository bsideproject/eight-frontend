//
//  InputTextFieldView.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/16.
//

import UIKit

class EmailSignUpTextFieldView: UIView {
    
    var commonTextField: CommonTextFieldView?
    var viewModel: EmailSignUpViewModel?
    
    private let titleLabel = UILabel().then {
        $0.font = Fonts.Templates.subheader2.font
    }
    
    init(title: String?, placeHolder: String?, viewModel: EmailSignUpViewModel?) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.commonTextField = CommonTextFieldView(placeholder: placeHolder)
        self.viewModel = viewModel
        makeUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func makeUI() {
        
        guard let commonTextField else { return }
        
        addSubview(titleLabel)
        addSubview(commonTextField)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        commonTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(46)
        }
    }
}
