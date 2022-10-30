//
//  MyPageVC.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import UIKit
import Then
import SnapKit

import KakaoSDKUser

//MARK: 마이페이지 VC


final class MyPageVC: UIViewController {
    //MARK: - Properties
    
    
    private lazy var kakaoLogoutButton = UIButton().then {
        $0.setTitle("카카오 로그아웃")
        $0.addTarget(self, action: #selector(kakaoLogoutTapped), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let bottomSheetVC = LoginBottomSheetVC()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.delegate = self
        self.present(bottomSheetVC, animated: true)
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(kakaoLogoutButton)
        kakaoLogoutButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(200)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        
    }
    
    // MARK: - Actions
    
    @objc func kakaoLogoutTapped() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension MyPageVC: LoginDelegate {
    func emailSignIn() {
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func emailSignUp() {
        let termsVC = TermsVC()
        navigationController?.pushViewController(termsVC, animated: true)
    }
}
