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
    private var disposeBag = Set<AnyCancellable>()
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
    
    private var nicknameDuplicateedLabel = UILabel().then {
        $0.text = "* 닉네임이 중복되었어요."
        $0.textColor = .red
        $0.isHidden = true
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
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        
        view.addSubview(nicknameDuplicateedLabel)
        nicknameDuplicateedLabel.snp.makeConstraints {
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
        let accessToken = KeyChainManager.shared.accessToken
        guard let nickname = nicknameTextField.contentTextField.text else { return }
        signUpButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.authProvider.request(
                    .socialSignUp(
                        param: SocialSignUpRequest(
                        accessToken: accessToken,
                        nickName: nickname
                    ))) { [weak self] response in
                        switch response {
                        case .success(let result):
                            guard let data = try? result.map(SimpleSignUpResponse.self).data else {
                                LogUtil.d("Response Decoding 실패")
                                return
                            }
                            guard let content = data.content else {
                                LogUtil.e("data.content unWrapping 실패")
                                return
                            }
                            guard let accessToken = content.accessToken else { return }
                            if KeyChainManager.shared.createAccessToken(accessToken) {
                                let signUpSuccessVC = SignUpSuccessVC()
                                self?.navigationController?.pushViewController(signUpSuccessVC, animated: true)
                            } else {
                                LogUtil.e("액세스 토큰을 키체인에 저장하지 못했습니다.")
                            }
                        case .failure(let error):
                            LogUtil.e("간편 회원가입 실패 > \(error.localizedDescription)")
                        }
                    }
            }.store(in: &disposeBag)
        
        nicknameTextField.contentTextField.textPublisher
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] in
                self?.viewModel.inputNickname = $0
                if $0.count < 2 || $0.count > 15 {
                    self?.viewModel.isSignUpButtonValid = false
                }
            })
            .store(in: &viewModel.bag)
        
        nicknameCheckButtonView.gesture()
            .sink { [weak self] _ in
                guard let nickname = self?.nicknameTextField.contentTextField.text else { return }
                self?.authProvider.request(.nicknameCheck(nickname: nickname)) { result in
                    switch result {
                    case .success(let response):
                        guard let data = try? response.map(NicknameResponse.self).data else {
                            LogUtil.d("Response Decoding 실패")
                            return
                        }
                        
                        guard let content = data.content else { return }
                        if content {
                            self?.viewModel.isSignUpButtonValid = false
                            self?.nicknameDuplicateedLabel.isHidden = false
                        } else {
                            self?.viewModel.isSignUpButtonValid = true
                            self?.nicknameDuplicateedLabel.isHidden = true
                        }
                        self?.view.endEditing(true)
                    case .failure(let error):
                        LogUtil.e(error)
                    }
                }
            }.store(in: &viewModel.bag)
        
        viewModel.isNicknameValid.receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.nicknameCheckButtonView.backgroundColor = $0 ? Colors.gray001.color : Colors.gray006.color
                self?.nicknameCheckButtonLabel.textColor = $0 ? Colors.point.color :
                UIColor.white
            }.store(in: &viewModel.bag)
        
        viewModel.$isSignUpButtonValid.receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isButtonEnabled in
                self?.signUpButton.backgroundColor = isButtonEnabled ? Colors.gray001.color : Colors.gray006.color
                self?.signUpButton.setTitleColor(isButtonEnabled ? Colors.point.color : UIColor.white)
            }.store(in: &viewModel.bag)
    
    }
}
