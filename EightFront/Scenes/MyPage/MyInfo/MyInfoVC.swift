//
//  MyInfoVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import UIKit

import Moya
import KakaoSDKUser
import JWTDecode


class MyInfoVC: UIViewController {
    
    // MARK: - Properties
    
    private let authProvider = MoyaProvider<AuthAPI>()
    private let viewModel = MyInfoViewModel()
    
    private let commontNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "내 정보 수정"
    }
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 44
    }
    
    private let emailTitleLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = Fonts.Templates.subheader3.font
    }
    
    private let emailLabel = UILabel().then {
        $0.font = Fonts.Templates.body1.font
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
    }
    
    private var nicknameCheckButtonLabel = UILabel().then {
        $0.text = "확인"
        $0.textColor = UIColor.white
    }
    
    // TODO: 비밀번호 변경
    
    private let passwordTitleLabel = UILabel().then {
        $0.text = "비밀번호 변경"
        $0.font = Fonts.Templates.subheader3.font
        $0.isHidden = true
    }
    
    private let passwordChangeButton = UIButton().then {
        $0.setTitle("변경")
        $0.layer.cornerRadius = 4
        $0.isHidden = true
    }
    
    // 현재 비밀번호
    // 새 비밀번호
    // 새 비밀번호 확인
    
    private let editButton = UIButton().then {
        $0.setTitle("수정")
        $0.layer.cornerRadius = 4
    }
    
    private let resignButton = UILabel().then {
        $0.text = "회원탈퇴"
        $0.font = Fonts.Templates.subheader.font
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
    
    // MARK: - makeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commontNavigationView)
        commontNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(47)
        }
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(107)
            $0.size.equalTo(88)
        }
        
        view.addSubview(emailTitleLabel)
        emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(28)
            $0.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(54)
            $0.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(nicknameTitleLabel)
        nicknameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(12)
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
        
        view.addSubview(passwordTitleLabel)
        passwordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(42)
            $0.left.equalToSuperview().inset(16)
        }
        
        view.addSubview(passwordChangeButton)
        passwordChangeButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(42)
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(46)
            $0.width.equalTo(62)
        }
        
        view.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(44)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(58)
        }
        
        view.addSubview(resignButton)
        resignButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {

        resignButton.gesture().receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let resignVC = ResignVC()
                self?.navigationController?.pushViewController(resignVC, animated: true)
            }.store(in: &viewModel.bag)
        
        nicknameTextField.contentTextField.textPublisher
            .compactMap { $0 }
            .sink { [weak self] in
                self?.viewModel.inputNickname = $0
                if $0.count < 2 || $0.count > 15 {
                    self?.viewModel.isButtonEnabled = false
                }
            }
            .store(in: &viewModel.bag)
        
        nicknameCheckButtonView.gesture()
            .sink { [weak self] _ in
                guard let nickname = self?.nicknameTextField.contentTextField.text else { return }
                self?.authProvider.request(.nicknameCheck(nickname: nickname)) { result in
                    switch result {
                    case .success(let response):
                        guard let data = try? response.map(NicknameCheckResponse.self).data else {
                            LogUtil.d("Response Decoding 실패")
                            return
                        }
                        if data.content == false {
                            self?.viewModel.isButtonEnabled = true
                            self?.nicknameDuplicateedLabel.isHidden = true
                        } else {
                            self?.viewModel.isButtonEnabled = false
                            self?.nicknameDuplicateedLabel.isHidden = false
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
        
        viewModel.$userEmail.receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.emailLabel.text = $0
            }.store(in: &viewModel.bag)
        
        viewModel.$isButtonEnabled.receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] isButtonEnabled in
                self?.editButton.backgroundColor = isButtonEnabled ? Colors.gray001.color : Colors.gray006.color
                self?.editButton.setTitleColor(isButtonEnabled ? Colors.point.color : UIColor.white)
            }.store(in: &viewModel.bag)
        
        editButton.tapPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] in
                let accessToken = KeyChainManager.shared.readAccessToken()
                let jwt = try? JWTDecode.decode(jwt: accessToken)
                guard let memberId = jwt?.subject else { return }
                guard let inputNickname = self?.viewModel.inputNickname else { return }
                
                self?.authProvider.request(.nicknameChange(memberId: memberId, nickname: inputNickname)) { result in
                    switch result {
                    case .success(let response):
                        guard let data = try? response.map(NicknameCheckResponse.self).data else { return }
                        if data.content == false {
                            self?.navigationController?.popToRootViewController(animated: true)
                        } else {
                            LogUtil.d("수정 실패")
                        }
                    case .failure(let error):
                        LogUtil.e(error)
                    }
                }
            }.store(in: &viewModel.bag)
        
    }
    
    // MARK: - Configure
    
    // MARK: - Actions
    
    // MARK: - Functions
}
