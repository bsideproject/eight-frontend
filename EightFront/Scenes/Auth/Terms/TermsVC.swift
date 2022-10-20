//
//  TermsVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/13.
//

import Combine
import UIKit

import CombineCocoa
import SnapKit


class TermsView: UIView {
    
    var viewModel: TermsViewModel?
    
    let titleLabel = UILabel().then {
        $0.text = ""
        $0.font = Fonts.Templates.subheader.font
    }
    
    let chkeckButton = UIButton().then {
        $0.setImage(Images.Report.checkboxSelect.image, for: .normal)
        $0.setImage(Images.Report.checkboxNone.image, for: .disabled)
    }
    
    init(borderColor: UIColor? = .clear, title: String? = "") {
        super.init(frame: .zero)
        makeUI(borderColor: borderColor, title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI(borderColor: UIColor? = .clear, title: String? = "") {
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
        self.titleLabel.text = title
        
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

final class TermsVC: UIViewController {
    
    // MARK: - properties
    
    let viewModel = TermsViewModel()
    
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "회원가입"
    }
    private let titleLabel = UILabel().then {
        $0.text = "약관동의"
        $0.font = Fonts.Templates.title.font
        $0.textColor = Colors.gray001.color
    }
    private let subTitleLabel = UILabel().then {
        $0.text = "필수항목 및 선택항목 약관에 동의해 주세요."
        $0.font = Fonts.Templates.body2.font
        $0.textColor = Colors.gray001.color
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor.white, for: .disabled)
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 4
    }
    
    private let allAgree = TermsView(borderColor: Colors.gray006.color, title: "전체 동의")
    private let policy = TermsView(title: "이용약관 동의(필수)")
    private let privacy = TermsView(title: "개인정보 수집 이용 동의(필수)")
    private let location = TermsView(title: "위치기반 서비스 이용약관 동의(필수)")
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
    }
    
    // MARK: - MakeUI
    
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(allAgree)
        view.addSubview(policy)
        view.addSubview(privacy)
        view.addSubview(location)
        view.addSubview(nextButton)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.equalToSuperview().inset(16)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(156)
            $0.leading.equalToSuperview().inset(16)
        }
        allAgree.snp.makeConstraints {
            $0.top.equalToSuperview().inset(233)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        policy.snp.makeConstraints {
            $0.top.equalTo(allAgree.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        privacy.snp.makeConstraints {
            $0.top.equalTo(policy.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        location.snp.makeConstraints {
            $0.top.equalTo(privacy.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(44)
            $0.height.equalTo(58)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func bind() {
                
        viewModel.isAllAgessValid.receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.allAgree.chkeckButton.isEnabled = isValid
                self?.policy.chkeckButton.isEnabled = isValid
                self?.privacy.chkeckButton.isEnabled = isValid
                self?.location.chkeckButton.isEnabled = isValid
            }.store(in: &viewModel.bag)
        
        viewModel.isAllAgessValid.receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.nextButton.isEnabled = isValid
                self?.nextButton.setTitleColor(Colors.point.color, for: .normal)
                self?.nextButton.backgroundColor = Colors.gray001.color
            }.store(in: &viewModel.bag)
    }
}

