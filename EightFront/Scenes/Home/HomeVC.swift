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
    private let mapView = NMFMapView().then {
        $0.positionMode = .direction
        $0.minZoomLevel = 8.0
        $0.maxZoomLevel = 18.0
        $0.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
    }
    private let currentLocationButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = false
        $0.setImage(UIImage(systemName: "location"), for: .normal)
        $0.setImage(UIImage(systemName: "location"), for: .highlighted)
        $0.backgroundColor = .white
    }
    private var circle: NMFCircleOverlay?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(currentLocationButton)

        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        currentLocationButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(40)
        }
        
        view.addShadow(views: [currentLocationButton])
    }
    
    //MARK: - Binding..
    private func bind() {
        currentLocationButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { LocationManager.shared.currentLocation }
            .sink { [weak self] in
                //TODO: 추후에 서버 API 내려오면 makeRadiusCircle() 메서드 위치 변경 예정
                self?.makeRadiusCircle()
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: $0.latitude,
                                                                       lng: $0.longitude), zoomTo: 15.0)
                cameraUpdate.animation = .easeIn
                self?.mapView.moveCamera(cameraUpdate)
            }
            .store(in: &viewModel.cancelBag)
    }
    
    //TODO: 추후에 개발 API 내려오면 검색 위치 parameter(location)로 넘겨서 범위 재정립
    private func makeRadiusCircle(location: CLLocation? = nil) {
        guard let currentLocation = LocationManager.shared.currentLocation,
              let radius = DataManager.shared.setting?.radius else { return }
        
        let center = NMGLatLng(from: currentLocation)
        let newCircle = NMFCircleOverlay(center, radius: radius, fill: .clear)
        newCircle.outlineColor = .systemGreen
        newCircle.outlineWidth = 1
        
        circle?.mapView = nil
        circle = newCircle
        circle?.mapView = mapView
    }
}
