//
//  FindAddressVC.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import Then
import SnapKit
import UIKit
import NMapsMap
//MARK: FindAddressVC
final class FindAddressVC: UIViewController {
    //MARK: - Properties
    var requestLocation: CLLocation?
    let viewModel = FindAddressViewModel()
    lazy var mapView = NMFMapView().then {
        $0.addCameraDelegate(delegate: self)
        $0.positionMode = .direction
        $0.minZoomLevel = 10.0
        $0.maxZoomLevel = 18.0
        $0.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
    }
    let markerImageView = UIImageView().then {
        $0.image = Images.Map.marker.image
    }
    private let currentLocationButton = UIButton().then {
        $0.layer.cornerRadius = 2
        $0.setImage(Images.currentLocation.image, for: .normal)
        $0.setImage(Images.currentLocation.image, for: .highlighted)
        $0.backgroundColor = .white
    }
    private let bottomAddressView = BottomAddressView()
    
    //MARK: - Life Cycle
    init(requestLocation: CLLocation? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.requestLocation = requestLocation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    //MARK: - Make UI
    func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        view.addSubview(markerImageView)
        view.addSubview(currentLocationButton)
        view.addSubview(bottomAddressView)
        
        bottomAddressView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
        mapView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomAddressView.snp.top)
        }
        markerImageView.snp.makeConstraints {
            $0.centerX.equalTo(mapView.snp.centerX)
            $0.centerY.equalTo(mapView.snp.centerY).offset(-30)
            $0.width.equalTo(24)
            $0.height.equalTo(30)
        }
        currentLocationButton.snp.makeConstraints {
            $0.bottom.equalTo(mapView.snp.bottom).offset(-12)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(44)
            $0.height.equalTo(46)
        }
    }
    
    //MARK: - Rx Binding..
    func bind() {
        viewModel.input
            .requestAddress
            .send(requestLocation)
        
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
        
        viewModel.$addressString
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.text, on: bottomAddressView.addressLabel)
            .store(in: &viewModel.cancelBag)
    }
}

extension FindAddressVC: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let location = CLLocation(latitude: mapView.latitude, longitude: mapView.longitude)
        
        viewModel.input.requestAddress.send(location)
    }
}
