//
//  HomeViewController.swift
//  EightFront
//
//  Created by wargi on 2022/09/15.
//

import UIKit
import NMapsMap
import SnapKit
import Then

final class HomeViewController: UIViewController {
    //MARK: - Properties
    let mapView = NMFMapView().then {
        $0.mapType = .navi
        $0.positionMode = .direction
        $0.minZoomLevel = 5.0
        $0.maxZoomLevel = 18.0
        $0.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
    
    //MARK: - Make UI
    func makeUI() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Binding..
    func bind() {
        
    }
}
