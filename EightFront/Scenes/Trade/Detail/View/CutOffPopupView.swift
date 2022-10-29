//
//  CutOffPopupView.swift
//  EightFront
//
//  Created by wargi on 2022/11/06.
//

import Then
import SnapKit
import UIKit

protocol CutOffPopupViewDelegate: AnyObject {
    func cancelTapped()
    func cutoffTapped()
}

//MARK: 차단 팝업
final class CutOffPopupView: UIView {
    //MARK: - Properties
    weak var delegate: CutOffPopupViewDelegate?
    let titleLabel = UILabel().then {
        $0.text = "게시글을 차단하시겠습니까?"
        $0.font = Fonts.Templates.title.font
    }
    let descLabel = UILabel().then {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.32
        let attrString = NSMutableAttributedString(string: "사용자의 모든 게시글, 댓글이 보이지 않습니다.\n차단 해제를 원하는 경우 마이페이지\n차단 목록 페이지에서 확인하실 수 있습니다.", attributes: [.paragraphStyle: paragraphStyle])
        $0.attributedText = attrString
    }
    let cancelButton = UIButton().then {
        $0.setTitle("취소")
        $0.setTitleColor(Colors.gray004.color)
        $0.backgroundColor = Colors.gray006.color
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 8.0
        $0.layer.borderColor = Colors.gray004.color.cgColor
    }
    let cutoffButton = UIButton().then {
        $0.setTitle("차단")
        $0.setTitleColor(Colors.point.color)
        $0.backgroundColor = Colors.gray002.color
        $0.layer.cornerRadius = 8.0
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
        layer.cornerRadius = 12.0
        
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(cancelButton)
        addSubview(cutoffButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        descLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(66)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(138)
            $0.height.equalTo(50)
        }
        cutoffButton.snp.makeConstraints {
            $0.top.equalTo(cancelButton)
            $0.right.equalToSuperview().offset(-16)
            $0.size.equalTo(cancelButton)
        }
    }
    
    //MARK: - Make UI
    private func configure() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cutoffButton.addTarget(self, action: #selector(cutoffButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func cancelButtonTapped() {
        delegate?.cancelTapped()
    }
    
    @objc
    private func cutoffButtonTapped() {
        delegate?.cutoffTapped()
    }
}
