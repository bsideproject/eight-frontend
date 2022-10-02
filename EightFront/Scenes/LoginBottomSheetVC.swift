//
//  LoginBottomSheetVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/09/28.
//

import AuthenticationServices
import Combine
import UIKit
import CombineCocoa
import KakaoSDKUser

final class LoginBottomSheetVC: UIViewController {
    
    // MARK: - Properties
    var cancelBag = Set<AnyCancellable>()
    private let viewModel = LoginBottomSheetViewModel()
    private let bottomHeight: CGFloat = 500
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    private let emailTextField = UITextField().then {
        $0.keyboardType = .emailAddress
        $0.placeholder = "이메일을 입력해주세요."
    }
    private let passwordTextField = UITextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "비밀번호를 입력해주세요."
    }
    private let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .lightGray
    }
    private let appleLoginButton = ASAuthorizationAppleIDButton(
        authorizationButtonType: .signUp,
        authorizationButtonStyle: .whiteOutline
    )
    private let kakaoLoginButton = UIButton().then {
        guard let buttonImage = UIImage(named: "kakao_login_medium_narrow") else {
            LogUtil.e("카카오 로그인 버튼 이미지를 확인해주세요.")
            return
        }
        $0.contentMode = .scaleAspectFit
        $0.setImage(buttonImage, for: .normal)
    }
    private let dimmedBackView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 27
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    private let dismissIndicatorView = UIView().then {
        $0.backgroundColor = .systemGray2
        $0.layer.cornerRadius = 3
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
        setupGestureRecognizer()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    // MARK: - Bind
    
    private func bind() {
        appleLoginButton
            .controlEventPublisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.appleLoginButtonTapped()
            }
            .store(in: &cancelBag)
        
        kakaoLoginButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.kakaoLoginButtonTapped()
            }
            .store(in: &cancelBag)
        
        emailTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap{ $0 }
            .assign(to: \.emailInput, on: viewModel)
            .store(in: &cancelBag)
        
        passwordTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap{ $0 }
            .assign(to: \.passwordInput, on: viewModel)
            .store(in: &cancelBag)
        
        viewModel.isLoginButtonValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                UIView.animate(withDuration: 0.25) {
                    self?.loginButton.backgroundColor = isValid ? .systemBlue : .lightGray
                    self?.loginButton.isEnabled = isValid
                }
            }
            .store(in: &cancelBag)
        
        loginButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                LogUtil.d("로그인 버튼 눌림")
            }
            .store(in: &cancelBag)
    }

    // MARK: - Functions
    
    private func makeUI() {
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        view.addSubview(dismissIndicatorView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        
        dimmedBackView.alpha = 0.0
    
        dimmedBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // TODO: 추후 수정
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        
        NSLayoutConstraint.activate([
            bottomSheetViewTopConstraint
        ])
        
        bottomSheetView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        dismissIndicatorView.snp.makeConstraints {
            $0.width.equalTo(102)
            $0.height.equalTo(7)
            $0.top.equalTo(bottomSheetView.snp.top).inset(12)
            $0.centerX.equalTo(bottomSheetView.snp.centerX)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).inset(30)
            $0.centerX.equalTo(bottomSheetView)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(10)
            $0.centerX.equalTo(emailTextField)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(10)
            $0.centerX.equalTo(emailTextField)
            $0.width.equalTo(appleLoginButton.snp.width)
            $0.height.equalTo(appleLoginButton.snp.height)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.centerX.equalTo(emailTextField)
        }
        
        // TODO: 추후 디자인에 따라 이미지 크기 수정
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(10)
            $0.centerX.equalTo(bottomSheetView)
            $0.height.equalTo(appleLoginButton.snp.height)
            $0.width.equalTo(appleLoginButton.snp.width)
        }
        
    }
    
    // GestureRecognizer 세팅 작업
    private func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        // 스와이프 했을 때, 바텀시트를 내리는 swipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    // 바텀 시트 표출 애니메이션
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // 바텀 시트 사라지는 애니메이션
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - Actions
    
    // UITapGestureRecognizer 연결 함수 부분
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    // UISwipeGestureRecognizer 연결 함수 부분
    @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheetAndGoBack()
            default:
                break
            }
        }
    }
    
    /// 애플 로그인
    private func appleLoginButtonTapped() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    private func kakaoLoginButtonTapped() {
        /// 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    LogUtil.e(error)
                } else {
                    LogUtil.d("loginWithKakaoTalk() success.")
                    
                    // 간편 로그인 정보
                    _ = oauthToken
                    
                }
            }
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginBottomSheetVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = credential.user
            
            LogUtil.d(user)
            
            if let email = credential.email {
                LogUtil.d(email)
            }
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        LogUtil.e(error)
    }
}
