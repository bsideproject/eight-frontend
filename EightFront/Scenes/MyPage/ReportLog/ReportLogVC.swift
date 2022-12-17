//
//  ReportLogVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import UIKit



class ReportLogVC: UIViewController {
    
    // MARK: - Properties
    private var viewModel = ReportLogViewModel()
    
    
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "의류수거함 수정 및 등록"
    }
    
    private let reportCategoryView = ReportCategoryView()
    
    private let reportTableView = UITableView().then {
        $0.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.identifier)
    }
    
    private let contentEmptyView = CommonContentEmptyView().then {
        $0.titleLabel.text = "아직 제보가 없어요"
    }
    
    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeUI()
        bind()
        
        viewModel.requestReportList()
    }
    
    // MARK: - makeUI
    private func makeUI() {
        view.backgroundColor = .white
                
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(47)
        }
        
        view.addSubview(reportCategoryView)
        reportCategoryView.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom).offset(19)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(29)
        }
        
        view.addSubview(reportTableView)
        reportTableView.snp.makeConstraints {
            $0.top.equalTo(reportCategoryView.snp.bottom).offset(52)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(contentEmptyView)
        contentEmptyView.snp.makeConstraints { 
            $0.center.equalToSuperview()
            $0.width.equalTo(174)
            $0.height.equalTo(143)
        }
    }
    
    // MARK: - bind
    private func bind() {
        commonNavigationView.backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &viewModel.bag)
        
        viewModel.$reportList
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] in
                self?.contentEmptyView.isHidden = $0.isEmpty ? false : true
                self?.reportTableView.isHidden = $0.isEmpty ? true : false
                self?.reportTableView.reloadData()
            }.store(in: &viewModel.bag)
        
    }
    
    // MARK: - Configure
    
    private func configure() {
        reportTableView.delegate = self
        reportTableView.dataSource = self
    }
    
}

extension ReportLogVC: UITableViewDelegate {
    
}

extension ReportLogVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as? ReportTableViewCell else { return UITableViewCell() }
        cell.configure(report: viewModel.cellForRowAt(indexPath: indexPath))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
}
