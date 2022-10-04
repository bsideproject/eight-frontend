//
//  HomeVC.swift
//  EightFront
//
//  Created by wargi on 2022/09/15.
//

import UIKit
import Combine
import NMapsMap
import SnapKit
import Then
import TMapSDK
import CombineCocoa

final class HomeVC: UIViewController {
    //MARK: - Properties
    private let viewModel = HomeViewModel()
    private let statusView = UIView().then {
        $0.backgroundColor = Colors.main.color
    }
    private lazy var headerView = HomeHeaderView().then {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchButtonTapped))
        $0.searchView.addGestureRecognizer(tapGesture)
    }
    private let reportButton = UIButton().then {
        $0.layer.cornerRadius = 27
        $0.setImage(Images.Home.add.image, for: .normal)
        $0.setImage(Images.Home.add.image, for: .highlighted)
        $0.backgroundColor = Colors.main.color
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: MapView
    var markers = [NaverMapMarker]()
    weak var mapDelegate: MainMapViewDelegate?
    var selectedMarker: NaverMapMarker? = nil {
        willSet {
            selectedMarker?.isSelected = false
            newValue?.isSelected = true
        }
    }
    private let mapView = NMFMapView().then {
        $0.positionMode = .direction
        $0.minZoomLevel = 10.0
        $0.maxZoomLevel = 18.0
        $0.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
    }
    private let currentLocationButton = UIButton().then {
        $0.layer.cornerRadius = 2
        $0.setImage(Images.currentLocation.image, for: .normal)
        $0.setImage(Images.currentLocation.image, for: .highlighted)
        $0.backgroundColor = .white
    }
    
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
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        view.addSubview(statusView)
        view.addSubview(headerView)
        view.addSubview(mapView)
        view.addSubview(currentLocationButton)
        view.addSubview(reportButton)

        statusView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(view.safeAreaLayoutGuide)
        }
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(101)
        }
        mapView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        currentLocationButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(44)
            $0.height.equalTo(46)
        }
        reportButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-18)
            $0.left.equalToSuperview().offset(15)
            $0.width.equalTo(54)
            $0.height.equalTo(54)
        }
        
        view.addShadow(views: [currentLocationButton, reportButton])
        
        showMarker(box: nil)
    }
    
    //MARK: - Binding..
    private func bind() {
        currentLocationButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { LocationManager.shared.currentLocation?.coordinate }
            .sink { [weak self] in
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: $0.latitude,
                                                                       lng: $0.longitude), zoomTo: 15.0)
                cameraUpdate.animation = .easeIn
                LocationManager.shared.currentAddress = nil
                self?.mapView.moveCamera(cameraUpdate)
            }
            .store(in: &viewModel.cancelBag)
        // Home -> Report
        reportButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.reportButtonTapped()
            }
            .store(in: &viewModel.cancelBag)
        // Home -> List
        headerView.searchView.listButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.listButtonTapped()
            }
            .store(in: &viewModel.cancelBag)
        
        viewModel.$addressString
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.text, on: headerView.addressView.addressLabel)
            .store(in: &viewModel.cancelBag)
    }
    
    @objc
    func searchButtonTapped() {
        let searchVC = HomeSearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func listButtonTapped() {
        let listVC = HomeListVC()
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    private func reportButtonTapped() {
        let reportVC = FindAddressVC(requestLocation: LocationManager.shared.currentLocation)
        reportVC.modalPresentationStyle = .fullScreen
        present(reportVC, animated: true)
    }
    
    //MARK: - Map Methods
    func moveMap(location: CLLocation?) {
        guard let coordinate = location?.coordinate else { return }
        let latLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        
        mapView.moveCamera(NMFCameraUpdate(scrollTo: latLng))
    }
    
    func showMarker(box: CollectionBox?) {
        resetInfoWindows()
        
        let position = NMGLatLng(lat: mapView.latitude, lng: mapView.longitude)
        let marker = NaverMapMarker(type: .none)
        
        marker.position = position
        marker.mapView = mapView
        marker.userInfo = ["box": box]
        
        marker.touchHandler = { [weak self] overlay -> Bool in
            self?.selectedMarker = marker
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position)
            cameraUpdate.animation = .easeIn
            self?.mapView.moveCamera(cameraUpdate)
            self?.mapDelegate?.marker(didTapMarker: position, info: box)
            
            return true
        }
        
        
        markers.append(marker)
    }
    
    func resetInfoWindows() {
        markers.forEach {
            $0.mapView = nil
        }

        markers = []
    }
}

protocol MainMapViewDelegate: AnyObject {
    func marker(didTapMarker: NMGLatLng, info: CollectionBox?)
}
