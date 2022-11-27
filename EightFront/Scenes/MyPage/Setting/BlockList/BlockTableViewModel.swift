//
//  BlockTableViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/19.
//

import Foundation
import Combine

import Moya

class BlockTableViewModel {
    
    let blockProvider = MoyaProvider<BlockAPI>()

    var bag = Set<AnyCancellable>()
    @Published var blockList = [BlockUser]()
    
    func numberOfRowsInSection() -> Int {
        return blockList.count
    }
    
    // 차단 목록 불러오기
    func requestBlockList() {
        blockProvider.requestPublisher(.blockList)
            .sink { completion in
                switch completion {
                case .finished:
                    LogUtil.d("차단 유저 목록 불러오기 API 완료")
                case .failure(let error):
                    LogUtil.e(error)
                }
            } receiveValue: { [weak self] response in
                let data = try? response.map(BlockListResponse.self)
                self?.blockList = data?.data?.users ?? []
            }.store(in: &bag)
    }
    
    // 유저 차단 해제
    func unBlockUser(indexPath: IndexPath) {
        LogUtil.d("\(indexPath.row)번째 유저 차단을 해제했습니다.")
    }
    
    
    
    
}
