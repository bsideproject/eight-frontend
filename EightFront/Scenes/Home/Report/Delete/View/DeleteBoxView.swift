//
//  DeleteBoxView.swift
//  EightFront
//
//  Created by wargi on 2022/11/17.
//

import Then
import SnapKit
import UIKit

protocol DeleteBoxViewDelegate: AnyObject {
    func deleteTapped()
    func cancelTapped()
}

//MARK: DeleteBoxView
final class DeleteBoxView: UIView {
    //MARK: - Properties
    weak var delegate: DeleteBoxViewDelegate?
    let titleLabel = UILabel().then {
        $0.text = "수거함을 삭제할까요?"
        $0.textColor = Colors.gray001.color
        $0.font = Fonts.Templates.title.font
    }
    let subTitleLabel = UILabel().then {
        $0.text = "N건 이상 접수된 건은 삭제 완료 처리됩니다."
        $0.textColor = Colors.gray005.color
        $0.font = Fonts.Templates.body1.font
    }
    let cancelButton = UIButton().then {
        $0.setTitle("취소")
        $0.setTitleColor(UIColor(colorSet: 117))
        $0.layer.cornerRadius = 8.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor(colorSet: 221).cgColor
    }
    let deleteButton = UIButton().then {
        $0.setTitle("삭제")
        $0.setTitleColor(Colors.point.color)
        $0.layer.cornerRadius = 8.0
        $0.backgroundColor = Colors.gray002.color
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = 12.0
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(cancelButton)
        addSubview(deleteButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(32)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(22)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(138)
            $0.height.equalTo(50)
        }
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(138)
            $0.height.equalTo(50)
        }
    }
    
    private func configure() {
        deleteButton.addTarget(self, action: #selector(deleteTouched), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTouched), for: .touchUpInside)
    }
    
    @objc
    private func deleteTouched() {
        delegate?.deleteTapped()
    }
    
    @objc
    private func cancelTouched() {
        delegate?.cancelTapped()
    }
}
