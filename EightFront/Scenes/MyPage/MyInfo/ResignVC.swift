//
//  ResignVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/19.
//

import UIKit
import JWTDecode
import Moya

class ResignVC: UIViewController {
    
    private let authProvider = MoyaProvider<AuthAPI>()
    private let viewModel = ResignViewModel()
    
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "회원 탈퇴"
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "회원탈퇴 시 \n유의사항을 확인해주세요."
        $0.textColor = Colors.gray001.color
        $0.numberOfLines = 0
    }
    
    private let textView = UIView().then {
        $0.layer.cornerRadius = 6
        $0.backgroundColor = Colors.gray008.color
    }
    
    private let textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    
    private let textViewLabel1 = UILabel().then {
        $0.text = "사용하고 계신 아이디는 탈퇴할 경우 재사용 및 복구가 불가능 합니다."
        $0.numberOfLines = 0
    }
    
    private let textViewLabel2 = UILabel().then {
        $0.text = "회원탈퇴 후 개인정보보호법에 의해 3개월동안 회원정보를 별도 보관하며, 3개월 이후 자동삭제됩니다. 보관된 회원 정보는 고객문의 외 다른 용도로 사용되지 않습니다."
        $0.numberOfLines = 0
    }
    
    private let textViewLabel3 = UILabel().then {
        $0.text = "탈퇴 후 등록하셨던 영상, 게시글, 댓글은 자동으로 삭제됩니다."
        $0.numberOfLines = 0
    }
    
    private let confirmView = UIView()
    
    private let confirmCheckBox = UIButton().then {
        $0.setImage(Images.Report.checkboxSelect.image, for: .normal)
        $0.clipsToBounds = true
    }
    
    private let confirmLabel = UILabel().then {
        $0.text = "위 내용을 확인했으며, 탈퇴를 진행합니다."
    }

    private let confirmButtonView = UIView().then {
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 6
    }
    
    private let confirmButtonLabel = UILabel().then {
        $0.text = "회원 탈퇴"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
    }
    
    func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom).offset(26)
            $0.left.equalToSuperview().inset(16)
        }
        
        // 안내 사항
        
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(252)
        }
        
        let textViewLables = [textViewLabel1, textViewLabel2, textViewLabel3]
        textViewLables.forEach {
            textStackView.addArrangedSubview($0)
        }
        
        textView.addSubview(textStackView)
        textStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        // 회원 탈퇴 체크 박스 + 안내 문구
        view.addSubview(confirmView)
        confirmView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(18)
            
            confirmView.addSubview(confirmCheckBox)
            confirmCheckBox.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.size.equalTo(16)
            }
            
            confirmView.addSubview(confirmLabel)
            confirmLabel.snp.makeConstraints {
                $0.left.equalTo(confirmCheckBox.snp.right).offset(12)
                $0.centerY.equalToSuperview()
            }
        }
        
        
        // 회원탈퇴 버튼
        view.addSubview(confirmButtonView)
        confirmButtonView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(58)
            
            confirmButtonView.addSubview(confirmButtonLabel)
            confirmButtonLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
    }
    
    private func bind() {
        
        viewModel.$isChecked.receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] in
                $0 ? self?.confirmCheckBox.setImage(Images.Report.checkboxSelect.image) : self?.confirmCheckBox.setImage(Images.Report.checkboxNone.image)
                
                self?.confirmButtonView.backgroundColor = $0 ? Colors.gray001.color : Colors.gray006.color
                self?.confirmButtonLabel.textColor = $0 ? Colors.point.color : .white
                
            }.store(in: &viewModel.bag)
        
        confirmCheckBox.tapPublisher.receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.isChecked.toggle()
            }.store(in: &viewModel.bag)
        
        confirmButtonView.gesture().receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if self?.viewModel.isChecked == true {
                    resign()
                }
            }.store(in: &viewModel.bag)
        
        func resign() {
            let accessToken = KeyChainManager.shared.readAccessToken()
            let jwt = try? JWTDecode.decode(jwt: accessToken)
            guard let memberId = jwt?.subject else { return }
            authProvider.request(.memberResign(memberId: memberId)) { [weak self] result in
                switch result {
                case .failure(let error):
                    LogUtil.e(error)
                case .success(let response):
                    LogUtil.d(response)
                    self?.viewModel.kakaoResign { bool in
                        if bool {
                            if KeyChainManager.shared.deleteAccessToken() {
                                UserDefaults.standard.removeObject(forKey: "nickName")
                                UserDefaults.standard.removeObject(forKey: "email")
                                let resignVC = ResignSuccessVC()
                                self?.navigationController?.pushViewController(resignVC, animated: true)
                            } else {
                                print("키체인 제거 실패")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}