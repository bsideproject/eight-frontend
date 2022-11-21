//
//  ReportPostVC.swift
//  EightFront
//
//  Created by wargi on 2022/11/06.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

//MARK: 게시물 신고하기 VC
final class ReportPostVC: UIViewController {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    private let viewModel = ReportPostViewModel()
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "신고하기"
    }
    private let titleLabel = UILabel().then {
        $0.text = "신고 사유"
        $0.font = Fonts.Pretendard.semiBold.font(size: 16)
    }
    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        ReportPostCell.register($0)
    }
    private let sumitButton = UIButton().then {
        $0.setTitle("신고하기")
        $0.isEnabled = false
        $0.setTitleColor(.white)
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 8.0
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(sumitButton)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(47)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(26)
        }
        sumitButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(58)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(sumitButton.snp.top).offset(-16)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        navigationView.backButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &bag)
        
        sumitButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let completedVC = ReportCompletedVC(type: .report)
                self?.navigationController?.pushViewController(completedVC, animated: true)
            }
            .store(in: &viewModel.bag)
    }
}

extension ReportPostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withType: ReportPostCell.self, for: indexPath)
        
        cell.configure(with: viewModel.reports[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        cell.isSelected = true
        sumitButton.isEnabled = true
        sumitButton.setTitleColor(Colors.point.color)
        sumitButton.backgroundColor = Colors.gray002.color
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        cell.isSelected = false
    }
}
