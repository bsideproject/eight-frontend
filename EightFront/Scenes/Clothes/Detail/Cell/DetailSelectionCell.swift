//
//  DetailSelectionCell.swift
//  EightFront
//
//  Created by wargi on 2022/11/13.
//

import Then
import SnapKit
import UIKit

protocol DetailSelectionDelegate: AnyObject {
    func lock()
    func keep()
}

//MARK: 디테일 페이지 셀렉션 셀
final class DetailSelectionCell: DetailPostCell {
    //MARK: - Properties
    weak var delegate: DetailSelectionDelegate?
    private let choiceLabel = UILabel().then {
        $0.text = "나였다면?"
        $0.textColor = UIColor(colorSet: 117)
        $0.textAlignment = .center
        $0.font = Fonts.Pretendard.regular.font(size: 14)
    }
    private let storageButton = ChoiceView(isLeftImage: true).then {
        $0.titleLabel.text = "보관해요"
        $0.titleLabel.textColor = Colors.gray005.color
        let image = Images.Trade.leftArrow.image.withRenderingMode(.alwaysTemplate)
        $0.imageView.image = image
        $0.imageView.tintColor = Colors.gray005.color
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = Colors.gray005.color.cgColor
    }
    private let throwButton = ChoiceView(isLeftImage: false).then {
        $0.titleLabel.text = "버릴래요"
        $0.titleLabel.textColor = Colors.gray005.color
        let image = Images.Trade.rightArrow.image.withRenderingMode(.alwaysTemplate)
        $0.imageView.image = image
        $0.imageView.tintColor = Colors.gray005.color
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = Colors.gray005.color.cgColor
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(lockButtonTapped))
        storageButton.addGestureRecognizer(tap)
        tap = UITapGestureRecognizer(target: self, action: #selector(throwButtonTapped))
        throwButton.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        selectionStyle = .none
        
        contentView.addSubview(choiceLabel)
        contentView.addSubview(storageButton)
        contentView.addSubview(throwButton)
        
        storageButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(98)
            $0.height.equalTo(40)
        }
        choiceLabel.snp.makeConstraints {
            $0.centerY.equalTo(storageButton)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(56)
            $0.height.equalTo(22)
        }
        throwButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(98)
            $0.height.equalTo(40)
        }
    }
    
    @objc
    private func lockButtonTapped() {
        delegate?.lock()
    }
    
    @objc
    private func throwButtonTapped() {
        delegate?.keep()
    }
}
//MARK: - 사이즈 관련
extension DetailSelectionCell {
    static var height: CGFloat = 44.0
}

