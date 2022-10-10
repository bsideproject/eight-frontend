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
import CombineCocoa

protocol MainMapViewDelegate: AnyObject {
    func marker(didTapMarker: NMGLatLng, info: CollectionBox?)
}

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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: MapView
    private var markers = [NaverMapMarker]()
    private weak var mapDelegate: MainMapViewDelegate?
    private lazy var mapView = NMFMapView().then {
        $0.touchDelegate = self
        $0.addCameraDelegate(delegate: self)
        $0.positionMode = .direction
        $0.minZoomLevel = 10.0
        $0.maxZoomLevel = 18.0
        $0.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
    }
    private let currentLocationButton = UIButton().then {
        $0.layer.cornerRadius = 22
        $0.setImage(Images.currentLocation.image, for: .normal)
        $0.setImage(Images.currentLocation.image, for: .highlighted)
        $0.backgroundColor = .white
    }
    private let reportButton = UIButton().then {
        $0.layer.cornerRadius = 27
        $0.setImage(Images.Home.add.image, for: .normal)
        $0.setImage(Images.Home.add.image, for: .highlighted)
        $0.backgroundColor = Colors.main.color
    }
    private lazy var boxInfoView = BoxCollectionView().then {
        $0.layer.cornerRadius = 8
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
        tabBarController?.view.addSubview(boxInfoView)
        
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-18)
            $0.right.equalToSuperview().offset(-16)
            $0.size.equalTo(44)
        }
        reportButton.snp.makeConstraints {
            $0.bottom.equalTo(currentLocationButton.snp.top).offset(-14)
            $0.right.equalTo(currentLocationButton.snp.right)
            $0.size.equalTo(50)
        }
        boxInfoView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(224)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(224)
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
        boxInfoView.fixButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let selectedMarker = self?.viewModel.selectedMarker else { return }
                
                let targetLocation = CLLocation(latitude: selectedMarker.position.lat,
                                                longitude: selectedMarker.position.lng)
                let reportVC = ReportVC(isDelete: false,
                                        location: targetLocation)
                
                let navi = CommonNavigationViewController(rootViewController: reportVC)
                navi.modalPresentationStyle = .fullScreen
                self?.present(navi, animated: true)
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
        let searchVC = SearchBarVC()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func listButtonTapped() {
        let listVC = HomeListVC()
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    private func reportButtonTapped() {
//        let reportVC = ReportVC(isDelete: false)
//        let navi = CommonNavigationViewController(rootViewController: reportVC)
//        navi.modalPresentationStyle = .fullScreen
//        present(navi, animated: true)
    }
    
    //MARK: - Map Methods
    private func moveMap(location: CLLocation?) {
        guard let coordinate = location?.coordinate else { return }
        let latLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        
        mapView.moveCamera(NMFCameraUpdate(scrollTo: latLng))
    }
    
    private func showMarker(box: CollectionBox?) {
        resetInfoWindows()
        
        let position = NMGLatLng(lat: mapView.latitude, lng: mapView.longitude)
        let marker = NaverMapMarker(type: .none)
        
        marker.position = position
        marker.mapView = mapView
        marker.userInfo = ["box": box]
        
        marker.touchHandler = { [weak self] overlay -> Bool in
            self?.viewModel.selectedMarker = marker
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position, zoomTo: 16.0)
            cameraUpdate.animation = .easeIn
            self?.mapView.moveCamera(cameraUpdate)
            self?.mapDelegate?.marker(didTapMarker: position, info: box)
            self?.updateBottomInfoView(isOpen: true)
            
            return true
        }
        
        markers.append(marker)
    }
    
    private func updateBottomInfoView(isOpen: Bool) {
        guard isOpen != viewModel.isOpenBottomInfoView else { return }
        viewModel.isOpenBottomInfoView.toggle()
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
        let viewBottom: CGFloat = isOpen ? 0 : 224
        
        boxInfoView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(viewBottom)
        }
        
        currentLocationButton.snp.remakeConstraints {
            $0.bottom.equalTo(isOpen ? boxInfoView.snp.top : view.safeAreaLayoutGuide).offset(-18)
            $0.right.equalToSuperview().offset(-16)
            $0.size.equalTo(44)
        }
        
        animator.addAnimations { [weak self] in
            self?.view.layoutIfNeeded()
            self?.tabBarController?.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
    private func resetInfoWindows() {
        markers.forEach {
            $0.mapView = nil
        }
        
        markers = []
    }
    
    private func deselection() {
        viewModel.selectedMarker?.isSelected = false
        viewModel.selectedMarker = nil
    }
}

extension HomeVC: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        guard animated && reason == -1 else { return }
        
    }
}

extension HomeVC: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        deselection()
        updateBottomInfoView(isOpen: false)
    }
}
