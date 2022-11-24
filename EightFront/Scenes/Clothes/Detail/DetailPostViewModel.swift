//
//  DetailPostViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/11/06.
//

import UIKit
import Moya
import Combine
//MARK: DetailPostViewModel
final class DetailPostViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    var apiCall = 0
    let clothesProvider = MoyaProvider<ClothesAPI>()
    var info: DetailPostModel? {
        didSet {
            output.requestPost.send(true)
        }
    }
    var comments: [Comment]? {
        didSet {
            output.requestComments.send(true)
        }
    }
    var id: Int?
    
    
    //MARK: Initializer
    init(id: Int?) {
        self.id = id
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        input.requestPost
            .compactMap { $0 }
            .sink { [weak self] identifier in
                self?.requestPost(id: identifier)
                self?.requestComments(id: identifier)
            }
            .store(in: &bag)
        
        input.requestComments
            .compactMap { $0 }
            .sink { [weak self] identifier in
                self?.requestComments(id: identifier)
            }
            .store(in: &bag)
        
        input.requestComment
            .compactMap { $0 }
            .sink { [weak self] comment in
                self?.requestComment(text: comment)
            }
            .store(in: &bag)
        
        input.requestPostVote
            .sink { [weak self] in
                self?.requestKeepOrLock(with: $0)
            }
            .store(in: &bag)
        
        input.requestPost.send(id)
    }
}

//MARK: - I/O & Error
extension DetailPostViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        let requestPost = PassthroughSubject<Int?, Never>()
        let requestComments = PassthroughSubject<Int?, Never>()
        let requestPostVote = PassthroughSubject<String, Never>()
        let requestComment = PassthroughSubject<String?, Never>()
    }
    
    struct Output {
        let requestPost = PassthroughSubject<Bool, Never>()
        let requestComments = PassthroughSubject<Bool, Never>()
    }
}

//MARK: - Method
extension DetailPostViewModel {
    private func requestPost(id: Int) {
        clothesProvider
            .requestPublisher(.post(id: id))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    LogUtil.d(error.localizedDescription)
                    
                    guard (self?.apiCall ?? 3) < 3 else { return }
                    self?.apiCall += 1
                    self?.requestPost(id: id)
                case .finished:
                    LogUtil.d("Successed")
                    self?.apiCall = 0
                }
            } receiveValue: { [weak self] response in
                guard let responseData = try? response.map(PostResponse.self).data else { return }
                self?.info = responseData.info
            }
            .store(in: &bag)
    }
    
    private func requestComments(id: Int) {
        clothesProvider
            .requestPublisher(.comments(id: id))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    LogUtil.d(error.localizedDescription)
                    
                    guard (self?.apiCall ?? 3) < 3 else { return }
                    self?.apiCall += 1
                    self?.requestPost(id: id)
                case .finished:
                    LogUtil.d("Successed")
                    self?.apiCall = 0
                }
            } receiveValue: { [weak self] response in
                guard let responseData = try? response.map(CommentsResponse.self).data else { return }
                
                var comments = [Comment]()
                
                for component in responseData.comments ?? [] {
                    comments.append(Comment(type: 0,
                                            nickname: component.nickname,
                                            comment: component.comment,
                                            createdAt: component.createdAt))
                    comments.append(contentsOf: component.children ?? [])
                }
                
                self?.comments = comments
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
    
    private func requestComment(text: String?) {
        guard let id, let text else { return }
        
        let param = CommentRequest(comment: text)
        
        clothesProvider
            .requestPublisher(.newComment(id: id, info: param))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    LogUtil.d(error.localizedDescription)
                    
                    guard (self?.apiCall ?? 3) < 3 else { return }
                    self?.apiCall += 1
                    self?.requestPost(id: id)
                case .finished:
                    LogUtil.d("Successed")
                    self?.apiCall = 0
                    self?.input.requestComments.send(self?.id)
                }
            } receiveValue: { _ in }
            .store(in: &bag)
    }
}
