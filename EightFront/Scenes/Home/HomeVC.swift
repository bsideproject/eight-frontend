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

final class HomeVC: UIViewController {
    //MARK: - Properties
    private let viewModel = HomeViewModel()
    private let statusView = UIView().then {
        $0.backgroundColor = Colors.gray002.color
    }
    private let headerView = HomeHeaderView()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: MapView
    private var markers = [NaverMapMarker]()
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
        $0.setImage(Images.currentLocation.image)
        $0.backgroundColor = .white
    }
    private let reportButton = UIButton().then {
        $0.layer.cornerRadius = 25
        $0.setImage(Images.Home.add.image)
        $0.backgroundColor = Colors.gray002.color
    }
    private lazy var boxInfoView = BoxCollectionView().then {
        $0.layer.cornerRadius = 8
    }
    private let refreshButton = RefreshView()
    
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
        view.addSubview(refreshButton)
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
        refreshButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(26)
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
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
    }
    
    //MARK: - Binding..
    private func bind() {
        currentLocationButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { LocationManager.shared.currentLocation }
            .sink { [weak self] in
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: $0.coordinate.latitude,
                                                                       lng: $0.coordinate.longitude), zoomTo: 15.0)
                cameraUpdate.animation = .easeIn
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
        
        boxInfoView.fixButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let box = self?.viewModel.selectedMarker?.markerView.boxInfo else { return }
                
                let reportVC = ReportVC(type: .update,
                                        box: box)
                
                self?.tabBarController?.navigationController?.pushViewController(reportVC, animated: true)
            }
            .store(in: &viewModel.cancelBag)
        
        boxInfoView.navigationButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let selectedMarker = self?.viewModel.selectedMarker else { return }
                
                let targetLocation = CLLocation(latitude: selectedMarker.position.lat,
                                                longitude: selectedMarker.position.lng)
                self?.requestDirection(location: targetLocation)
            }
            .store(in: &viewModel.cancelBag)
        
        headerView
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchButtonTapped()
            }
            .store(in: &viewModel.cancelBag)
                
        viewModel
            .output
            .requestClothingBins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] boxes in
                self?.showMarker(boxes: boxes?.boxes)
            }
            .store(in: &viewModel.cancelBag)
        
        refreshButton
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let lat = self?.mapView.latitude, let lng = self?.mapView.longitude else { return }
                let location = CLLocation(latitude: lat, longitude: lng)
                self?.viewModel.input.requestClothingBins.send(location)
            }
            .store(in: &viewModel.cancelBag)
        
        LocationManager.shared.$currentLocation
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] in
                guard self?.viewModel.requestLocation == nil else { return }
                
                self?.viewModel.requestLocation = $0
                self?.moveMap(location: $0)
                self?.viewModel.input.requestClothingBins.send($0)
            }
            .store(in: &viewModel.cancelBag)
    }
    
    @objc
    func searchButtonTapped() {
//        let homeSearchVC = HomeSearchVC()
//        tabBarController?.navigationController?.pushViewController(homeSearchVC, animated: true)
    }
    
    private func reportButtonTapped() {
        let reportVC = ReportVC(type: .new)
        self.tabBarController?.navigationController?.pushViewController(reportVC, animated: true)
    }
    
    //MARK: - Map Methods
    private func moveMap(location: CLLocation?) {
        guard let coordinate = location?.coordinate else { return }
        let latLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        
        mapView.moveCamera(NMFCameraUpdate(scrollTo: latLng, zoomTo: 17.0))
    }
    
    private func showMarker(boxes: [CollectionBox]?) {
        resetInfoWindows()
        
        guard let boxes else { return }
        
        for box in boxes {
            guard let lat = box.latitude, let lng = box.longitude else { continue }
            let position = NMGLatLng(lat: lat, lng: lng)
            let marker = NaverMapMarker(type: .none, with: box)
            
            marker.position = position
            marker.mapView = mapView
            marker.userInfo = ["box": box]
            
            marker.touchHandler = { [weak self] overlay -> Bool in
                self?.viewModel.selectedMarker = marker
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position, zoomTo: 17.0)
                cameraUpdate.animation = .easeIn
                self?.mapView.moveCamera(cameraUpdate)
                self?.markerTapped(location: position, info: box)
                self?.updateBottomInfoView(isOpen: true)
                
                return true
            }
            
            markers.append(marker)
        }
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
    
    func requestDirection(location: CLLocation?) {
        guard let location,
              let requestURL = viewModel.requestURL(targetLocation: location) else { return }
                
        UIApplication.shared.open(requestURL, options: [:], completionHandler: nil)
    }
    
    func markerTapped(location: NMGLatLng, info: CollectionBox?) {
        boxInfoView.titleLabel.text = info?.name
        boxInfoView.addressLabel.text = info?.address
        boxInfoView.detailAddressLabel.text = info?.detailedAddress
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

