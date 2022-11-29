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
    weak var delegate: ReportPostVCDelegate?
    private let viewModel: ReportPostViewModel
    private var snapshot: ReportPostSnapshot!
    private var dataSource: ReportPostDataSource!
    private let navigationView = CommonNavigationView()
    private let titleLabel = UILabel().then {
        $0.font = Fonts.Pretendard.semiBold.font(size: 16)
    }
    private lazy var tableView = UITableView().then { [weak self] in
        $0.delegate = self
        $0.separatorStyle = .none
        $0.isMultipleTouchEnabled = false
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
        
        applyDataSource()
    }
    
    //MARK: - Binding..
    private func bind() {
        navigationView.backButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
        
        viewModel.$type
            .map { $0 == .report ? "신고하기" : "카테고리 선택" }
            .assign(to: \.text, on: navigationView.titleLabel)
            .store(in: &viewModel.bag)
        
        viewModel.$type
            .map { $0 == .report ? "신고 사유" : "품목" }
            .assign(to: \.text, on: titleLabel)
            .store(in: &viewModel.bag)
        
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
            .sink { [weak self] in
                self?.applyDataSnapShot(with: $0)
            }
            .store(in: &viewModel.bag)
    }
}

extension ReportPostVC: UITableViewDelegate {
    typealias ReportPostSnapshot = NSDiffableDataSourceSnapshot<DiffableSection, String>
    typealias ReportPostDataSource = UITableViewDiffableDataSource<DiffableSection, String>
    
    private func applyDataSource() {
        dataSource = ReportPostDataSource(tableView: tableView,
                                          cellProvider: { tableView, indexPath, data in
            let cell = tableView.dequeueReusableCell(withType: ReportPostCell.self, for: indexPath)
            
            cell.configure(with: data)
            
            return cell
        })
    }
    
    private func applyDataSnapShot(with datas: [String]) {
        snapshot = ReportPostSnapshot()
        snapshot.appendSections([.main])
        
        snapshot.appendItems(datas)
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.type == .report {
            sumitButton.isEnabled = true
            sumitButton.setTitleColor(Colors.point.color)
            sumitButton.backgroundColor = Colors.gray002.color
        } else {
            guard let category = dataSource.itemIdentifier(for: indexPath) else { return }
            delegate?.select(category: category)
            navigationController?.popViewController(animated: true)
        }
    }
}
