//
//  LocationManager.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/09/19.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    // MARK: - Properties
    
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    
    // MARK: - Init
    override init() {
        super.init()
        requestLocationAccess()
    }
    
    // MARK: - Functions
    // 위치 권한
    func requestLocationAccess() {
        if locationManager == nil {
            LogUtil.d("위치 권한 매니저")
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
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
    
    func getCoordinate(completion: @escaping (CLLocationDegrees, CLLocationDegrees) -> Void){
        
        guard let currentLocation = locationManager?.location else {
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
            self.locationManager?.requestWhenInUseAuthorization()
        default:
            LogUtil.d("LocationManager Default")
        }
    }
    
    // 실패 했을경우 받은 알림
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: 위치 정보를 가져오는데 실패했습니다.")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
    }
}
