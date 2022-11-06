//
//  EmailSignUpVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/15.
//

import UIKit
import Combine

import CombineCocoa

final class EmailSignUpVC: UIViewController {
    
    // MARK: - Properties
    let viewModel = EmailSignUpViewModel()
    
    let navigationBar = CommonNavigationView().then {
        $0.titleLabel.text = "회원가입"
    }
    
    // 이메일
    let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = Fonts.Templates.subheader2.font
    }
    let emailTextField = CommonTextFieldView(placeholder: "이메일 주소를 입력해 주세요.", contentTrailing: 10).then {
        $0.contentTextField.keyboardType = .emailAddress
    }
    let emailVaildCheckButton = UIButton().then {
        $0.setTitle("인증", for: .normal)
        $0.setTitleColor(UIColor.white, for: .disabled)
        $0.setTitleColor(Colors.point.color, for: .normal)
        $0.layer.cornerRadius = 4
    }
    let emailValidLabel = UILabel().then {
        $0.text = "이메일 인증이 완료되었어요."
        $0.textColor = .blue
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.isHidden = true
    }
    
    // 닉네임
    let nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Fonts.Templates.subheader2.font
    }
    let nickNameTextFieldView = CommonTextFieldView(placeholder: "15자 이내의 닉네임을 입력해주세요.")
    let nicknameValidLabel = UILabel().then {
        $0.text = "닉네임이 중복 되었어요."
        $0.textColor = .red
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.isHidden = true
    }

    // 비밀번호
    let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = Fonts.Templates.subheader2.font
    }
    let passwordTextFieldView = CommonTextFieldView(placeholder: "8~16자의 영문, 숫자로 조합해주세요.").then {
        $0.contentTextField.isSecureTextEntry = true
    }
    let passwordValidLabel = UILabel().then {
        $0.text = "8~16자의 영문, 숫자로 조합해 주세요."
        $0.textColor = .red
        $0.isHidden = true
        $0.font = UIFont.systemFont(ofSize: 10)
    }
    
    // 비밀번호 확인
    let passwordConfirmLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.font = Fonts.Templates.subheader2.font
    }
    let passwordConfirmTextFieldView = CommonTextFieldView(placeholder: "입력하신 비밀번호를 한번 더 입력해 주세요.").then {
        $0.contentTextField.isSecureTextEntry = true
    }
    let passwordConfirmValidLabel = UILabel().then {
        $0.text = "비밀번호가 일치하지 않습니다."
        $0.textColor = .red
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.isHidden = true
    }
    
    // 회원가입 버튼
    let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor.white, for: .disabled)
        $0.setTitleColor(Colors.point.color, for: .normal)
        $0.layer.cornerRadius = 4
    }
    // MARK: - Lift Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - MakeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigationBar)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailVaildCheckButton)
        view.addSubview(emailValidLabel)
        
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameTextFieldView)
        view.addSubview(nicknameValidLabel)
        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextFieldView)
        view.addSubview(passwordValidLabel)
        
        view.addSubview(passwordConfirmLabel)
        view.addSubview(passwordConfirmTextFieldView)
        view.addSubview(passwordConfirmValidLabel)
        
        view.addSubview(signUpButton)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(16)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(271)
            $0.height.equalTo(46)
        }
        emailVaildCheckButton.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.equalTo(emailTextField.snp.trailing).offset(8)
            $0.width.equalTo(64)
            $0.height.equalTo(46)
        }
        emailValidLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(emailVaildCheckButton.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        nickNameTextFieldView.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
        nicknameValidLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextFieldView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextFieldView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        passwordTextFieldView.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
        passwordValidLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }
        passwordConfirmLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        passwordConfirmTextFieldView.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
        passwordConfirmValidLabel.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmTextFieldView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }
        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(58)
        }
    }
    
    private func bind() {
        // 이메일 입력
        emailTextField
            .contentTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.emailInput, on: viewModel)
            .store(in: &viewModel.bag)
        
        nickNameTextFieldView.contentTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.nicknameInput, on: viewModel)
            .store(in: &viewModel.bag)
        
        passwordTextFieldView.contentTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.passwordInput, on: viewModel)
            .store(in: &viewModel.bag)
        
        passwordConfirmTextFieldView.contentTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.passwordConfirmInput, on: viewModel)
            .store(in: &viewModel.bag)
        
        /// 회원가입 버튼 클릭
        signUpButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.signupButtonTapped()
            }.store(in: &viewModel.bag)
        
        viewModel.isEmailValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.emailVaildCheckButton.backgroundColor = isValid ? Colors.gray001.color : Colors.gray005.color
                self?.emailVaildCheckButton.setTitleColor(isValid ? Colors.point.color : .white)
            }.store(in: &viewModel.bag)
        
        viewModel.isNicknameValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.nicknameValidLabel.isHidden = isValid
            }.store(in: &viewModel.bag)
        
        viewModel.isPasswordValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.passwordValidLabel.isHidden = isValid
            }.store(in: &viewModel.bag)
        
        viewModel.isPasswordConfirmValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.passwordConfirmValidLabel.isHidden = isValid
            }.store(in: &viewModel.bag)

        /// [이메일, 닉네임, 비밀번호, 비밀번호 확인]이 전부 입력 돼야 버튼 활성화
        viewModel.isSignupButtonValid
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] valid in
                self?.signUpButton.isEnabled = valid ? true : false
                self?.signUpButton.backgroundColor = valid ? Colors.gray001.color : Colors.gray006.color
            }.store(in: &viewModel.bag)
        
    }
    
    // MARK: - Actions
    
    // MARK: - Functions
    
    
    
    
    
}

