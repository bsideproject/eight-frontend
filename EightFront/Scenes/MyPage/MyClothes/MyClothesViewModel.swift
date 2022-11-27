//
//  MyClothesViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/26.
//

import Foundation
import Combine

import Moya

class MyClothesViewModel {
    
    var clothesProvier = MoyaProvider<ClothesAPI>()
    var bag = Set<AnyCancellable>()
    
    @Published var clothesList = [PostModel]()
    
    func numberOfRowsInSection() -> Int {
        return clothesList.count
    }
    
    func indexPath(indexPath: IndexPath) -> PostModel {
        return clothesList[indexPath.row]
    }
    
    func requestMyClothes() {
        clothesProvier.requestPublisher(.myPosts)
            .sink { completion in
                switch completion {
                case .finished:
                    LogUtil.d("평가 중인 내 중고 의류 API 호출 완료")
                case .failure(let error):
                    LogUtil.e(error)
                }
            } receiveValue: { [weak self] reponse in
                let data = try? reponse.map(PostsResponse.self)
                self?.clothesList = data?.data?.posts ?? []
            }.store(in: &bag)
    }
    
    func didSelectRowAt(indexPath: IndexPath) -> Int? {
        return clothesList[indexPath.row].id
    }
    
}

struct MyCloth {
    let title: String
    let content: String
}
