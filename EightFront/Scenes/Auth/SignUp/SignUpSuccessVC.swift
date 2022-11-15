//
//  SignUpSuccessVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/02.
//

import UIKit
import Combine

final class SignUpSuccessVC: UIViewController {
    
    private var cancleBag = Set<AnyCancellable>()
    
    // MARK: - Properties
    private let circleView = UIView().then {
        $0.backgroundColor = Colors.gray001.color
        $0.layer.cornerRadius = 39
    }
    private let checkImageView = UIImageView().then {
        $0.image = Images.Report.checkComplete.image
    }
    private let successLabel = UILabel().then {
        $0.text = "회원가입이 완료되었어요!"
        $0.font = Fonts.Templates.headline.font
    }
    private let confirmButton = UIButton().then {
        $0.setTitle("완료")
        $0.backgroundColor = Colors.gray001.color
        $0.setTitleColor(Colors.point.color)
    }
    private let homeButton = UIButton().then {
        $0.setTitle("홈")
        $0.setTitleColor(Colors.point.color)
        $0.titleLabel?.font = Fonts.Templates.subheader.font
        $0.layer.backgroundColor = Colors.gray002.color.cgColor
        $0.layer.cornerRadius = 4
    }
    
    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
    }
    
    // MARK: - MakeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(circleView)
        circleView.addSubview(checkImageView)
        
        view.addSubview(successLabel)
        view.addSubview(homeButton)
        
        circleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(276)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(78)
        }
        checkImageView.snp.makeConstraints {
            $0.width.equalTo(38)
            $0.height.equalTo(25)
            $0.center.equalToSuperview()
        }
        successLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(378)
            $0.left.equalToSuperview().inset(74)
            $0.right.equalToSuperview().inset(60)
        }
        homeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(710)
            $0.right.left.equalToSuperview().inset(16)
            $0.height.equalTo(58)
        }
    }
    // MARK: - Bind
    private func bind() {
        homeButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .store(in: &cancleBag)
    }
    
    // MARK: - Actions
    
    // MARK: - Functions
    
}
