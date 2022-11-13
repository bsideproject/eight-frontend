//
//  MyPageVC.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import UIKit
import Then
import SnapKit

import JWTDecode
import KakaoSDKUser

//MARK: 마이페이지 VC

final class MyPageVC: UIViewController {
    
    let viewModel = MyPageViewModel()
    
    //MARK: - Properties
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "마이페이지"
    }
    private let myInfoView = UIView()
    private let nameLabel = UILabel().then {
        $0.text = "김에잇"
        $0.font = Fonts.Templates.title.font
    }
    private let myPageTableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    private lazy var logoutButton = UIButton().then {
        $0.setTitle("로그아웃")
        $0.setTitleColor(UIColor.black)
    }
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeUI()
        bind()
        
        guard let userInfo = UserDefaults.standard.object(forKey: "userInfo") as? [String: Any] else { return }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let accessToken = KeyChainManager.shared.readAccessToken()
        
        if accessToken.isEmpty {
            let bottomSheetVC = LoginBottomSheetVC()
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            self.present(bottomSheetVC, animated: false)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: - Configure
    private func configure() {
        myPageTableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(myInfoView)
        
        myInfoView.addSubview(nameLabel)
        view.addSubview(myPageTableView)
        
        view.addSubview(logoutButton)
        navigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(47)
        }
        myInfoView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(34)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        logoutButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        myPageTableView.snp.makeConstraints {
            $0.top.equalTo(myInfoView.snp.bottom).offset(45)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        viewModel.$nickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.nameLabel.text = $0
            }.store(in: &viewModel.bag)
        
        myInfoView
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let myInfo = MyInfoVC()
                self?.navigationController?.pushViewController(myInfo, animated: true)
            }.store(in: &viewModel.bag)
        
        logoutButton.gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if KeyChainManager.shared.deleteAccessToken() {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }.store(in: &viewModel.bag)
        
    }
    
    // MARK: - Actions
    
}

extension MyPageVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = viewModel.didSelectRowAt(indexPath: indexPath).destination
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension MyPageVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }
        cell.configure(myPageMenus: viewModel.cellForRowAt(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
