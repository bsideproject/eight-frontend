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
    private let commontNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "네비게이션 앱 설정"
    }
    
    private var naverMapView = UIView()
    private var naverSelectedIamgeView = UIImageView().then {
        $0.layer.cornerRadius = 11
    }
    private var naverLabel = UILabel().then {
        $0.text = "네이버 지도"
    }
    
    private var kakaoMapView = UIView()
    private var kakaoSelectedIamgeView = UIImageView().then {
        $0.layer.cornerRadius = 11
    }
    private var kakaoLabel = UILabel().then {
        $0.text = "카카오맵"
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
        
        view.addSubview(naverMapView)
        naverMapView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(124)
            $0.height.equalTo(47)
            $0.horizontalEdges.equalToSuperview().inset(21)
        }
        
        naverMapView.addSubview(naverSelectedIamgeView)
        naverSelectedIamgeView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(22)
        }
        
        naverMapView.addSubview(naverLabel)
        naverLabel.snp.makeConstraints {
            $0.left.equalTo(naverSelectedIamgeView.snp.right).offset(32)
            $0.centerY.equalToSuperview()
        }
        
        
        view.addSubview(kakaoMapView)
        kakaoMapView.snp.makeConstraints {
            $0.top.equalTo(naverLabel.snp.bottom).offset(14)
            $0.height.equalTo(47)
            $0.horizontalEdges.equalToSuperview().inset(21)
        }
        
        kakaoMapView.addSubview(kakaoSelectedIamgeView)
        kakaoSelectedIamgeView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(22)
        }
        
        kakaoMapView.addSubview(kakaoLabel)
        kakaoLabel.snp.makeConstraints {
            $0.left.equalTo(kakaoSelectedIamgeView.snp.right).offset(32)
            $0.centerY.equalToSuperview()
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
                self?.naverSelectedIamgeView.backgroundColor = $0 == "naver" ? Colors.point.color : Colors.gray006.color
                self?.kakaoSelectedIamgeView.backgroundColor = $0 == "kakao" ? Colors.point.color : Colors.gray006.color
            }.store(in: &viewModel.bag)
        
    }
    
    // MARK: - Configure
    
    // MARK: - Actions
    
    // MARK: - Functions
}
