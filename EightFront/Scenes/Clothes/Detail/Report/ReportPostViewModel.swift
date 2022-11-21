//
//  ReportPostViewModel.swift
//  EightFront
//
//  Created by wargi on 2022/11/20.
//

import UIKit
import Combine

//MARK: ReportPostViewModel
final class ReportPostViewModel {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    let input = Input()
    let output = Output()
    let reports = [
    "음란물",
    "불법정보를 포함",
    "청소년에게 유해한 내용",
    "욕설/생명경시/혐오/차별적 표현",
    "개인정보 노출 게시물",
    "불쾌한 표현"
    ]
    
    //MARK: Initializer
    init() {
        bind()
    }
    
    //MARK: RxBinding..
    private func bind() {
        
    }
}

//MARK: - I/O & Error
extension ReportPostViewModel {
    enum ErrorResult: Error {
        case someError
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
}

//MARK: - Method
extension ReportPostViewModel {
    
}
