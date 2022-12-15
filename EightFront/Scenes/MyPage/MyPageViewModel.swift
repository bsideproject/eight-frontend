//
//  MyPageViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/05.
//

import Foundation
import UIKit

import Combine
import Moya

final class MyPageViewModel {
    
    let authProvider = MoyaProvider<AuthAPI>()
    var bag = Set<AnyCancellable>()
    
    @Published var nickname = ""
    @Published var profileImage = ""

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
    
    func reqeustUserInfo() {
        authProvider.requestPublisher(.userInfo)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    LogUtil.d("유저 정보 가져오기 API 호출 완료")
                case .failure(let error):
                    LogUtil.e(error)
                }
            } receiveValue: { [weak self] response in
                guard let data = try? response.map(UserInfoResponse.self).data else {
                    LogUtil.e("유저 정보 가져오기 실패")
                    return
                }
                self?.nickname = data.content.nickname ?? ""
                self?.profileImage = data.content.profileImage ?? ""
            }.store(in: &bag)
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
