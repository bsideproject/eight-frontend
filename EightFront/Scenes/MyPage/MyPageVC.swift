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
import Moya

//MARK: 마이페이지 VC

final class MyPageVC: UIViewController {
    let viewModel = MyPageViewModel()
    let authProvider = MoyaProvider<AuthAPI>()
    
    //MARK: - Properties
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "마이페이지"
        $0.backButton.isHidden = true
    }
    private let myInfoView = UIView()
    private let profileImageView = UIView().then {
        $0.backgroundColor = Colors.gray007.color
        $0.layer.cornerRadius = 109/2
    }
    private let profileImage = UIImageView().then {
        let image = UIImage(named: "DropIcon")
        $0.image = image
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = Fonts.Templates.title2.font
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = Colors.gray008.color
    }
    
    private let myPageTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.alwaysBounceVertical = false
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
        authProvider.requestPublisher(.userInfo)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    LogUtil.d("유저 정보 가져오기 API 호출 완료")
                case .failure(let error):
                    LogUtil.e(error)
                }
            } receiveValue: { [weak self] response in
                let data = try? response.map(UserInfoResponse.self)
                self?.nicknameLabel.text = data?.data?.content.nickname
            }.store(in: &viewModel.bag)
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
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(203)
            
            myInfoView.addSubview(profileImageView)
            profileImageView.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(109)
                
                profileImageView.addSubview(profileImage)
                profileImage.snp.makeConstraints {
                    $0.center.equalToSuperview()
                    $0.width.equalTo(57)
                    $0.height.equalTo(68)
                }
            }
            myInfoView.addSubview(nicknameLabel)
            nicknameLabel.snp.makeConstraints {
                $0.top.equalTo(profileImageView.snp.bottom).offset(6)
                $0.height.equalTo(30)
                $0.centerX.equalToSuperview()
            }
        }
        
        view.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(myInfoView.snp.bottom)
            $0.height.equalTo(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        view.addSubview(myPageTableView)
        myPageTableView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(16)
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
        
        navigationView.backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
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
        cell.selectionStyle = .none
        cell.configure(myPageMenus: viewModel.cellForRowAt(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension MyPageVC: BottomSheetDelegate {
    func loginSuccess() {
        self.tabBarController?.selectedIndex = 0
    }
}
