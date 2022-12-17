//
//  ProfileImageChangeViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/12/03.
//

import Combine
import UIKit

import Moya
import Kingfisher



enum ProfileImage: String, CaseIterable {
    case 프로나눔러
    case 의세권주민
    case 우유부단
    case 프로이사러
    case 풀소유
    case 옷이라퍼
    
    var url: String {
        switch self {
        case .프로나눔러: return ""
        case .의세권주민: return ""
        case .우유부단:   return ""
        case .프로이사러: return ""
        case .풀소유:     return ""
        case .옷이라퍼:   return ""
        }
    }
    
    var image: UIImage {
        switch self {
        case .프로나눔러: return Images.ProfileImages.default5.image
        case .의세권주민: return Images.ProfileImages.default3.image
        case .우유부단:   return Images.ProfileImages.default2.image
        case .프로이사러: return Images.ProfileImages.default6.image
        case .풀소유:     return Images.ProfileImages.default4.image
        case .옷이라퍼:   return Images.ProfileImages.default1.image
        }
    }
    
    var imageServerName: String {
        switch self {
        case .프로나눔러: return "default5"
        case .의세권주민: return "default3"
        case .우유부단:   return "default2"
        case .프로이사러: return "default6"
        case .풀소유:     return "default4"
        case .옷이라퍼:   return "default1"
        }
    }
}

class ProfileImageChangeViewModel {
    
    var bag = Set<AnyCancellable>()
    let provider = MoyaProvider<AuthAPI>()
    
    @Published var selectedImage: ProfileImage?
    
    @Published var isChanged: Bool = false
    
    lazy var isChangeButtonValid: AnyPublisher<Bool, Never> = $selectedImage
        .compactMap { profileImage in
        guard profileImage != nil else {
            return false
        }
        return true
    }.eraseToAnyPublisher()
    
    func numberOfItemsInSection() -> Int {
        return ProfileImage.allCases.count
    }
    
    func cellForItemAt(indexPath: IndexPath) -> ProfileImage {
        return ProfileImage.allCases[indexPath.row]
    }
    
    func didSelectItemAt(indexPath: IndexPath) {
        selectedImage = ProfileImage.allCases[indexPath.row]
    }
    
    func profileImageChange() {
        guard let selectedImage else { return }
        provider.requestPublisher(.profileImageChange(defaultImage: selectedImage.imageServerName))
            .compactMap { $0 }
            .sink { completion in
                switch completion {
                case .failure(let moyaError):
                    LogUtil.e(moyaError)
                case .finished:
                    LogUtil.d("프로필 이미지 변경 API 호출")
                }
            } receiveValue: { [weak self] response in
                let data = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any]
                let header = data?["header"] as? [String: Any]
                let errorCode = header?["resultCode"] as? Int
                if errorCode == 0 {
                    self?.isChanged = true
                }
            }.store(in: &bag)
    }
}
