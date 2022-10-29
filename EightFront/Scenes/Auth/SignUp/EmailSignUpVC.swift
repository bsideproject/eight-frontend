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
    let emailTextFieldView = CommonTextFieldView(isTitleHidden: true, placeholder: "이메일 주소를 입력해 주세요.").then {
        $0.contentTextField.keyboardType = .emailAddress
        $0.contentTextField.returnKeyType = .next
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
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Fonts.Templates.subheader2.font
    }
    let nicknameTextFieldView = CommonTextFieldView(isTitleHidden: true, placeholder: "15자 이내의 닉네임을 입력해주세요.").then {
        $0.contentTextField.returnKeyType = .next
    }
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
    let passwordTextFieldView = CommonTextFieldView(isTitleHidden: true, placeholder: "8~16자의 영문, 숫자로 조합해주세요.").then {
        $0.contentTextField.isSecureTextEntry = true
        $0.contentTextField.returnKeyType = .next
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
    let passwordConfirmTextFieldView = CommonTextFieldView(isTitleHidden: true, placeholder: "입력하신 비밀번호를 한번 더 입력해 주세요.").then {
        $0.contentTextField.isSecureTextEntry = true
        $0.contentTextField.returnKeyType = .done
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
        configureTextFieldDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 회원가입 창 진입 시 이메일 텍스트 필드 포커스 온
        emailTextFieldView.contentTextField.becomeFirstResponder()
    }
    
    // MARK: - MakeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigationBar)
        view.addSubview(emailLabel)
        view.addSubview(emailTextFieldView)
        view.addSubview(emailVaildCheckButton)
        view.addSubview(emailValidLabel)
        
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextFieldView)
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
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(271)
            $0.height.equalTo(46)
        }
        emailVaildCheckButton.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.equalTo(emailTextFieldView.snp.trailing).offset(8)
            $0.width.equalTo(64)
            $0.height.equalTo(46)
        }
        emailValidLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(emailVaildCheckButton.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        nicknameTextFieldView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
        nicknameValidLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldView.snp.bottom).offset(28)
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
    
    // MARK: - bind
    private func bind() {
        // 이메일 입력
        emailTextFieldView
            .contentTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.emailInput, on: viewModel)
            .store(in: &viewModel.bag)
        
        nicknameTextFieldView.contentTextField
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
    
    // MARK: - Configure
    private func configureTextFieldDelegate() {
        emailTextFieldView.contentTextField.delegate = self
        nicknameTextFieldView.contentTextField.delegate = self
        passwordTextFieldView.contentTextField.delegate = self
        passwordConfirmTextFieldView.contentTextField.delegate = self
    }
    
    // MARK: - Actions
    
    // MARK: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate
extension EmailSignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextFieldView.contentTextField:
            nicknameTextFieldView.contentTextField.becomeFirstResponder()
        case nicknameTextFieldView.contentTextField:
            passwordTextFieldView.contentTextField.becomeFirstResponder()
        case passwordTextFieldView.contentTextField:
            passwordConfirmTextFieldView.contentTextField.becomeFirstResponder()
        case passwordConfirmTextFieldView.contentTextField:
            print("회원가입 창에서 done 버튼 누름")
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

