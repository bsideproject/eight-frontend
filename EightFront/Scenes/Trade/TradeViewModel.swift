//
//  TradeViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/10/26.
//

import UIKit
import Combine

//MARK: TradeViewModel
final class TradeViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    var dummyData = [CardsDataModel(bgColor: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0), name: "Hamburger", image: Images.Test.hamburger.image),
                     CardsDataModel(bgColor: UIColor(red:0.29, green:0.64, blue:0.96, alpha:1.0), name: "Puppy", image: Images.Test.puppy.image),
                     CardsDataModel(bgColor: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0), name: "Poop", image: Images.Test.poop.image),
                     CardsDataModel(bgColor: UIColor(red:0.69, green:0.52, blue:0.38, alpha:1.0), name: "Panda", image: Images.Test.panda.image),
                     CardsDataModel(bgColor: UIColor(red:0.90, green:0.99, blue:0.97, alpha:1.0), name: "Subway", image: Images.Test.subway.image),
                     CardsDataModel(bgColor: UIColor(red:0.83, green:0.82, blue:0.69, alpha:1.0), name: "Robot", image: Images.Test.robot.image)]
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        
    }
}

//MARK: - I/O & Error
extension TradeViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
}

//MARK: - Method
extension TradeViewModel {
    
}
