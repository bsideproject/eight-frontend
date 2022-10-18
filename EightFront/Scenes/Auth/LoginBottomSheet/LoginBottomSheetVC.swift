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

protocol LoginDelegate: AnyObject {
    func emailSignIn()
    func emailSignUp()
}

final class LoginBottomSheetVC: UIViewController {
    // MARK: - Properties
    
    private let viewModel = LoginBottomSheetViewModel()
    private let authProvider = MoyaProvider<AuthAPI>()
    private let bottomHeight: CGFloat = 279
    
    weak var delegate: LoginDelegate?
    
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
        authorizationButtonType: .signUp,
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
    }
    private let emailSignUpButton = UIButton().then {
        $0.setTitle("계정이 없다면? 회원가입", for: .normal)
        $0.setTitleColor(Colors.gray005.color, for: .normal)
        $0.titleLabel?.font = Fonts.Pretendard.regular.font(size: 12)
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
        //        showBottomSheet()
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
        
        // 최상단으로 부터 떨어진 거리
        let topConstant = (view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height)-bottomHeight
        
        bottomSheetView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topConstant)
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
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn)
        animator.addAnimations {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    // 바텀 시트 사라지는 애니메이션
    private func hideBottomSheetAndGoBack() {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn)
        animator.addAnimations {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
            if self.presentationController != nil {
                self.dismiss(animated: false)
            }
        }
        animator.startAnimation()
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
    
    // 카카오 로그인
    private func kakaoLoginButtonTapped() {
        /// 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                
                if let error = error {
                    LogUtil.e("카카오 간편 로그인 실패 : \(error.localizedDescription)")
                }
                
//                guard let fcmToken = NotificationCenter.default.value(forKey: "FCMToken") as? [String: String] else {
//                    LogUtil.e("FCM 토큰을 받아오는데 실패 했습니다.")
//                    return
//                }
                
                self.authProvider.request(.login(
                    param: simpleSignUpRequest(
                        authId: oauthToken?.idToken ?? "",
                        authType: simpleLoginType.kakao.rawValue,
                        deviceID: "fcmToken"
                    ))) { response in
                        switch response {
                        case .success(let result):
                            guard let data = try? result.map(SimpleSignUpResponse.self) else { return }
                            LogUtil.d("간편 로그인 성공 : \(data)")
                        case .failure(let error):
                            LogUtil.e("간편 로그인 실패 > \(error.localizedDescription)")
                        }
                    }
            }
        }
    }
    
    private func emailLoginButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.emailSignIn()
        }
    }
    
    private func emailSignUpButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.emailSignUp()
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
            
            LogUtil.d(
                """
                identityToken > \(identityTorknStr)
                authorizationCode > \(authorizationCodeStr)
                """
            )
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        LogUtil.e(error)
    }
}
