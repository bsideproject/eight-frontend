//
//  SearchMapVC.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import Then
import SnapKit
import UIKit
import NMapsMap

protocol SearchMapDelegate: AnyObject {
    func fetch(location: CLLocation?)
}

//MARK: FindAddressVC
final class SearchMapVC: UIViewController {
    //MARK: - Properties
    weak var delegate: SearchMapDelegate?
    private let viewModel = SearchMapViewModel()
    let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "위치 설정"
    }
    private lazy var mapView = NMFMapView().then {
        $0.addCameraDelegate(delegate: self)
        $0.positionMode = .direction
        $0.minZoomLevel = 10.0
        $0.maxZoomLevel = 18.0
        $0.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
    }
    private let markerImageView = UIImageView().then {
        $0.image = Images.Map.markerSelect.image
    }
    private let currentLocationButton = UIButton().then {
        $0.layer.cornerRadius = 22
        $0.setImage(Images.currentLocation.image, for: .normal)
        $0.setImage(Images.currentLocation.image, for: .highlighted)
        $0.backgroundColor = .white
    }
    private lazy var bottomAddressView = BottomAddressView().then {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressViewTapped))
        $0.addressLabel.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Life Cycle
    init(requestLocation: CLLocation? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.requestLocation = requestLocation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        view.addSubview(navigationView)
        view.addSubview(mapView)
        view.addSubview(markerImageView)
        view.addSubview(currentLocationButton)
        view.addSubview(bottomAddressView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(47)
        }
        bottomAddressView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(236)
        }
        mapView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomAddressView.snp.top)
        }
        markerImageView.snp.makeConstraints {
            $0.centerX.equalTo(mapView.snp.centerX)
            $0.centerY.equalTo(mapView.snp.centerY).offset(-16)
            $0.width.equalTo(26)
            $0.height.equalTo(32)
        }
        currentLocationButton.snp.makeConstraints {
            $0.bottom.equalTo(mapView.snp.bottom).offset(-37)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
    }
    
    //MARK: - Rx Binding..
    private func bind() {
        currentLocationButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .map { LocationManager.shared.currentLocation }
            .sink { [weak self] in
                self?.moveMap(location: $0)
            }
            .store(in: &viewModel.bag)
        
        viewModel.$addressString
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.text, on: bottomAddressView.addressLabel)
            .store(in: &viewModel.bag)
        
        navigationView.backButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
        
        bottomAddressView.submitButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.delegate?.fetch(location: self?.viewModel.requestLocation)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
        
        moveMap(location: viewModel.requestLocation, zoomTo: 16, isAnimate: false)
    }
    
    @objc
    private func addressViewTapped() {
        viewModel.isMove = false
        let searchBarVC = SearchBarVC()
        searchBarVC.delegate = self
        navigationController?.pushViewController(searchBarVC, animated: true)
    }
    
    private func moveMap(location: CLLocation?, zoomTo: Double = .zero, isAnimate: Bool = true) {
        guard let location else { return }
        LogUtil.d(location.coordinate)
        
        let latLng = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        let cameraUpdate = zoomTo == .zero ? NMFCameraUpdate(scrollTo: latLng) : NMFCameraUpdate(scrollTo: latLng, zoomTo: zoomTo)
        
        cameraUpdate.animation = isAnimate ? .easeIn : .none
        mapView.moveCamera(cameraUpdate)
    }
}

extension SearchMapVC: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        guard reason == -1 else { return }
        viewModel.isMove = true
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        guard viewModel.isMove else { return }
        
        let targetLocation = CLLocation(latitude: mapView.latitude, longitude: mapView.longitude)
        viewModel.requestLocation = targetLocation
    }
}

extension SearchMapVC: SearchBarDelegate {
    func fetch(coordinate: CLLocationCoordinate2D?) {
        guard let coordinate else { return }
        
        let targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        viewModel.requestLocation = targetLocation
        
        moveMap(location: targetLocation, zoomTo: 16.0, isAnimate: false)
    }
}
