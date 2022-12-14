//
//  BlockVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/19.
//

import UIKit

class BlockVC: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = BlockTableViewModel()
    
    private let commonNavigation = CommonNavigationView().then {
        $0.titleLabel.text = "차단 목록"
    }
    
    private let blockTableView = UITableView().then {
        $0.register(BlockTableViewCell.self, forCellReuseIdentifier: BlockTableViewCell.identity)
    }
    
    private let contentEmptyView = CommonContentEmptyView().then {
        $0.titleLabel.text = "차단 목록이 없어요"
    }
    
    // MARK: - lifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestBlockList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bind()
        configure()
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigation)
        commonNavigation.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        view.addSubview(blockTableView)
        blockTableView.snp.makeConstraints {
            $0.top.equalTo(commonNavigation.snp.bottom).offset(13)
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
    
    private func bind() {
        commonNavigation.backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &viewModel.bag)
        
        viewModel.$blockList
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] in
                self?.contentEmptyView.isHidden = $0.isEmpty ? false : true
                self?.blockTableView.isHidden = $0.isEmpty ? true : false
                self?.blockTableView.reloadData()
            }.store(in: &viewModel.bag)
        
    }
    
    private func configure() {
        blockTableView.delegate = self
        blockTableView.dataSource = self
    }
}

extension BlockVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BlockTableViewCell.identity, for: indexPath) as? BlockTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
}

extension BlockVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.unBlockUser(indexPath: indexPath)
        tableView.reloadData()
    }
}
