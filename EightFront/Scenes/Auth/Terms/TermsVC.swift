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
    
    var signType: SignType?
    
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
    
    private let allAgree = TermsView(borderColor: Colors.gray006.color, title: "전체 동의")
    private let policy = TermsView(title: "이용약관 동의(필수)")
    private let privacy = TermsView(title: "개인정보 수집 이용 동의(필수)")
    private let location = TermsView(title: "위치기반 서비스 이용약관 동의(필수)")
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음")
        $0.layer.cornerRadius = 4
    }
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden.toggle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
    }
    
    // MARK: - Configure
    
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
        navigationView.backButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
        
        allAgree.checkButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.checkButtonTapped(TermsViewModel.Terms.all)
            }
            .store(in: &viewModel.bag)
        
        policy.checkButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.checkButtonTapped(TermsViewModel.Terms.policy)
            }
            .store(in: &viewModel.bag)
        
        privacy.checkButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.checkButtonTapped(TermsViewModel.Terms.privacy)
            }
            .store(in: &viewModel.bag)
        
        location.checkButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.checkButtonTapped(TermsViewModel.Terms.location)
            }
            .store(in: &viewModel.bag)
        
        nextButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                switch self?.signType {
                case .kakao,
                     .apple:
                    let simpleSignupVC = SimpleSignUpVC()
                    guard
                        let signType = self?.signType
                    else {
                        assertionFailure("회원가입 진행 실패")
                        return
                    }
                    simpleSignupVC.configure(type: signType)
                    self?.navigationController?.pushViewController(simpleSignupVC, animated: true)
                case .email:
                    let emailSignVC = EmailSignUpVC()
                    self?.navigationController?.pushViewController(emailSignVC, animated: true)
                default:
                    LogUtil.e("오류")
                }
                
            }
            .store(in: &viewModel.bag)
        
        Publishers
            .CombineLatest3(
                viewModel.$isPolicy,
                viewModel.$isPrivacy,
                viewModel.$isLocation
            )
            .compactMap {
                $0 && $1 && $2
            }.sink { [weak self] isValid in
                self?.allAgree.titleLabel.textColor = isValid ? Colors.point.color : Colors.gray005.color
                self?.allAgree.backgroundColor = isValid ? Colors.gray001.color : .white
                self?.allAgree.checkButton.setImage(isValid ? Images.Report.checkboxSelect.image : Images.Report.checkboxNone.image)
                self?.allAgree.checkButton.layer.cornerRadius = 3
                
                self?.nextButton.backgroundColor = isValid ? Colors.gray001.color : Colors.gray005.color
                self?.nextButton.setTitleColor(isValid ? Colors.point.color : .white)
                self?.nextButton.isEnabled = isValid
            }.store(in: &viewModel.bag)

        viewModel.$isPolicy
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isValid in
                self?.policy.titleLabel.textColor = isValid ? Colors.gray001.color : Colors.gray005.color
                self?.policy.checkButton.setImage(isValid ? Images.Report.checkboxSelect.image : Images.Report.checkboxNone.image )
            }.store(in: &viewModel.bag)
        viewModel.$isPrivacy
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isValid in
                self?.privacy.titleLabel.textColor = isValid ? Colors.gray001.color : Colors.gray005.color
                self?.privacy.checkButton.setImage(isValid ? Images.Report.checkboxSelect.image : Images.Report.checkboxNone.image )
            }.store(in: &viewModel.bag)
        viewModel.$isLocation
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isValid in
                self?.location.titleLabel.textColor = isValid ? Colors.gray001.color : Colors.gray005.color
                self?.location.checkButton.setImage(isValid ? Images.Report.checkboxSelect.image : Images.Report.checkboxNone.image )
            }.store(in: &viewModel.bag)
    }
    
    // MARK: - Functions
    
    private func checkButtonTapped(_ type: TermsViewModel.Terms) {
        switch type {
        case .policy:
            viewModel.isPolicy.toggle()
        case .privacy:
            viewModel.isPrivacy.toggle()
        case .location:
            viewModel.isLocation.toggle()
        default:
            if viewModel.isPolicy || viewModel.isPrivacy || viewModel.isLocation {
                viewModel.isPolicy = false
                viewModel.isPrivacy = false
                viewModel.isLocation = false
            } else {
                viewModel.isPolicy = true
                viewModel.isPrivacy = true
                viewModel.isLocation = true
            }
        }
    }
}

