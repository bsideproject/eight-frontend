//
//  TermsVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/13.
//

import UIKit

import SnapKit

class TermsVC: UIViewController {
    
    // MARK: - properties
    
    let viewModel = TermsViewModel()
    
    let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "회원가입"
    }
    let titleLabel = UILabel().then {
        $0.text = "약관동의"
        $0.font = Fonts.Templates.title.font
        $0.textColor = Colors.gray001.color
    }
    let subTitleLabel = UILabel().then {
        $0.text = "필수항목 및 선택항목 약관에 동의해 주세요."
        $0.font = Fonts.Templates.body2.font
        $0.textColor = Colors.gray001.color
    }
    let nextButton = UIButton().then { 
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor.white, for: .disabled)
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 4
        $0.isEnabled = false
    }
    
    lazy var agreeTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(TermsTableViewCell.self, forCellReuseIdentifier: TermsTableViewCell.identifier)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        
    }
    
    // MARK: - MakeUI
    
    func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(nextButton)
        view.addSubview(agreeTableView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.equalToSuperview().inset(16)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(156)
            $0.leading.equalToSuperview().inset(16)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(44)
            $0.height.equalTo(58)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        agreeTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(233)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
    }
}

// MARK: - UITableViewDelegate

extension TermsVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDelegate

extension TermsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsTableViewCell.identifier, for: indexPath) as? TermsTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    
}
