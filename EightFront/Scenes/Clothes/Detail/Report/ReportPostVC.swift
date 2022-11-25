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

protocol ReportPostVCDelegate: AnyObject {
    func select(category: String)
}

//MARK: 게시물 신고하기 VC
final class ReportPostVC: UIViewController {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    weak var delegate: ReportPostVCDelegate?
    private let viewModel: ReportPostViewModel
    lazy var navigationView = CommonNavigationView().then {
        $0.titleLabel.text = viewModel.type == .report ? "신고하기" : "카테고리 선택"
    }
    private lazy var titleLabel = UILabel().then {
        $0.text = viewModel.type == .report ? "신고 사유" : "품목"
        $0.font = Fonts.Pretendard.semiBold.font(size: 16)
    }
    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        ReportPostCell.register($0)
    }
    private lazy var sumitButton = UIButton().then {
        $0.setTitle("신고하기")
        $0.isEnabled = false
        $0.setTitleColor(.white)
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 8.0
        $0.isHidden = viewModel.type == .category
    }
    
    //MARK: - Life Cycle
    init(type: ReportPostViewModel.SelectType) {
        self.viewModel = ReportPostViewModel(type: type)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        viewModel
            .output
            .requestCategroies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.viewModel.datas = categories
                self?.tableView.reloadData()
            }
            .store(in: &viewModel.bag)
    }
}

extension ReportPostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withType: ReportPostCell.self, for: indexPath)
        
        cell.configure(with: viewModel.datas[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if viewModel.type == .report {
            cell.isSelected = true
            sumitButton.isEnabled = true
            sumitButton.setTitleColor(Colors.point.color)
            sumitButton.backgroundColor = Colors.gray002.color
        } else {
            delegate?.select(category: viewModel.datas[indexPath.row])
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        cell.isSelected = false
    }
}
