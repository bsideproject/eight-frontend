//
//  NavigationSettingVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import UIKit

class NavigationSettingVC: UIViewController {
    
    // MARK: - Properties
    private let viewModel = NavigationSettinViewModel()
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "네비게이션 앱 설정"
    }
    
    private var naverMapView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.layer.borderColor = Colors.gray006.color.cgColor
        $0.layer.borderWidth = 1
    }
    
    private var naverCoverView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.layer.borderColor = Colors.gray006.color.cgColor
        $0.layer.borderWidth = 1
    }
    
    private var naverIcon = UIImageView().then {
        let image = Images.NavigationIcon.naverCircleIcon.image
        $0.image = image
    }
    
    private var naverLabel = UILabel().then {
        $0.text = "네이버 지도"
        $0.font = Fonts.Templates.subheader3.font
    }
    
    private var kakaoMapView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.layer.borderColor = Colors.gray006.color.cgColor
        $0.layer.borderWidth = 1
    }
    
    private var kakaoCoverView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.layer.borderColor = Colors.gray006.color.cgColor
        $0.layer.borderWidth = 1
    }
    
    private var kakaoIcon = UIImageView().then {
        let image = Images.NavigationIcon.kakaoCircleIcon.image
        $0.image = image
    }

    private var kakaoLabel = UILabel().then {
        $0.text = "카카오맵"
        $0.font = Fonts.Templates.subheader3.font
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
        
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(47)
        }
        
        view.addSubview(naverMapView)
        naverMapView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(124)
            $0.height.equalTo(70)
            $0.horizontalEdges.equalToSuperview().inset(17)
            
            naverMapView.addSubview(naverIcon)
            naverIcon.snp.makeConstraints {
                $0.size.equalTo(42)
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(16)
            }
            
            naverMapView.addSubview(naverLabel)
            naverLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(naverIcon.snp.right).offset(8)
            }
            
            naverMapView.addSubview(naverCoverView)
            naverCoverView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        view.addSubview(kakaoMapView)
        kakaoMapView.snp.makeConstraints {
            $0.top.equalTo(naverMapView.snp.bottom).offset(16)
            $0.height.equalTo(70)
            $0.horizontalEdges.equalToSuperview().inset(17)
            
            kakaoMapView.addSubview(kakaoIcon)
            kakaoIcon.snp.makeConstraints {
                $0.size.equalTo(42)
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(16)
            }
            
            kakaoMapView.addSubview(kakaoLabel)
            kakaoLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(kakaoIcon.snp.right).offset(8)
            }
            
            kakaoMapView.addSubview(kakaoCoverView)
            kakaoCoverView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
        }

    }
    
    private func bind() {
        naverMapView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                UserDefaults.standard.set("naver", forKey: "navigation")
                self?.viewModel.navagation = "naver"
            }.store(in: &viewModel.bag)
        
        kakaoMapView.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                UserDefaults.standard.set("kakao", forKey: "navigation")
                self?.viewModel.navagation = "kakao"
            }.store(in: &viewModel.bag)
        
        viewModel.$navagation.receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.naverMapView.layer.borderColor = $0 == "naver" ? UIColor.black.cgColor : Colors.gray006.color.cgColor
                self?.kakaoMapView.layer.borderColor = $0 == "kakao" ? UIColor.black.cgColor : Colors.gray006.color.cgColor
                
                self?.naverCoverView.backgroundColor = $0 == "naver" ? UIColor.clear : UIColor.white.withAlphaComponent(0.75)
                self?.kakaoCoverView.backgroundColor = $0 == "kakao" ? UIColor.clear : UIColor.white.withAlphaComponent(0.75)
                
            }.store(in: &viewModel.bag)
        
        commonNavigationView.backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &viewModel.bag)
        
    }
    
    // MARK: - Configure
    
    // MARK: - Actions
    
    // MARK: - Functions
}
