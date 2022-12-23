//
//  CommentInputView.swift
//  EightFront
//
//  Created by wargi on 2022/11/19.
//

import Then
import SnapKit
import UIKit
//MARK: CommentInputView
final class CommentInputView: UIView {
    //MARK: - Properties
    let topLineView = UIView().then {
        $0.backgroundColor = UIColor(colorSet: 234)
    }
    let profileBackgroundView = UIView().then {
        $0.backgroundColor = Colors.gray007.color
        $0.layer.cornerRadius = 17
    }
    let profileImageView = UIImageView().then {
        $0.image = Images.dropIcon.image
        $0.contentMode = .scaleToFill
        $0.backgroundColor = Colors.gray007.color
    }
    let inputBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(colorSet: 245)
    }
    let inputTextField = UITextField().then {
        $0.placeholder = "댓글을 남기세요..."
        $0.textColor = Colors.gray001.color
        $0.font = Fonts.Templates.body1.font
        $0.smartDashesType = .no
        $0.smartQuotesType = .no
        $0.spellCheckingType = .no
        $0.autocorrectionType = .no
        $0.smartInsertDeleteType = .no
        $0.returnKeyType = .search
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    let sumitButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitle("게시")
        $0.setTitleColor(UIColor(red: 0.712, green: 0.702, blue: 0.701, alpha: 1))
        $0.titleLabel?.font = Fonts.Pretendard.semiBold.font(size: 12)
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
        addSubview(topLineView)
        addSubview(profileBackgroundView)
        addSubview(inputBackgroundView)
        
        inputBackgroundView.addSubview(inputTextField)
        inputBackgroundView.addSubview(sumitButton)
        profileBackgroundView.addSubview(profileImageView)
        
        topLineView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        profileBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16.33)
            $0.size.equalTo(34)
        }
        profileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(19.428571)
        }
        inputBackgroundView.snp.makeConstraints {
            $0.height.equalTo(42)
            $0.left.equalTo(profileBackgroundView.snp.right).offset(8.32)
            $0.right.equalToSuperview().offset(-19)
            $0.centerY.equalToSuperview()
        }
        sumitButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(44)
        }
        inputTextField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(13)
            $0.right.equalTo(sumitButton.snp.left)
            $0.top.bottom.equalToSuperview()
        }
    }
}
