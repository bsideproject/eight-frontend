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
        $0.separatorStyle = .none
    }
    
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        blockTableView.delegate = self
        blockTableView.dataSource = self
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
            $0.top.equalTo(commonNavigation.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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
        return 50
    }
}

extension BlockVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("눌렀다")
    }
}
