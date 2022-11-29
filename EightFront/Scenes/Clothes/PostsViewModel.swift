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
    var posts = [PostModel]()
    
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
        
        input
            .requestPosts
            .sink { [weak self] in
                self?.requestPosts(category: $0)
            }
            .store(in: &bag)
        
        input.requestPostVote
            .sink { [weak self] in
                self?.requestKeepOrLock(with: $0)
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
        var requestPosts = PassthroughSubject<String, Never>()
        let requestPostVote = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var requestCategroies = PassthroughSubject<[String], Never>()
        var requestPosts = PassthroughSubject<Void?, Never>()
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
                
                var categories = ["전체"]
                categories.append(contentsOf: responseData.categories ?? [])
                self?.output.requestCategroies.send(categories)
            }
            .store(in: &bag)
    }
    
    private func requestPosts(order: String = "LATEST", category: String = "") {
        clothesProvider
            .requestPublisher(.posts(order: order, category: category))
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
                guard let responseData = try? response.map(PostsResponse.self).data else { return }
                
                self?.posts = responseData.posts ?? []
                self?.output.requestPosts.send(nil)
            }
            .store(in: &bag)
    }
    
    private func requestKeepOrLock(with vote: String) {
        clothesProvider
            .requestPublisher(.vote(type: VoteRequest(voteType: vote)))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    LogUtil.d(error.localizedDescription)
                    
                    guard (self?.apiCall ?? 3) < 3 else { return }
                    self?.apiCall += 1
                    self?.requestKeepOrLock(with: vote)
                case .finished:
                    LogUtil.d("Successed")
                    self?.apiCall = 0
                }
            } receiveValue: { _ in }
            .store(in: &bag)
    }
}
