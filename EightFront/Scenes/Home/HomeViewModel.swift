//
//  HomeViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/09/27.
//

import UIKit
import Combine
import Moya
import NMapsMap
import CombineMoya
import CoreLocation

//MARK: HomeViewModel
final class HomeViewModel {
    enum NaviType: String {
        case naver = "naver"
        case kakao = "kakao"
        case tmap = "tmap"
    }
    //MARK: - Properties
    var cancelBag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    private let clothesProvider = MoyaProvider<ClothesAPI>()
    @Published var addressString: String?
    weak var selectedMarker: NaverMapMarker? {
        willSet {
            selectedMarker?.isSelected = false
            newValue?.isSelected = true
        }
    }
    var isOpenBottomInfoView: Bool = false
    
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        LocationManager.shared.$currentAddress
            .compactMap { $0 }
            .sink { [weak self] in
                self?.addressString = $0
            }
            .store(in: &cancelBag)
        
        input.requestAddress
            .sink {
                LocationManager.shared.addressUpdate(location: $0) { [weak self] address in
                    self?.addressString = address
                }
            }
            .store(in: &cancelBag)
    }
}

//MARK: - I/O & Error
extension HomeViewModel {
    enum ErrorResult: Error {
        case notFoundAddress
    }
    
    struct Input {
        var requestAddress = CurrentValueSubject<CLLocation?, Never>.init(nil)
    }
    
    struct Output {
        
    }
}

//MARK: - Method
extension HomeViewModel {
    private func requestCoordinates() {
        clothesProvider.requestPublisher(.coordinates)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    LogUtil.d(error.localizedDescription)
                case .finished:
                    LogUtil.d("Successed")
                }
            } receiveValue: { response in
                guard let responseData = try? response.map(CoordinatesResponse.self).data else { return }
                LogUtil.d(responseData)
            }
            .store(in: &cancelBag)
    }
    
    func requestURL(targetLocation location: CLLocation?) -> URL? {
        guard let destinationLocation = location,
              let type = NaviType(rawValue: DataManager.shared.setting?.naviType ?? "") else { return nil }
        
        var destinationURL: URL? = nil
        var appstoreURL: URL? = nil
        
        let position = NMGLatLng(lat: destinationLocation.coordinate.latitude, lng: destinationLocation.coordinate.longitude)
        
        switch type {
        case .tmap:
            let urlString = "tmap://?rGoName=\("의류 수거함")&rGoX=\(position.lng)&rGoY=\(position.lat)"
            let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            destinationURL = URL(string: encodedStr ?? "")
            appstoreURL = URL(string: "itms-apps://itunes.apple.com/app/431589174")
        case .kakao:
            destinationURL = URL(string: "kakaomap://route?ep=\(position.lat),\(position.lng)&by=FOOT")
            appstoreURL = URL(string: "itms-apps://itunes.apple.com/app/304608425")
        case .naver:
            let urlString = "nmap://route/walk?dlat=\(position.lat)&dlng=\(position.lng)&dname=\("의류 수거함")&appname=com.front.eight.bside"
            
            let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            destinationURL = URL(string: encodedStr ?? "")
            appstoreURL = URL(string: "itms-apps://itunes.apple.com/app/311867728")
        }
        
        guard let _destinationURL = destinationURL, let _appstoreURL = appstoreURL else { return nil }
        
        return UIApplication.shared.canOpenURL(_destinationURL) ? _destinationURL : _appstoreURL
    }
}
