//
//  SignUpSuccessVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/02.
//

import UIKit

class SignUpSuccessVC: UIViewController {
    
    // MARK: - Properties
    
    private let successLabel = UILabel().then {
        $0.text = "회원가입이 완료되었어요!"
        $0.font = Fonts.Templates.headline.font
    }
    
    private let confirmButton = UIButton().then {
        $0.setTitle("완료")
        $0.backgroundColor = Colors.gray001.color
        $0.setTitleColor(Colors.point.color)
    }
    
    // MARK: - Lift Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    // MARK: - MakeUI
    
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(successLabel)
        
        successLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(378)
            $0.left.equalToSuperview().inset(74)
            $0.right.equalToSuperview().inset(60)
        }
        
    }
    
    // MARK: - Actions
    
    // MARK: - Functions
    

    
}
