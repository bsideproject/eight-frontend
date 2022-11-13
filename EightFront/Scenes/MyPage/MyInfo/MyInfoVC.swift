//
//  MyInfoVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import UIKit
import KakaoSDKUser

class MyInfoVC: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = MyInfoViewModel()
    
    private let commontNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "내 정보 수정"
    }
    
    private let profileImageView = UIImageView().then {
//        let profileImage = UIImage(systemName: "person")
//        $0.image = profileImage
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 44
    }
    
    private let emailTitleLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = Fonts.Templates.subheader3.font
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "eight@example.com"
        $0.font = Fonts.Templates.body1.font
    }
    
    private let nicknameTitleLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Fonts.Templates.subheader3.font
    }
    
    private let nicknameTextField = CommonTextFieldView(isTitleHidden: true, placeholder: "15자 이내의 닉네임을 입력해주세요.")
    
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
        $0.setTitleColor(Colors.point.color)
        $0.backgroundColor = Colors.gray001.color
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
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(46)
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
        
        editButton.gesture().receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let alert = UIAlertController(title: "수정", message: "미구현", preferredStyle: .alert)
                let okay = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                    self?.dismiss(animated: true)
                }
                alert.addAction(okay)
                
                self?.present(alert, animated: true)
            }.store(in: &viewModel.bag)
        
        resignButton.gesture().receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let alert = UIAlertController(title: "회원 탈퇴", message: "회원 탈퇴 완료", preferredStyle: .alert)
                
                let okay = UIAlertAction(title: "탈퇴", style: .default) { [weak self] _ in
                    self?.viewModel.kakaoResign()
                    if KeyChainManager.shared.deleteAccessToken() {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
                    self?.dismiss(animated: true)
                }
                
                alert.addAction(cancel)
                alert.addAction(okay)
                
                self?.present(alert, animated: true)
                
            }.store(in: &viewModel.bag)
    }
    
    // MARK: - Configure
    
    // MARK: - Actions
    
    // MARK: - Functions
}
