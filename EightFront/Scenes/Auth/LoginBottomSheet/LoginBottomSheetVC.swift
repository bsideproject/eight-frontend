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
import Moya
import JWTDecode

protocol BottomSheetDelegate: AnyObject {
    func loginSuccess()
}

enum SignType: String {
    case apple = "apple"
    case kakao = "kakao"
    case email = "email"
}

final class LoginBottomSheetVC: UIViewController {
    
    // MARK: - Properties
    private let authProvider = MoyaProvider<AuthAPI>()
    private let viewModel = LoginBottomSheetViewModel()
    private var bottomSheetHeight: CGFloat = 279
    
    weak var bottomSheetDelegate: BottomSheetDelegate?
    
    private let dimmedBackView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 27
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    private let loginBottomSheetTitleLabel = UILabel().then {
        $0.font = Fonts.Templates.title.font
        $0.textColor = Colors.gray001.color
        $0.text = "로그인이 필요해요."
        $0.textAlignment = .center
    }
    private let loginBottomSheetSubtitleLabel = UILabel().then {
        $0.font = Fonts.Templates.caption1.font
        $0.textColor = Colors.gray001.color
        $0.text = "SNS로 간편하게 시작하세요!"
        $0.textAlignment = .center
    }
    private let appleLoginButton = ASAuthorizationAppleIDButton(
        authorizationButtonType: .signIn,
        authorizationButtonStyle: .black
    )
    private let kakaoLoginButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(Images.KakaoLoginButton.largeWide.image, for: .normal)
    }
    // TODO: 디자인 시안에서 폰트 설정 안돼있음
    private let emailLoginButton = UIButton().then {
        $0.setTitle("이메일로 로그인하기", for: .normal)
        $0.setTitleColor(Colors.gray005.color, for: .normal)
        $0.titleLabel?.font = Fonts.Pretendard.regular.font(size: 12)
        // 이메일 API 나오면 그 때 false로 수정
        $0.isHidden = true
    }
    private let emailSignUpButton = UIButton().then {
        $0.setTitle("계정이 없다면? 회원가입", for: .normal)
        $0.setTitleColor(Colors.gray005.color, for: .normal)
        $0.titleLabel?.font = Fonts.Pretendard.regular.font(size: 12)
        // 이메일 API 나오면 그 때 false로 수정
        $0.isHidden = true
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
        setupGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    // MARK: - makeUI
    private func makeUI() {
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        view.addSubview(loginBottomSheetTitleLabel)
        view.addSubview(loginBottomSheetSubtitleLabel)
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        view.addSubview(emailLoginButton)
        view.addSubview(emailSignUpButton)
        
        dimmedBackView.alpha = 0.0
        dimmedBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bottomSheetView.snp.makeConstraints {
            $0.height.equalTo(bottomSheetHeight)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        loginBottomSheetTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView).inset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        loginBottomSheetSubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView).inset(80)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView).inset(106)
            $0.width.equalTo(343)
            $0.height.equalTo(48)
            $0.centerX.equalTo(bottomSheetView)
        }
        
        // TODO: 추후 디자인에 따라 이미지 크기 수정
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView).inset(162)
            $0.width.equalTo(343)
            $0.height.equalTo(48)
            $0.centerX.equalTo(bottomSheetView)
        }
        
        emailLoginButton.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView).inset(232)
            $0.height.equalTo(14)
            $0.leading.equalToSuperview().inset(71)
        }
        
        emailSignUpButton.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView).inset(232)
            $0.height.equalTo(14)
            $0.trailing.equalToSuperview().inset(51)
        }
    }
    
    // MARK: - Bind
    private func bind() {
        appleLoginButton
            .controlEventPublisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.appleLoginButtonTapped()
            }
            .store(in: &viewModel.bag)
        
        kakaoLoginButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.kakaoLoginButtonTapped()
            }
            .store(in: &viewModel.bag)
        
        emailLoginButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.emailLoginButtonTapped()
            }.store(in: &viewModel.bag)
        
        emailSignUpButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.emailSignUpButtonTapped()
            }.store(in: &viewModel.bag)
        
    }
    
    // MARK: - Functions
    // GestureRecognizer 세팅 작업
    private func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
    }
    
    // 바텀 시트 표출 애니메이션
    private func showBottomSheet() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn)
        animator.addAnimations {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    // 바텀 시트 사라지는 애니메이션
    private func hideBottomSheetAndGoBack() {
        self.dimmedBackView.alpha = 0.0
        self.view.layoutIfNeeded()
        if self.presentationController != nil {
            self.dismiss(animated: false)
        }
    }
    
    // MARK: - Actions
    // UITapGestureRecognizer 연결 함수 부분
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
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
    
    // 카카오 로그인
    private func kakaoLoginButtonTapped() {
        /// 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    LogUtil.e("카카오 간편 로그인 실패 : \(error.localizedDescription)")
                }
                
                self.authProvider.request(.socialSignIn(
                    param: SocialSignInRequest(
                        accessToken: oauthToken?.accessToken ?? "",
                        social: "kakao"
                    ))) { reponse in
                        switch reponse {
                        case .success(let result):
                            guard let data = try? result.map(SimpleSignInResponse.self).data else {
                                LogUtil.e("Response Decoding 실패")
                                return
                            }
                            
                            guard let content = data.content else {
                                LogUtil.e("data.content unWrapping 실패")
                                return
                            }
                            
                            if content.type == "sign-in" {
                                guard let accessToken = content.accessToken else { return }
                                if KeyChainManager.shared.createAccessToken(accessToken) {
                                    self.dismiss(animated: false)
                                } else {
                                    LogUtil.e("액세스 토큰을 키체인에 저장하지 못했습니다.")
                                }
                            } else if content.type == "sign-up" {
                                // 회원가입
                                guard let accessToken = content.accessToken else { return }
                                KeyChainManager.shared.accessToken = accessToken
                                    self.dismiss(animated: false) {
                                        let termsVC = TermsVC()
                                        termsVC.type = SignType.kakao.rawValue
                                        UIWindow().visibleViewController?.navigationController?.pushViewController(termsVC, animated: true)
                                    }
                            }
                        case .failure(let error):
                            LogUtil.e("간편 로그인 실패 > \(error.localizedDescription)")
                        }
                    }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self](oauthToken, error) in
                
                guard let oauthToken else { return }
                    
                if let error = error {
                    LogUtil.e("카카오 간편 로그인 실패 : \(error.localizedDescription)")
                }
                
                self?.authProvider.request(.socialSignIn(
                    param: SocialSignInRequest(
                    accessToken: oauthToken.accessToken,
                    social: "kakao"
                    ))) { reponse in
                        switch reponse {
                        case .success(let result):
                            guard let data = try? result.map(SimpleSignInResponse.self).data else {
                                LogUtil.e("Response Decoding 실패")
                                return
                            }
                            
                            guard let content = data.content else {
                                LogUtil.e("data.content unWrapping 실패")
                                return
                            }
                            
                            if content.type == "sign-in" {
                                self?.dismiss(animated: false) {
                                    guard let accessToken = content.accessToken else { return }
                                    if KeyChainManager.shared.createAccessToken(accessToken) {
                                        LogUtil.d("액세스 토큰 저장 성공")
                                    } else {
                                        LogUtil.e("액세스 토큰을 키체인에 저장하지 못했습니다.")
                                    }
                                }
                            } else if content.type == "sign-up" {
                                // 회원가입
                                self?.dismiss(animated: false) {
                                    let termsVC = TermsVC()
                                    termsVC.type = SignType.kakao.rawValue
                                    UIWindow().visibleViewController?.navigationController?.pushViewController(termsVC, animated: true)
                                }
                            }
                        case .failure(let error):
                            LogUtil.e("간편 로그인 실패 > \(error.localizedDescription)")
                        }
                    }
            }
        }
    }
    
    private func emailLoginButtonTapped() {
        dismiss(animated: false) {
            let loginVC = LoginVC()
            UIWindow().visibleViewController?.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    private func emailSignUpButtonTapped() {
        dismiss(animated: false) {
            let termsVC = TermsVC()
            UIWindow().visibleViewController?.navigationController?.pushViewController(termsVC, animated: true)
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginBottomSheetVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let identityToken = credential.identityToken,
                  let authorizationCode = credential.authorizationCode else{
                return
            }
            
            guard let identityTorknStr = String(data: identityToken, encoding: .utf8),
                  let authorizationCodeStr = String(data: authorizationCode, encoding: .utf8) else {
                return
            }

            authProvider.request(
                .appleSignIn(param: SocialSignInRequest(
                    identityToken: identityTorknStr
                ))) { result in
                    switch result {
                    case .success(let response):
                        guard let data = try? response.map(SimpleSignInResponse.self).data else {
                            LogUtil.e("Response Decoding 실패")
                            return
                        }
                        LogUtil.d(data)
                    case .failure(let error):
                        LogUtil.e(error)
                    }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        LogUtil.e(error)
    }
}
