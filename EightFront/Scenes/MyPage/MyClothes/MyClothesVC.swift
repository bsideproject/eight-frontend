//
//  MyClothesVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import UIKit
import Combine

class MyClothesVC: UIViewController {
    
    let viewModel = MyClothesViewModel()
    var bag = Set<AnyCancellable>()
    
    // MARK: - Properties
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "평가 중인 내 중고 의류"
    }
    
    private let searchView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.gray006.color.cgColor
        $0.layer.cornerRadius = 4
    }
    
    private let searchIcon = UIImageView().then {
        let image = Images.Home.search.image
        $0.image = image
    }
    
    private let searchTextField = UITextField().then {
        $0.placeholder = "수거함 위치를 검색해보세요."
        $0.font = Fonts.Templates.caption1.font
    }
    
    private let clothesTableView = UITableView().then {
        $0.register(MyClothesTableViewCell.self, forCellReuseIdentifier: MyClothesTableViewCell.identifier)
    }

    // MARK: - Lift Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        configure()
        bind()
        
        viewModel.requestMyClothes()
    }
    
    // MARK: - configure
    private func configure() {
        clothesTableView.delegate = self
        clothesTableView.dataSource = self
    }
    
    // MARK: - makeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(47)
        }
        
        view.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.top.equalTo(commonNavigationView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
            
            searchView.addSubview(searchIcon)
            searchIcon.snp.makeConstraints {
                $0.size.equalTo(20)
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().inset(10)
            }
            
            searchView.addSubview(searchTextField)
            searchTextField.snp.makeConstraints {
                $0.left.equalTo(searchIcon.snp.right).offset(7)
                $0.height.equalTo(18)
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().offset(7)
            }
        }
        
        view.addSubview(clothesTableView)
        clothesTableView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(8)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private func bind() {
        commonNavigationView.backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &bag)
        
        viewModel.$clothesList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.clothesTableView.reloadData()
            }.store(in: &viewModel.bag)
        
    }
    
    // MARK: - Configure
    
    // MARK: - Actions
    
    // MARK: - Functions
}

extension MyClothesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = viewModel.didSelectRowAt(indexPath: indexPath) {
            let detailVC = DetailPostVC(id: id)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension MyClothesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyClothesTableViewCell.identifier,
                                                       for: indexPath) as? MyClothesTableViewCell else { return UITableViewCell()}
        cell.configure(myCloth: viewModel.indexPath(indexPath: indexPath))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
