//
//  SearchBarVC.swift
//  EightFront
//
//  Created by wargi on 2022/10/07.
//

import Then
import SnapKit
import UIKit
import Combine

//MARK: SearchBarVC
final class SearchBarVC: UIViewController {
    //MARK: - Properties
    lazy var searchBar = UISearchBar().then {
        $0.delegate = self
        self.navigationItem.titleView = $0
    }
    lazy var searchResultTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Images.Navigation.back.image,
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(backButtonTouched))
        
        
        view.addSubview(searchBar)
        view.addSubview(searchResultTableView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(42)
        }
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Rx Binding..
    private func bind() {
        
    }
    
    @objc
    private func backButtonTouched() {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchBarVC: UISearchBarDelegate {
    
}

extension SearchBarVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
