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
    }
    //MARK: - Properties
    var cancelBag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    private let clothesProvider = MoyaProvider<BoxesAPI>()
    var requestLocation: CLLocation?
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
        input.requestClothingBins
            .sink { [weak self] in
                self?.requestClothingBins(requestLocation: $0)
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
        var requestClothingBins = CurrentValueSubject<CLLocation?, Never>.init(nil)
    }
    
    struct Output {
        var requestClothingBins = CurrentValueSubject<CollectionBoxes?, Never>.init(nil)
    }
}

//MARK: - Method
extension HomeViewModel {
    private func requestClothingBins(requestLocation: CLLocation?) {
        guard let location = requestLocation else { return }
        clothesProvider.requestPublisher(.clothingBins(latitude: location.coordinate.latitude,
                                                       longitude: location.coordinate.longitude))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    LogUtil.d(error.localizedDescription)
                case .finished:
                    LogUtil.d("Successed")
                }
            } receiveValue: { [weak self] response in
                guard let responseData = try? response.map(ClothingResponse.self).data else { return }
                
                self?.output.requestClothingBins.send(responseData)
            }
            .store(in: &cancelBag)
    }
    
    func requestURL(targetLocation location: CLLocation?) -> URL? {
//        guard let destinationLocation = location,
//              let type = NaviType(rawValue: DataManager.shared.setting?.naviType ?? "") else { return nil }
        
        let naviType = UserDefaults.standard.object(forKey: "navigation") as? String
        
        guard let destinationLocation = location,
              let type = NaviType(rawValue: naviType ?? "") else { return nil }
        
        
        var destinationURL: URL? = nil
        var appstoreURL: URL? = nil
        
        let position = NMGLatLng(lat: destinationLocation.coordinate.latitude, lng: destinationLocation.coordinate.longitude)
        
        switch type {
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
