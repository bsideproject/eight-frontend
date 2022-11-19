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
    
    private let commontNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "의류수거함 정보수정&신규등록 제보확인"
    }
    
    private let reportCategoryView = ReportCategoryView()
    
    private let reportTableView = UITableView().then {
        $0.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.identifier)
//        $0.separatorStyle = .none
    }
    
    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeUI()
    }
    
    // MARK: - makeUI
    private func makeUI() {
        view.backgroundColor = .white
                
        view.addSubview(commontNavigationView)
        commontNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(47)
        }
        
        view.addSubview(reportCategoryView)
        reportCategoryView.snp.makeConstraints {
            $0.top.equalTo(commontNavigationView.snp.bottom).offset(19)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(29)
        }
        
        view.addSubview(reportTableView)
        reportTableView.snp.makeConstraints {
            $0.top.equalTo(reportCategoryView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    // MARK: - Configure
    
    private func configure() {
        reportTableView.delegate = self
        reportTableView.dataSource = self
    }
    
    // MARK: - Actions
    
    // MARK: - Functions
    
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
}