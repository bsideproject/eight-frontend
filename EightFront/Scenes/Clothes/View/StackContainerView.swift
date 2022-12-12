//
//  StackContainerView.swift
//  EightFront
//
//  Created by wargi on 2022/10/26.
//

import Then
import SnapKit
import UIKit

protocol StackContainerViewDelegate: AnyObject {
    func keepOrDrop(id: Int?, isKeep: Bool?)
}

//MARK: StackContainerView
final class StackContainerView: UIView {
    //MARK: - Properties
    weak var selectionDelegate: StackContainerViewDelegate?
    private var numberOfCardsToShow: Int = 0
    private var cardsToBeVisible: Int = 3
    private var cardViews : [SwipeCardView] = []
    private var remainingcards: Int = 0
    
    private let horizontalInset: CGFloat = 10.0
    private let verticalInset: CGFloat = 10.0
    
    private var visibleCards: [SwipeCardView] {
        return subviews as? [SwipeCardView] ?? []
    }
    weak var delegate: SwipeCardsDelegate?
    weak var dataSource: SwipeCardsDataSource? {
        didSet {
            reloadData()
        }
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        removeAllCardViews()
        
        guard let datasource = dataSource else { return }
        
        setNeedsLayout()
        layoutIfNeeded()
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingcards = numberOfCardsToShow
        
        for i in 0 ..< min(numberOfCardsToShow,cardsToBeVisible) {
            addCardView(cardView: datasource.card(at: i), atIndex: i )
        }
    }
    
    //MARK: - Configurations
    private func addCardView(cardView: SwipeCardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingcards -= 1
    }
    
    func addCardFrame(index: Int, cardView: SwipeCardView) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * self.horizontalInset)
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y -= verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        
        cardViews = []
    }
    
    func removeCardTapAnimation(isLeft: Bool = true, completion: (() -> ())? = nil) {
        guard let card = visibleCards.last else { return }
        
        card.backgroundLabel.text = isLeft ? "보관해요😉" : "버릴래요😅"
        card.backgroundLabel.textColor = isLeft ? .white : .black
        card.backgroundView.alpha = 1.0
        card.backgroundView.backgroundColor = isLeft ? Colors.gray001.color : Colors.point.color
        
        var cardViewFrame = bounds
        let cardWidth = UIScreen.main.bounds.width - 32
        cardViewFrame.origin.x = isLeft ? -cardWidth : cardWidth + 16.0
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
        
        animator.addAnimations { [weak self] in
            card.frame = cardViewFrame
            let angle = cardWidth / (cardWidth * 2)
            card.transform = CGAffineTransform(rotationAngle: isLeft ? -angle : angle)
            self?.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self] _ in
            self?.swipeDidEnd(on: card, isKeep: isLeft)
            completion?()
        }
        
        animator.startAnimation()
    }
    
    func skipCardTapAnimation() {
        guard let card = visibleCards.last else { return }
        
        var cardViewFrame = bounds
        cardViewFrame.origin.y = -UIScreen.main.bounds.height
        
        let animator = UIViewPropertyAnimator(duration: 0.41
                                              , curve: .easeInOut)
        
        animator.addAnimations { [weak self] in
            card.frame = cardViewFrame
            self?.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self] _ in
            self?.swipeDidEnd(on: card, isKeep: nil)
        }
        
        animator.startAnimation()
    }
}

extension StackContainerView: SwipeCardDelegate {
    func swipeDidEnd(on view: SwipeCardView, isKeep: Bool?) {
        guard let datasource = dataSource else { return }
        
        view.removeFromSuperview()
        
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut)
        
        if remainingcards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - remainingcards
            addCardView(cardView: datasource.card(at: newIndex), atIndex: 2)
        }
        
        for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
            animator.addAnimations {
                cardView.center = self.center
                self.addCardFrame(index: cardIndex, cardView: cardView)
                self.layoutIfNeeded()
            }
            
            animator.startAnimation()
        }
        
        selectionDelegate?.keepOrDrop(id: view.dataSource?.id, isKeep: isKeep)
        delegate?.swipeCards(isEmpty: self.subviews.isEmpty)
    }
    
    func swipeDidSelect(view: SwipeCardView) {
        guard let index = cardViews.firstIndex(of: view) else { return }
        
        delegate?.swipeDidSelect(view: view, at: index)
    }
}
