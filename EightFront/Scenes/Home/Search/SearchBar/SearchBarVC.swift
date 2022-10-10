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
import CoreLocation

protocol SearchBarDelegate: AnyObject {
    func fetch(coordinate: CLLocationCoordinate2D?)
}

//MARK: SearchBarVC
final class SearchBarVC: UIViewController {
    //MARK: - Properties
    enum Section {
        case search
    }
    weak var delegate: SearchBarDelegate?
    private let viewModel = SearchBarViewModel()
    lazy var searchBar = UISearchBar().then {
        self.navigationItem.titleView = $0
    }
    lazy var searchResultTableView = UITableView().then {
        $0.delegate = self
        $0.keyboardDismissMode = .onDrag
        SearchResultCell.register($0)
    }
    var dataSource: UITableViewDiffableDataSource<Section, ResponsePOI>?
    
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
        
        view.addSubview(searchResultTableView)
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        performDataSource()
    }
    
    //MARK: - Rx Binding..
    private func bind() {
        searchBar
            .textDidChangePublisher
            .receive(on: DispatchQueue.global())
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] in
                LogUtil.d($0)
                self?.viewModel.input.requestPOI.send($0)
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .resultPOIs
            .receive(on: DispatchQueue.main)
            .sink {
                if case let .failure(error) = $0 {
                    LogUtil.d(error.localizedDescription)
                }
            } receiveValue: { [weak self] in
                self?.performDataSnapShot(pois: $0)
            }
            .store(in: &viewModel.bag)
    }
    
    @objc
    private func backButtonTouched() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- DiffDataSource
extension SearchBarVC: UITableViewDelegate {
    private func performDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, ResponsePOI>(tableView: searchResultTableView, cellProvider: { tableView, indexPath, poi in
            let cell = tableView.dequeueReusableCell(withType: SearchResultCell.self, for: indexPath)
            
            cell.keywordLabel.text = poi.name
            
            return cell
        })
    }
    
    private func performDataSnapShot(pois: [ResponsePOI]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ResponsePOI>()
        snapshot.appendSections([.search])
        
        LogUtil.d(pois)
        snapshot.appendItems(pois)
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.fetch(coordinate: viewModel.pois[indexPath.row].coordinate)
        navigationController?.popViewController(animated: true)
    }
}
