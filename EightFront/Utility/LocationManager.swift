//
//  LocationManager.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/09/19.
//

import UIKit
import CoreLocation
import TMapSDK

final class LocationManager: NSObject {
    // MARK: - Properties
    static let shared = LocationManager()
    private var locationManager: CLLocationManager?
    @Published var currentAddress: String?
    var currentLocation: CLLocation? {
        didSet {
            if currentAddress == nil && currentLocation != nil {
                addressUpdate(location: currentLocation) { [weak self] address in
                    self?.currentAddress = address
                }
            }
        }
    }
    
    // MARK: - Initializer
    private override init() {
        super.init()
        requestLocationAccess()
        TMapApi.setSKTMapAuthenticationWithDelegate(self, apiKey: "219c2c34-cdd2-45d3-867b-e08c2ea97810")
    }
    
    // MARK: - Functions
    // 위치 권한
    private func requestLocationAccess() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    // 위치 추적 시작
    func startUpdating() {
        LogUtil.d("위치 추적 시작")
        locationManager?.startUpdatingLocation()
    }
    
    // 위치 추적 종료
    func stopUpdating() {
        LogUtil.d("위치 추적 종료")
        locationManager?.stopUpdatingLocation()
    }
    
    func coordinate(completion: @escaping (CLLocationDegrees, CLLocationDegrees) -> Void) {
        guard let currentLocation = locationManager?.location else {
            LogUtil.d("locationManaer.location 옵셔널 오류")
            return
        }
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        
        completion(latitude, longitude)
    }
    
    private func requestLocationAlert() {
        guard let visibleVC = UIApplication.shared.keyWindow?.visibleViewController else { return }
        
        let alert = UIAlertController(title: "위치정보를 불러올 수 없습니다.",
                                      message: "위치정보를 사용해 주변 '의류수거함'의 정보를 불러오기 때문에 위치정보 권한이 필요합니다. 설정으로 이동하여 위치 정보 접근을 허용해 주세요.",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        
        let openAction = UIAlertAction(title: "설정으로 이동",
                                       style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url,
                                          options: [:],
                                          completionHandler: nil)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(openAction)
        
        visibleVC.present(alert, animated: true, completion: nil)
    }
    
    func addressUpdate(location: CLLocation?, completion: @escaping (String?) -> ()) {
        guard let targetPoint = location?.coordinate else { return }
        
        let pathData = TMapPathData()
                
        pathData.reverseGeocoding(targetPoint, addressType: "A10") { result, error in
            if let result = result {
                LogUtil.d(result)
                
                if let city = result["city_do"] as? String,
                   let gu = result["gu_gun"] as? String,
                   let roadName = result["roadName"] as? String,
                   let buildingNumber = result["buildingIndex"] as? String {
                    completion("\(city) \(gu) \(roadName) \(buildingNumber)")
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            LogUtil.d("GPS 권한 설정됨")
            self.locationManager?.startUpdatingLocation()
        case .notDetermined:
            LogUtil.d("GPS 권한 설정되지 않음")
            self.locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            LogUtil.d("GPS 권한 요청 거부됨")
            requestLocationAlert()
        default:
            break
        }
    }
    
    // 실패 했을경우 받은 알림
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard (error as NSError).code != CLError.locationUnknown.rawValue else {
            LogUtil.e("현재 위치 알 수 없음")
            return
        }
        
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            requestLocationAlert()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
}

extension LocationManager: TMapTapiDelegate {
    func SKTMapApikeySucceed() {
        LogUtil.d("APIKEY 인증 성공")
    }
}
