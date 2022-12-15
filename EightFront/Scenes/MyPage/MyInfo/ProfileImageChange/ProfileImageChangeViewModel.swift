//
//  ProfileImageChangeViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/12/03.
//

import Combine
import UIKit

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
        case .프로나눔러: return Images.ProfileImages.프로나눔러.image
        case .의세권주민: return Images.ProfileImages.의세권주민.image
        case .우유부단:   return Images.ProfileImages.우유부단.image
        case .프로이사러: return Images.ProfileImages.프로이사러.image
        case .풀소유:     return Images.ProfileImages.풀소유.image
        case .옷이라퍼:   return Images.ProfileImages.옷이라퍼.image
        }
    }
}

class ProfileImageChangeViewModel {
    
    var bag = Set<AnyCancellable>()
    
    @Published var selectedImage: ProfileImage?
    
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
        
    }
}
