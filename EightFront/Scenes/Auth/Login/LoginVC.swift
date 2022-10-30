//
//  LoginVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/11.
//

import UIKit
import Combine

import CombineCocoa

final class LoginVC: UIViewController {
    
    // MARK: Properties
    
    let viewModel = LoginViewModel()
        
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "로그인"
    }
    private let logoImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
    }
    private let emailTextFieldView = CommonTextFieldView(isTitleHidden: true, placeholder: "이메일을 입력하세요.").then {
        $0.contentTextField.returnKeyType = .next
        $0.contentTextField.autocapitalizationType = .none
    }
    private let passwordTextFieldView = CommonTextFieldView(isTitleHidden: true, placeholder: "비밀번호를 입력하세요.").then {
        $0.contentTextField.returnKeyType = .done
        $0.contentTextField.isSecureTextEntry = true
    }
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(UIColor.white, for: .disabled)
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 4
        $0.isEnabled = false
    }
    private let findButton = UIButton().then {
        $0.setTitle("아이디﹒비밀번호 찾기", for: .normal)
        $0.titleLabel?.font = Fonts.Pretendard.regular.font(size: 12)
        $0.setTitleColor(Colors.gray005.color)
    }
    private let signUpButton = UIButton().then {
        $0.setTitle("계정이 없다면? 회원가입", for: .normal)
        $0.titleLabel?.font = Fonts.Pretendard.regular.font(size: 12)
        $0.setTitleColor(Colors.gray002.color)
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        emailTextFieldView.contentTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
        configureTextFieldDelegate()
    }
    
    // MARK: - configure
    
    private func configureTextFieldDelegate() {
        emailTextFieldView.contentTextField.delegate = self
        passwordTextFieldView.contentTextField.delegate = self
    }
    
    // MARK: - makeUI
    
    private func makeUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(logoImageView)
        view.addSubview(emailTextFieldView)
        view.addSubview(passwordTextFieldView)
        view.addSubview(loginButton)
        view.addSubview(findButton)
        view.addSubview(signUpButton)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.horizontalEdges.equalToSuperview().inset(119)
            $0.height.equalTo(71)
        }
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(219)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.height.equalTo(54)
        }
        passwordTextFieldView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(285)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.height.equalTo(54)
        }
        loginButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(367)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.height.equalTo(58)
        }
        findButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(436)
            $0.leading.equalToSuperview().inset(16)
        }
        signUpButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(436)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: binding
    
    private func bind() {
        
        navigationView.backButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
        
        emailTextFieldView.contentTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.emailInput, on: viewModel)
            .store(in: &viewModel.bag)
        
        passwordTextFieldView.contentTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.passwordInput, on: viewModel)
            .store(in: &viewModel.bag)
        
        Publishers.CombineLatest(viewModel.isEmailValid, viewModel.isPasswordValid)
            .receive(on: DispatchQueue.main)
            .compactMap { $0 && $1 }
            .sink { [weak self] isValid in
                self?.loginButton.backgroundColor = isValid ? Colors.gray002.color : Colors.gray006.color
                self?.loginButton.isEnabled = isValid
                self?.loginButton.setTitleColor(Colors.point.color, for: .normal)
            }.store(in: &viewModel.bag)
        
        signUpButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.signUpButtonTapped()
            }
            .store(in: &viewModel.bag)
    }
    
    // - MARK: Actions
    
    func signUpButtonTapped() {
        let termsVC = TermsVC()
        navigationController?.pushViewController(termsVC, animated: true)
//        let emailSignVC = EmailSignUpVC()
//        navigationController?.pushViewController(emailSignVC, animated: true)
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextFieldView.contentTextField:
            passwordTextFieldView.contentTextField.becomeFirstResponder()
        case passwordTextFieldView.contentTextField:
            print("비밀번호 입력 창에서 done 키 누름")
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
