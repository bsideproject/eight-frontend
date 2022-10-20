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

final class TermsVC: UIViewController {
    
    // MARK: - properties
    
    let viewModel = TermsViewModel()
    let subject = PassthroughSubject<Bool, Never>()
    
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
        
        $0.layer.cornerRadius = 4
    }
    
    private let allAgree = TermsView(borderColor: Colors.gray006.color, title: "전체 동의").then {
        $0.chkeckButton.isEnabled = false
    }
    private let policy = TermsView(title: "이용약관 동의(필수)").then {
        $0.chkeckButton.isEnabled = false
    }
    private let privacy = TermsView(title: "개인정보 수집 이용 동의(필수)").then {
        $0.chkeckButton.isEnabled = false
    }
    private let location = TermsView(title: "위치기반 서비스 이용약관 동의(필수)").then {
        $0.chkeckButton.isEnabled = false
    }
    
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
    
    // MARK: Bind
    
    private func bind() {
        
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let emailSignUpVC = EmailSignUpVC()
                self?.navigationController?.pushViewController(emailSignUpVC, animated: true)
            }
            .store(in: &viewModel.bag)
                
        viewModel.isAllAgessValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.nextButton.isEnabled = isValid
                self?.nextButton.setTitleColor(Colors.point.color, for: .normal)
                self?.nextButton.backgroundColor = isValid ? Colors.gray001.color : Colors.gray006.color
            }.store(in: &viewModel.bag)
        
        viewModel.$isAllAgree
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isValid in
                self?.allAgree.chkeckButton.isEnabled = isValid
                self?.allAgree.backgroundColor = isValid ? Colors.gray001.color : .white
            }.store(in: &viewModel.bag)
        
        viewModel.$isPolicy
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isValid in
                self?.policy.chkeckButton.isEnabled = isValid
                self?.policy.titleLabel.textColor = isValid ? Colors.gray001.color : Colors.gray005.color
            }.store(in: &viewModel.bag)
        
        viewModel.$isPrivacy
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isValid in
                self?.privacy.chkeckButton.isEnabled = isValid
                self?.privacy.titleLabel.textColor = isValid ? Colors.gray001.color : Colors.gray005.color
            }.store(in: &viewModel.bag)
        
        viewModel.$isLocation
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isValid in
                self?.privacy.chkeckButton.isEnabled = isValid
                self?.location.titleLabel.textColor = isValid ? Colors.gray001.color : Colors.gray005.color
            }.store(in: &viewModel.bag)
    }
}

