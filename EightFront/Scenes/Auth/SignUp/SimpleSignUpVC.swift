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
    
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "회원가입"
    }
    
    // 회원가입 버튼
    private let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(Colors.point.color, for: .normal)
        $0.setTitleColor(UIColor.white, for: .disabled)
        $0.setBackgroundColor(Colors.gray001.color, for: .normal)
        $0.setBackgroundColor(Colors.gray006.color, for: .disabled)
        $0.layer.cornerRadius = 4
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
    }
    
    // MARK: - makeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigationView)
        view.addSubview(signUpButton)
        
        commonNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        signUpButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    private func bind() {
        
        let accessToken = KeyChainManager.shared.readAccessToken()
        signUpButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.authProvider.request(
                    .socialSignUp(
                        param: SocialSignUpRequest(
                        accessToken: accessToken,
                        nickName: "니해이"
                    ))) { [weak self] response in
                        switch response {
                        case .success(let result):
                            guard let data = try? result.map(SimpleSignUpResponse.self).data else {
                                LogUtil.d("Response Decoding 실패")
                                return
                            }
                            let signUpSuccessVC = SignUpSuccessVC()
                            self?.navigationController?.pushViewController(signUpSuccessVC, animated: true)
                            LogUtil.d(data)
                        case .failure(let error):
                            LogUtil.e("간편 회원가입 실패 > \(error.localizedDescription)")
                        }
                    }
            }.store(in: &disposeBag)
    }
}
