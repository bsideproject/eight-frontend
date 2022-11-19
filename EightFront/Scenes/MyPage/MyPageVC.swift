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
    private let nicknameLabel = UILabel().then {
        $0.font = Fonts.Templates.title.font
    }
    private let myPageTableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeUI()
        bind()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let accessToken = KeyChainManager.shared.readAccessToken()
        
        if accessToken.isEmpty {
            let bottomSheetVC = LoginBottomSheetVC()
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            bottomSheetVC.delegate = self
            self.present(bottomSheetVC, animated: false)
        } else {
            let nickName = UserDefaults.standard.object(forKey: "nickName") as? String
            nicknameLabel.text = nickName
        }
        
        if UserDefaults.standard.object(forKey: "nickName") as? String == nil {
            nicknameLabel.text = "로그인을 해주세요."
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
        navigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(47)
        }
        
        view.addSubview(myInfoView)
        myInfoView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(34)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        myInfoView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        view.addSubview(myPageTableView)
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
                self?.nicknameLabel.text = $0
            }.store(in: &viewModel.bag)
        
        myInfoView
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let myInfo = MyInfoVC()
                self?.navigationController?.pushViewController(myInfo, animated: true)
            }.store(in: &viewModel.bag)
    }
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

extension MyPageVC: LoginDelegate {
    func loginSuccess(userInfo: UserInfo) {
        nicknameLabel.text = userInfo.nickName
    }
}
