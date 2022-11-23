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
    
    @Published var nickname = UserDefaults.standard.object(forKey: "nickName") as? String ?? "김에잇"

    enum MyPageMenus: CaseIterable {
        case myClothes
        case navigationSetting
        case report
        case setting
        
        var image: UIImage {
            switch self {
            case .myClothes:
                return Images.Mypage.hanger.image
            case .navigationSetting:
                return Images.Mypage.location.image
            case .report:
                return Images.Mypage.lock.image
            case .setting:
                return Images.Mypage.gear.image
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
                return SettingVC()
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
