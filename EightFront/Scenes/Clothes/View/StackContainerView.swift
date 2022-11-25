//
//  StackContainerView.swift
//  EightFront
//
//  Created by wargi on 2022/10/26.
//

import Then
import SnapKit
import UIKit
//MARK: StackContainerView
final class StackContainerView: UIView {
    //MARK: - Properties
    private var numberOfCardsToShow: Int = 0
    private var cardsToBeVisible: Int = 3
    private var cardViews : [SwipeCardView] = [] {
        didSet {
            if cardViews.isEmpty {
                if let view = dataSource?.emptyView() {
                    addSubview(view)
                }
            } else {
                
            }
        }
    }
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
    
    func removeCardTapAnimation(isLeft: Bool = true) {
        guard let card = visibleCards.last else { return }
        
        
        var cardViewFrame = bounds
        cardViewFrame.origin.x = isLeft ? -cardViewFrame.width : UIScreen.main.bounds.width + cardViewFrame.width
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
        
        animator.addAnimations { [weak self] in
            card.frame = cardViewFrame
            let xFromCenter = (isLeft ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width) - (cardViewFrame.maxX / 2)
            let divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
            let angle = tan(xFromCenter / divisor)
            card.transform = CGAffineTransform(rotationAngle: angle)
            self?.layoutIfNeeded()
        }
        
        animator.addCompletion { [weak self] _ in
            self?.swipeDidEnd(on: card)
        }
        
        animator.startAnimation()
    }
}

extension StackContainerView: SwipeCardDelegate {
    func swipeDidEnd(on view: SwipeCardView) {
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
    }
    
    func swipeDidSelect(view: SwipeCardView) {
        guard let index = cardViews.firstIndex(of: view) else { return }
        
        delegate?.swipeDidSelect(view: view, at: index)
    }
}
