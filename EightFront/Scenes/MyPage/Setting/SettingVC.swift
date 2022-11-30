//
//  SettingVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import UIKit

class SettingVC: UIViewController {
    
    // MARK: properties
    
    private var viewModel = SettingViewModel()
    
    // 상단 바
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "설정"
    }
    
    private let notificationView = UIView()
    // 알림
    private let notificationLabel = UILabel().then {
        $0.text = "알림"
        $0.font = Fonts.Templates.subheader.font
    }
    private let notificationSwitch = UISwitch().then {
        $0.isOn = true
    }
    
    // 차단 목록
    private let blockListView = UIView()
    private let blockLabel = UILabel().then {
        $0.text = "차단 목록"
    }
    
    // 서비스 이용약관
    private let policyView = UIView()
    private let policyLabel = UILabel().then {
        $0.text = "서비스 이용약관"
    }
    
    // 위치기반 서비스 약관
    private let locationView = UIView()
    private let locationLabel = UILabel().then {
        $0.text = "위치기반 서비스약관"
    }
    
    // 개인 정보 처리 방침
    private let privacyView = UIView()
    private let privacyLabel = UILabel().then {
        $0.text = "개인정보 처리방침"
    }
    
    // 버전 정보
    private let versionView = UIView()
    private let versionTitleLabel = UILabel().then {
        $0.text = "버전정보"
    }
    private let versionLabel = UILabel().then {
        guard let infoDic = Bundle.main.infoDictionary,
              let appBuildVersion = infoDic["CFBundleVersion"] as? String,
              let appVersionName = infoDic["CFBundleShortVersionString"] as? String else { return }
        $0.text = appVersionName
        $0.textColor = Colors.gray005.color
    }
    
    // 로그 아웃
    private let logoutView = UILabel()
    private let logoutLabel = UILabel().then {
        $0.text = "로그아웃"
    }
    
//    private let logoutView = LogoutView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        makeUI()
        bind()
    }
    
    
    // MARK: - makeUI
    private func makeUI() {
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        // 알림
        
        view.addSubview(notificationView)
        notificationView.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(19)
            $0.height.equalTo(45)
            
            notificationView.addSubview(notificationLabel)
            notificationLabel.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
            notificationView.addSubview(notificationSwitch)
            notificationSwitch.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview()
            }
        }
        
        // 차단
        view.addSubview(blockListView)
        blockListView.snp.makeConstraints {
            $0.top.equalTo(notificationLabel.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(19)
            $0.height.equalTo(45)
            
            blockListView.addSubview(blockLabel)
            blockLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
            }
        }
        
        //이용약관
        view.addSubview(policyView)
        policyView.snp.makeConstraints {
            $0.top.equalTo(blockListView.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(19)
            $0.height.equalTo(45)
            
            policyView.addSubview(policyLabel)
            policyLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
            }
        }
        
        // 위치정보
        view.addSubview(locationView)
        locationView.snp.makeConstraints {
            $0.top.equalTo(policyView.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(19)
            $0.height.equalTo(45)
            
            locationView.addSubview(locationLabel)
            locationLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
            }
        }
        
        // 개인정보
        view.addSubview(privacyView)
        privacyView.snp.makeConstraints {
            $0.top.equalTo(locationView.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(19)
            $0.height.equalTo(45)
            
            privacyView.addSubview(privacyLabel)
            privacyLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
            }
        }
        
        // 버전
        view.addSubview(versionView)
        versionView.snp.makeConstraints {
            $0.top.equalTo(privacyView.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(19)
            $0.height.equalTo(45)
            
            versionView.addSubview(versionTitleLabel)
            versionTitleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
            }
            versionView.addSubview(versionLabel)
            versionLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview()
            }
        }
        
        // 로그아웃
        view.addSubview(logoutView)
        logoutView.snp.makeConstraints {
            $0.top.equalTo(versionView.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(19)
            $0.height.equalTo(45)
            
            logoutView.addSubview(logoutLabel)
            logoutLabel.snp.makeConstraints {
                $0.left.equalToSuperview()
            }
        }
        
    } // makeUI
    
    // MARK: - bind
    private func bind() {
        notificationSwitch.isOnPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] isOn in
                UserDefaults.standard.set(isOn, forKey: "isNotification")
                // 유저 DB에 알림 여부 설정 필요
                self?.viewModel.requestIsNotification()
            })
            .store(in: &viewModel.bag)
        
        blockListView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // TODO: 차단 목록 이동
                let blockTableVC = BlockVC()
                self?.navigationController?.pushViewController(blockTableVC, animated: true)
            }.store(in: &viewModel.bag)
        
        policyView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let webViewVC = WebViewVC()
                webViewVC.url = "https://sites.google.com/view/droptheclothuse"
                webViewVC.titleLabel = "서비스 이용 약관"
                self?.navigationController?.pushViewController(webViewVC, animated: true)
            }.store(in: &viewModel.bag)
        
        locationView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // TODO: 위치 기반 서비스
                let webViewVC = WebViewVC()
                webViewVC.url = "https://sites.google.com/view/droptheclothgpsuse"
                webViewVC.titleLabel = "위치기반 서비스약관"
                self?.navigationController?.pushViewController(webViewVC, animated: true)
            }.store(in: &viewModel.bag)
        
        privacyView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // TODO: 개인 정보 처리 방침
                let webViewVC = WebViewVC()
                webViewVC.url = "https://sites.google.com/view/droptheclothprivacy"
                webViewVC.titleLabel = "개인정보 처리방침"
                self?.navigationController?.pushViewController(webViewVC, animated: true)
            }.store(in: &viewModel.bag)
        
        logoutView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // TODO: 로그아웃
                if KeyChainManager.shared.deleteAccessToken() {
                    let tabbar = MainTabbarController()
                    let navi = CommonNavigationViewController(rootViewController: tabbar)
                    self?.view.window?.rootViewController = navi
                }
            }.store(in: &viewModel.bag)
        
        viewModel.$isNotification
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isNotification in
                self?.notificationSwitch.isOn = isNotification
            }.store(in: &viewModel.bag)
        
        commonNavigationView.backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &viewModel.bag)
        
    }// bind
    
}
