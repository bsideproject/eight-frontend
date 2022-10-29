//
//  ReportPopupView.swift
//  EightFront
//
//  Created by wargi on 2022/11/06.
//

import Then
import SnapKit
import UIKit

protocol ReportPopupViewDelegate: AnyObject {
    func cancelTapped()
    func reportTapped()
    func cutoffTapped()
}

//MARK: 옵션 선택 팝업
final class ReportPopupView: UIView {
    //MARK: - Properties
    weak var delegate: ReportPopupViewDelegate?
    let titleLabel = UILabel().then {
        $0.text = "옵션 선택"
        $0.font = Fonts.Templates.subheader3.font
    }
    let cancelButton = UIButton().then {
        $0.setTitle("취소")
        $0.titleLabel?.font = Fonts.Templates.subheader.font
    }
    let reportButton = UIButton().then {
        $0.setTitle("신고하기")
        $0.titleLabel?.font = Fonts.Templates.subheader.font
    }
    let cutoffButton = UIButton().then {
        $0.setTitle("차단하기")
        $0.titleLabel?.font = Fonts.Templates.subheader.font
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
        addSubview(cancelButton)
        addSubview(reportButton)
        addSubview(cutoffButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().inset(16)
            $0.height.equalTo(26)
        }
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(26)
        }
        reportButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        cutoffButton.snp.makeConstraints {
            $0.top.equalTo(reportButton.snp.bottom)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    //MARK: - Make UI
    private func configure() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        cutoffButton.addTarget(self, action: #selector(cutoffButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func cancelButtonTapped() {
        delegate?.cancelTapped()
    }
    
    @objc
    private func reportButtonTapped() {
        delegate?.reportTapped()
    }
    
    @objc
    private func cutoffButtonTapped() {
        delegate?.cutoffTapped()
    }
}
