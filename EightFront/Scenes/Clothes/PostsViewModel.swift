//
//  PostsViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/10/26.
//

import UIKit
import Moya
import Combine

//MARK: 버릴까/말까 VM
final class PostsViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    var apiCall = 0
    let clothesProvider = MoyaProvider<ClothesAPI>()
    var dummyData = [CardsDataModel(bgColor: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0), title: "파타고니아 후리스", subTitle: "산지 5년 정도 된 옷이라 버릴까 고민중이에요 ㅠ", image: Images.Test.hamburger.image),
                     CardsDataModel(bgColor: UIColor(red:0.29, green:0.64, blue:0.96, alpha:1.0), title: "나이키 후드집업", subTitle: "산지 5년 정도 된 옷이라 버릴까 고민중이에요 ㅠ", image: Images.Test.puppy.image),
                     CardsDataModel(bgColor: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0), title: "아디다스 후드", subTitle: "산지 5년 정도 된 옷이라 버릴까 고민중이에요 ㅠ", image: Images.Test.poop.image),
                     CardsDataModel(bgColor: UIColor(red:0.69, green:0.52, blue:0.38, alpha:1.0), title: "폴로 니트", subTitle: "산지 5년 정도 된 옷이라 버릴까 고민중이에요 ㅠ", image: Images.Test.panda.image),
                     CardsDataModel(bgColor: UIColor(red:0.90, green:0.99, blue:0.97, alpha:1.0), title: "앤더슨벨 자켓", subTitle: "산지 5년 정도 된 옷이라 버릴까 고민중이에요 ㅠ", image: Images.Test.subway.image),
                     CardsDataModel(bgColor: UIColor(red:0.83, green:0.82, blue:0.69, alpha:1.0), title: "정장 상하의", subTitle: "산지 5년 정도 된 옷이라 버릴까 고민중이에요 ㅠ", image: Images.Test.robot.image)]
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        input
            .requestCategroies
            .sink { [weak self] _ in
                self?.requestCategories()
            }
            .store(in: &bag)
    }
}

//MARK: - I/O & Error
extension PostsViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        var requestCategroies = PassthroughSubject<Void?, Never>()
    }
    
    struct Output {
        var requestCategroies = PassthroughSubject<[String], Never>()
    }
}

//MARK: - Method
extension PostsViewModel {
    private func requestCategories() {
        clothesProvider
            .requestPublisher(.categories)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    LogUtil.d(error.localizedDescription)
                    
                    guard (self?.apiCall ?? 3) < 3 else { return }
                    self?.apiCall += 1
                    self?.requestCategories()
                case .finished:
                    LogUtil.d("Successed")
                    self?.apiCall = 0
                }
            } receiveValue: { [weak self] response in
                guard let responseData = try? response.map(CategoryResponse.self).data else { return }
                
                self?.output.requestCategroies.send(responseData.categories ?? [])
            }
            .store(in: &bag)
    }
}
