//
//  NoticeVC.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import Then
import SnapKit
import UIKit
//MARK: 알림 VC
final class NoticeVC: UIViewController {
    //MARK: - Properties
    
    let viewModel = NoticeViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "알림"
    }
    
    private let noticeTableView = UITableView().then {
        $0.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
        $0.separatorStyle = .none
    }
    
    private let contentEmptyView = CommonContentEmptyView().then {
        $0.titleLabel.text = "아직 알림이 오지 않았어요."
    }
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestNotice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeUI()
        bind()
    }
    
    //MARK: - Make UI
    
    private func configure() {
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        view.addSubview(noticeTableView)
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(23)
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(contentEmptyView)
        contentEmptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(174)
            $0.height.equalTo(143)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
//        viewModel.$notices
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] _ in
////                self?.noticeTableView.reloadData()
//            }.store(in: &viewModel.bag)
        
        viewModel.$notices
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] noties in
                
                self?.noticeTableView.isHidden = noties.isEmpty ? true : false
                self?.contentEmptyView.isHidden = noties.isEmpty ? false : true
                
            }.store(in: &viewModel.bag)
    }
}

// MARK: - UITableViewDelegate
extension NoticeVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension NoticeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier,
                                                       for: indexPath) as? NoticeTableViewCell else { return UITableViewCell() }
//        cell.configure(notice: viewModel.cellForRowAt(indexPath: indexPath))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38+22
    }
}


