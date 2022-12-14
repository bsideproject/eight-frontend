//
//  SimpleSignUpVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import UIKit
import Combine

import Moya


class SimpleSignUpVC: UIViewController {
    
    // MARK: - Properties
    private let authProvider = MoyaProvider<AuthAPI>()
    private let viewModel = SimpleSignUpVieModel()
    
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "회원가입"
    }
    
    // 닉네임
    private let nicknameTitleLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Fonts.Templates.subheader3.font
    }
    
    private var nicknameTextField = CommonTextFieldView(isTitleHidden: true, placeholder: "15자 이내의 닉네임을 입력해주세요.")
    
    private var nicknameDuplicatedLabel = UILabel().then {
        $0.font = Fonts.Templates.caption2.font
    }
    
    private var nicknameCheckButtonView = UIView().then {
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 4
    }
    
    private var nicknameCheckButtonLabel = UILabel().then {
        $0.text = "확인"
        $0.textColor = UIColor.white
    }
    
    // 회원가입 버튼
    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.layer.cornerRadius = 4
    }
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden.toggle()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Configure {
    func configure(type: SignType) {
        viewModel.signType = type
    }
    
    // MARK: - makeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        view.addSubview(nicknameTitleLabel)
        nicknameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(16)
            $0.width.equalTo(271)
            $0.height.equalTo(46)
        }
        
        view.addSubview(nicknameDuplicatedLabel)
        nicknameDuplicatedLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(nicknameCheckButtonView)
        nicknameCheckButtonView.snp.makeConstraints {
            $0.centerY.equalTo(nicknameTextField.snp.centerY)
            $0.width.equalTo(64)
            $0.height.equalTo(46)
            $0.right.equalToSuperview().inset(16)
            
            nicknameCheckButtonView.addSubview(nicknameCheckButtonLabel)
            nicknameCheckButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.horizontalEdges.equalToSuperview().inset(19)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    // MARK: - Binding
    private func bind() {
        signUpButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                if self?.viewModel.isSignUpButtonValid == true {
                    self?.viewModel.requestSignUp()
                }
            }.store(in: &viewModel.bag)
        
        // 닉네임 입력
        nicknameTextField.contentTextField.textPublisher
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] in
                self?.viewModel.inputNickname = $0
            })
            .store(in: &viewModel.bag)
        
        viewModel.$isNicknameCheck
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isNicknameCheck in
                if isNicknameCheck {
                    self?.viewModel.isSignUpButtonValid = true
                    self?.nicknameDuplicatedLabel.textColor = .blue
                } else {
                    self?.viewModel.isSignUpButtonValid = false
                    self?.nicknameDuplicatedLabel.textColor = .red
                }
            }.store(in: &viewModel.bag)
        
        nicknameCheckButtonView.gesture()
            .sink { [weak self] _ in
                self?.viewModel.requestNickNameCheck()
            }.store(in: &viewModel.bag)
        
        // 화면 이동
        viewModel.$isSignUp
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] in
                if $0 {
                    let successVC = SignUpSuccessVC()
                    self?.navigationController?.pushViewController(successVC, animated: true)
                }
            }.store(in: &viewModel.bag)
        
        viewModel.isNicknameValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.nicknameCheckButtonView.backgroundColor = $0 ? Colors.gray001.color : Colors.gray006.color
                self?.nicknameCheckButtonLabel.textColor = $0 ? Colors.point.color : UIColor.white
//                self?.nicknameDuplicatedLabel.textColor = $0 ? UIColor.blue : UIColor.red
            }.store(in: &viewModel.bag)
        
        viewModel.$isSignUpButtonValid
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isButtonEnabled in
                self?.signUpButton.backgroundColor = isButtonEnabled ? Colors.gray001.color : Colors.gray006.color
                self?.signUpButton.setTitleColor(isButtonEnabled ? Colors.point.color : UIColor.white)
            }.store(in: &viewModel.bag)
    
        viewModel.$nicknameDuplicateText
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] label in
                self?.nicknameDuplicatedLabel.text = label
            }.store(in: &viewModel.bag)
        
    }
}
