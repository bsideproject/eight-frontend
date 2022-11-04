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
    func emptyView() -> UIView?
}

protocol SwipeCardsDelegate: AnyObject {
    func swipeDidSelect(view: SwipeCardView, at index: Int)
}

protocol SwipeCardDelegate: AnyObject {
    func swipeDidEnd(on view: SwipeCardView)
    func swipeDidSelect(view: SwipeCardView)
}
