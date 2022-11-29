//
//  SwipeCardView.swift
//  EightFront
//
//  Created by wargi on 2022/10/26.
//

import UIKit
import Kingfisher

final class SwipeCardView: UIView {
    //MARK: - Properties
    let shadowView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowRadius = 3.0
    }
    let swipeView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    let bottomLineView = UIView().then {
        $0.backgroundColor = Colors.gray001.color
    }
    var bottomTitleLabel = UILabel().then {
        $0.textColor = Colors.point.color
        $0.textAlignment = .left
        $0.font = Fonts.Pretendard.semiBold.font(size: 18)
    }
    var bottomSubTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .left
        $0.font = Fonts.Templates.body1.font
    }
    var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let backgroundView = UIView().then {
        $0.alpha = 0.0
    }
    let backgroundLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = Fonts.Pretendard.semiBold.font(size: 24)
    }
    
    var moreButton = UIButton()
    
    weak var delegate: SwipeCardDelegate?
    
    var divisor: CGFloat = 0
    let baseView = UIView()
    
    var dataSource: PostModel? {
        didSet {
            swipeView.backgroundColor = .white
            bottomTitleLabel.text = dataSource?.title
            bottomSubTitleLabel.text = dataSource?.description
            guard let imageUrl = URL(string: dataSource?.images?.first ?? "") else { return }
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        addSubview(shadowView)
        addSubview(swipeView)
        swipeView.addSubview(imageView)
        swipeView.addSubview(bottomLineView)
        swipeView.addSubview(bottomTitleLabel)
        swipeView.addSubview(bottomSubTitleLabel)
        swipeView.addSubview(backgroundView)
        backgroundView.addSubview(backgroundLabel)
        
        shadowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        swipeView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(7)
        }
        bottomLineView.snp.makeConstraints {
            $0.left.bottom.right.equalTo(swipeView)
            $0.height.equalTo(96)
        }
        bottomTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bottomLineView.snp.top).offset(18)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(26)
        }
        bottomSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bottomTitleLabel.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(22)
        }
        imageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(bottomLineView.snp.top)
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? SwipeCardView else { return }
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        let distanceFromCenter = ((UIScreen.main.bounds.width / 2) - card.center.x)
        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
        
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut)
        
        switch sender.state {
        case .ended:
            if distanceFromCenter > 90 {
                animator.addAnimations {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y)
                    self.layoutIfNeeded()
                }
                
                animator.addCompletion { [weak self] _ in
                    self?.delegate?.swipeDidEnd(on: card, isKeep: true)
                }
            } else if distanceFromCenter < -90 {
                animator.addAnimations {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y)
                    self.layoutIfNeeded()
                }
                
                animator.addCompletion { [weak self] _ in
                    self?.delegate?.swipeDidEnd(on: card, isKeep: false)
                }
            } else {
                animator.addAnimations {
                    self.backgroundView.alpha = 0.0
                    card.transform = .identity
                    card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                    self.layoutIfNeeded()
                }
            }
            
            animator.startAnimation()
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
            backgroundLabel.text = distanceFromCenter < 0 ? "버릴래요😅" : "보관해요😉"
            backgroundLabel.textColor = distanceFromCenter < 0 ? .black : .white
            backgroundView.backgroundColor = distanceFromCenter < 0 ? Colors.point.color : Colors.gray001.color
            backgroundView.alpha = abs(distanceFromCenter) / 50
        default:
            break
        }
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        guard let view = sender.view as? SwipeCardView else { return }
        delegate?.swipeDidSelect(view: view)
    }
}
