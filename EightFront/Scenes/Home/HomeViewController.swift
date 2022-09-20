//
//  HomeViewController.swift
//  EightFront
//
//  Created by wargi on 2022/09/15.
//

import UIKit
import Combine
import NMapsMap
import SnapKit
import Then

final class HomeViewController: UIViewController {
    //MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
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
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: $0.latitude,
                                                                       lng: $0.longitude), zoomTo: 15.0)
                cameraUpdate.animation = .easeIn
                self?.mapView.moveCamera(cameraUpdate)
            }
            .store(in: &cancellables)
    }
}
