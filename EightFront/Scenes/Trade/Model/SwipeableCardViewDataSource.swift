//
//  SwipeableCardViewDataSource.swift
//  EightFront
//
//  Created by wargi on 2022/10/26.
//

import UIKit

protocol SwipeableCardViewDataSource: AnyObject {
    func numberOfCards() -> Int
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard
    func viewForEmptyCards() -> UIView?
}
