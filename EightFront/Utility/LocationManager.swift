//
//  LocationManager.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/09/19.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject {
    
    // MARK: - Properties
    
    static let shared = LocationManager()
    let utils = Common()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    
    // MARK: - Init
    private override init() {
        super.init()
        requestLocationAccess()
    }
    
    // MARK: - Functions
    // 위치 권한
    func requestLocationAccess() {
        
        if locationManager == nil {
            LogUtil.d("위치 권한 매니저")
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestWhenInUseAuthorization()
        } else {
            LogUtil.e("위치 권한 매니저 오류")
        }
    }
    
    // 위치 추적 시작
    func startUpdating() {
        self.locationManager?.startUpdatingLocation()
        LogUtil.d("위치 추적 시작")
    }
    
    // 위치 추적 종료
    func stopUpdating() {
        if locationManager != nil {
            self.locationManager?.stopUpdatingLocation()
            LogUtil.d("위치 추적 종료")
        }
    }
    
    func coordinate(completion: @escaping (CLLocationDegrees, CLLocationDegrees) -> Void){
        
        guard let currentLocation = locationManager?.location else {
            LogUtil.d("locationManaer.location 옵셔널 오류")
            return
        }
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        
        completion(latitude, longitude)
        
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            LogUtil.d("GPS 권한 설정됨")
            self.locationManager?.startUpdatingLocation()
        case .restricted, .notDetermined:
            LogUtil.d("GPS 권한 설정되지 않음")
            self.locationManager?.requestWhenInUseAuthorization()
        case .denied:
            LogUtil.d("GPS 권한 요청 거부됨")
            
            // Todo: 지연 시간으로 alert를 띄우는 것 말고 좋은 방법이 없을지
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let alert = UIAlertController(title: "", message: "앱을 원활히 위해 위치 권한을 '허용'하러 갑니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    
                    // 설정 화면으로 이동
                    self.utils.goSettings()
                    
                    // 앱 종료
                    self.utils.appExit()
                }
                
                alert.addAction(action)
                
                // 최상단 VC 찾기
                guard let firstViewController = UIApplication.shared.keyWindow?.rootViewController else {
                    return
                }
                
                // Alert 띄움
                firstViewController.present(alert, animated: true)
            }
            
        default:
            LogUtil.d("LocationManager Default")
        }
    }
    
    // 실패 했을경우 받은 알림
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LogUtil.e("위치 정보 가져오는데 실패")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
    }
}
