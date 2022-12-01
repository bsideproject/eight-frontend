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
    var currentPage = 1
    var orderTypeForKey = "KEEP_OR_DROP_ORDER_TYPE"
    var categories = [String]()
    var selectedCategoryItem = Set<Int>()
    
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
            .sink { [weak self] _ in
                guard let self else { return }
                let selectCategories = self.selectedCategoryItem.compactMap { self.categories[$0] }
                self.requestPosts(categories: selectCategories)
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
    typealias PostsInput = (category: String, order: String)
    
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        var requestCategroies = PassthroughSubject<Void?, Never>()
        var requestPosts = PassthroughSubject<Void?, Never>()
        let requestPostVote = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var requestCategroies = PassthroughSubject<Void?, Never>()
        var requestPosts = PassthroughSubject<Int, Never>()
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
                
                self?.categories = categories
                self?.selectedCategoryItem = Set<Int>([0])
                self?.output.requestCategroies.send(nil)
            }
            .store(in: &bag)
    }
    
    private func requestPosts(categories: [String]) {
        var order = ""
        
        if let saveOrder = UserDefaults.standard.object(forKey: orderTypeForKey) as? String {
            order = saveOrder
        } else {
            UserDefaults.standard.set("LATEST", forKey: orderTypeForKey)
            order = "LATEST"
        }
        
        clothesProvider
            .requestPublisher(.posts(page: currentPage, order: order, categories: categories))
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
                
                let result = responseData.posts ?? []
                self?.posts = result
                self?.output.requestPosts.send(result.count)
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
