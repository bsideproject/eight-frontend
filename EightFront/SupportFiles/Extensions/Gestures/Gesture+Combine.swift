//
//  Gesture+.swift
//  EightFront
//
//  Created by wargi on 2022/11/06.
//

import Combine
import Foundation
import UIKit

enum GestureType {
    case tap
    case longpress
    case pan
    case pinch
    case swipe
    case edge
    
    var gesture: UIGestureRecognizer {
        switch self {
        case .tap:
            return UITapGestureRecognizer()
        case .longpress:
            return UILongPressGestureRecognizer()
        case .pan:
            return UIPanGestureRecognizer()
        case .pinch:
            return UIPinchGestureRecognizer()
        case .swipe:
            return UISwipeGestureRecognizer()
        case .edge:
            return UIScreenEdgePanGestureRecognizer()
        }
    }
}

// MARK: - Publisher
struct GesturePublisher: Publisher {
    public typealias Output = UIGestureRecognizer
    public typealias Failure = Never
    
    private let view: UIView
    private let event: UIGestureRecognizer
    
    public init(view: UIView, event: UIGestureRecognizer) {
        self.view = view
        self.event = event
    }
    
    public func receive<S: Subscriber>(subscriber: S) where S.Failure == GesturePublisher.Failure, S.Input == GesturePublisher.Output {
        let subscription = GestureSubscription(subscriber: subscriber,
                                               view: view,
                                               event: event)
        
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Subscription
private final class GestureSubscription<S: Subscriber>: Subscription where S.Input == UIGestureRecognizer, S.Failure == Never {
    private var subscriber: S?
    private var event: UIGestureRecognizer
    private var view: UIView
    
    init(subscriber: S, view: UIView, event: UIGestureRecognizer) {
        self.subscriber = subscriber
        self.view = view
        self.event = event
        
        configure(gesture: event)
    }
    
    private func configure(gesture: UIGestureRecognizer) {
        gesture.addTarget(self, action: #selector(gestureHandler))
        view.addGestureRecognizer(gesture)
        
        view.isUserInteractionEnabled = true
    }
    
    func request(_ demand: Subscribers.Demand) {
        
    }
    
    func cancel() {
        subscriber = nil
    }
    
    @objc
    private func gestureHandler() {
        _ = subscriber?.receive(event)
    }
}
