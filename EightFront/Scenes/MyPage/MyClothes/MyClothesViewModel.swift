//
//  MyClothesViewModel.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/26.
//

import Foundation
import Combine

class MyClothesViewModel {
    
    var bag = Set<AnyCancellable>()
    
//    var clothesList = [MyClothes]()
    
    var clothesList = [
        MyCloth(title: "파타고니아 후리스", content: "산지 5년 정도 된 옷이라 고민 중 이에요 ㅠ"),
        MyCloth(title: "패딩", content: "김밥 패딩"),
        MyCloth(title: "플리스 자켓", content: "알파카")
    ]
    
    func numberOfRowsInSection() -> Int {
        return clothesList.count
    }
    
    func indexPath(indexPath: IndexPath) -> MyCloth {
        return clothesList[indexPath.row]
    }
    
}

struct MyCloth {
    let title: String
    let content: String
}
