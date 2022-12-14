//
//  SwipeCardsDataSource.swift
//  EightFront
//
//  Created by wargi on 2022/10/26.
//

import UIKit

//MARK: 스와이프 카드 모델
protocol SwipeCardsDataSource: AnyObject {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeCardView
}

protocol SwipeCardsDelegate: AnyObject {
    func swipeCards(isEmpty: Bool)
    func swipeDidSelect(view: SwipeCardView, at index: Int)
}

protocol SwipeCardDelegate: AnyObject {
    func swipeDidEnd(on view: SwipeCardView, isKeep: Bool?)
    func swipeDidSelect(view: SwipeCardView)
}
