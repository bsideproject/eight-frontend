//
//  CommonTextFieldView.swift
//  EightFront
//
//  Created by wargi on 2022/10/09.
//

import Then
import SnapKit
import UIKit
//MARK: CommonTextFieldView
final class CommonTextFieldView: UIView {
    //MARK: - Properties
    let titleLabel = UILabel().then {
        $0.textColor = Colors.gray005.color
        $0.font = Fonts.Pretendard.regular.font(size: 16)
    }
    let contentTextField = UITextField().then {
        $0.textColor = Colors.gray001.color
        $0.font = Fonts.Pretendard.regular.font(size: 16)
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
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        layer.borderColor = Colors.gray006.color.cgColor
        
        addSubview(titleLabel)
        addSubview(contentTextField)
        
        
    }
    
    private func bind() {
        contentTextField.didend
    }
}
