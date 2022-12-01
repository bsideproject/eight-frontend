//
//  SearchBarViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/10/07.
//

import UIKit
import Combine
import TMapSDK

//MARK: SearchBarViewModel
final class SearchBarViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    var pois = [ResponsePOI]()
    let type: SearchType
    
    //MARK: Initializer
    init(type: SearchType) {
        self.type = type
        
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        input.requestPOI
            .receive(on: DispatchQueue.global())
            .sink {
                if case let .failure(error) = $0 {
                    LogUtil.d(error.localizedDescription)
                }
            } receiveValue: { keyword in
                self.requestPOI(searchkeyword: keyword)
            }
            .store(in: &bag)
    }
}

//MARK: - I/O & Error
extension SearchBarViewModel {
    enum SearchType {
        case home
        case report
    }
    
    enum ErrorResult: Error {
        case searchError(Error?)
    }
    
    struct Input {
        var requestPOI = CurrentValueSubject<String?, ErrorResult>.init(nil)
    }
    
    struct Output {
        var resultPOIs = CurrentValueSubject<[ResponsePOI], ErrorResult>.init([])
    }
}

//MARK: - Method
extension SearchBarViewModel {
    private func requestPOI(searchkeyword: String?) {
        guard let keyword = searchkeyword, !keyword.isEmpty else {
            output.resultPOIs.send([])
            return
        }
        
        let pathData = TMapPathData()
        pathData.requestFindAllPOI(keyword, count: 20) { [weak self] result, error in
            guard let result else {
                return
            }
            
            var pois = [ResponsePOI]()
            
            for poi in result {
                var roadAddress = poi.roadName ?? ""
                roadAddress += poi.buildingNo1 == "" ? "" : " " + (poi.buildingNo1 ?? "")
                roadAddress += poi.buildingNo2 == "" || poi.buildingNo2 == "0" ? "" : "-" + (poi.buildingNo2 ?? "")
                
                let previousAddress = poi.detailAddrName ?? ""
                
                var resultAddress = poi.upperAddrName ?? ""
                resultAddress += " " + (poi.middleAddrName ?? "") + " "
                resultAddress += roadAddress.isEmpty ? previousAddress : roadAddress
                
                pois.append(ResponsePOI(name: poi.name,
                                        address: resultAddress,
                                        coordinate: poi.coordinate))
            }
            
            self?.pois = pois
            self?.output.resultPOIs.send(pois)
        }
    }
}
