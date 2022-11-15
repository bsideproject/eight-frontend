//
//  MyPageViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/05.
//

import Foundation
import UIKit

import Combine

final class MyPageViewModel {
    
    var bag = Set<AnyCancellable>()
    
    @Published var nickname = UserDefaults.standard.object(forKey: "nickName") as? String ?? "로그인을 해주세요."

    enum MyPageMenus: CaseIterable {
        case myClothes
        case navigationSetting
        case report
        case setting
        
        var image: String {
            switch self {
            case .myClothes:
                return "person"
            case .navigationSetting:
                return "house"
            case .report:
                return "flame"
            case .setting:
                return "gear"
            }
        }
        
        var title: String {
            switch self {
            case .myClothes:
                return "평가 중인 내 중고 의류"
            case .navigationSetting:
                return "네비게이션 앱 설정"
            case .report:
                return "신규수거함 제보 문의함"
            case .setting:
                return "설정"
            }
        }
        
        var destination: UIViewController {
            switch self {
            case .myClothes:
                return MyClothesVC()
            case .navigationSetting:
                return NavigationSettingVC()
            case .report:
                return ReportLogVC()
            case .setting:
                let settingVC = SettingVC()
                return settingVC
            }
        }
        
        var backgroundColor: CGColor {
            switch self {
            case .myClothes:
                return UIColor(red: 0.345, green: 0.337, blue: 0.839, alpha: 1).cgColor
            case .navigationSetting:
                return UIColor(red: 1, green: 0.8, blue: 0, alpha: 1).cgColor
            case .report:
                return UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
            case .setting:
                return UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            }
        }
        
    }
    
    func numberOfRowsInSection() -> Int {
        return MyPageMenus.allCases.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> MyPageMenus {
        return MyPageMenus.allCases[indexPath.row]
    }
    
    func didSelectRowAt(indexPath: IndexPath) -> MyPageMenus {
        return MyPageMenus.allCases[indexPath.row]
    }
    
}
