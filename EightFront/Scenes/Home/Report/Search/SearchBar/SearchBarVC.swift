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
    let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "주소 검색"
    }
    lazy var introduceLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = Fonts.Pretendard.regular.font(size: 20)
        let attrString = NSMutableAttributedString(string: "변경하실 의류 수거함\n주소를 입력해주세요")
        $0.attributedText = attrString.apply(word: "의류 수거함",
                                             attrs: [.font: Fonts.Pretendard.semiBold.font(size: 20)])
    }
    let addressTitleLabel = UILabel().then {
        $0.text = "의류 수거함 주소"
        $0.font = Fonts.Templates.subheader3.font
    }
    let searchImageView = UIImageView().then {
        $0.image = Images.Report.search.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Colors.gray005.color
    }
    let searchBarView = CommonTextFieldView(titleWidth: 5).then {
        $0.contentTextField.clearButtonMode = .always
        $0.contentTextField.attributedPlaceholder = NSAttributedString(string: "수거함 위치를 검색해보세요.", attributes: [
            .foregroundColor: Colors.gray006.color,
            .font: Fonts.Templates.caption1.font
        ])
    }
    lazy var searchResultTableView = UITableView().then {
        $0.delegate = self
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.keyboardDismissMode = .onDrag
        $0.alwaysBounceVertical = false
        $0.alwaysBounceHorizontal = false
        $0.showsHorizontalScrollIndicator = false
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
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(introduceLabel)
        view.addSubview(addressTitleLabel)
        view.addSubview(searchBarView)
        view.addSubview(searchImageView)
        view.addSubview(searchResultTableView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(47)
        }
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
        }
        addressTitleLabel.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(25)
            $0.left.right.equalToSuperview().inset(16)
        }
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(addressTitleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
        searchImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.left.equalTo(searchBarView.snp.left).offset(10)
            $0.centerY.equalTo(searchBarView)
        }
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(8)
            $0.left.bottom.right.equalToSuperview()
        }
        
        performDataSource()
    }
    
    //MARK: - Rx Binding..
    private func bind() {
        searchBarView
            .contentTextField
            .returnPublisher
            .receive(on: DispatchQueue.global())
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.viewModel.input.requestPOI.send(self?.searchBarView.contentTextField.text)
            }
            .store(in: &viewModel.bag)
        searchBarView
            .contentTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .map { $0.isEmpty }
            .map { $0 ? Colors.gray005.color : Colors.gray002.color }
            .assign(to: \.tintColor, on: searchImageView)
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
        
        navigationView.backButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
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
        dataSource = UITableViewDiffableDataSource<Section, ResponsePOI>(tableView: searchResultTableView, cellProvider: { [weak self] tableView, indexPath, poi in
            let cell = tableView.dequeueReusableCell(withType: SearchResultCell.self, for: indexPath)
            
            let attrString = NSMutableAttributedString(string: poi.name ?? "")
            cell.titleLabel.attributedText = attrString.apply(word: self?.searchBarView.contentTextField.text ?? "",
                                                              attrs: [.foregroundColor: Colors.gray001.color])
            cell.subTitleLabel.text = poi.address
            
            if let departure = LocationManager.shared.currentLocation,
               let targetCoordinate = poi.coordinate {
                let destination = CLLocation(latitude: targetCoordinate.latitude, longitude: targetCoordinate.longitude)
                
                let distance = departure.distance(from: destination)
                let distanceString = distance < 1000 ? "\(Int(distance))m" : "\(Double(Int(distance * 100 / 1000)) / 10)km"
                
                cell.distanceLabel.text = distanceString
            }
            
            return cell
        })
    }
    
    private func performDataSnapShot(pois: [ResponsePOI]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ResponsePOI>()
        snapshot.appendSections([.search])
        
        snapshot.appendItems(pois)
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.fetch(coordinate: viewModel.pois[indexPath.row].coordinate)
        navigationController?.popViewController(animated: true)
    }
}
