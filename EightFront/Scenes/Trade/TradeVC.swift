//
//  TradeVC.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import UIKit
import Then
import SnapKit
//MARK: 중고거래 VC
final class TradeVC: UIViewController {
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private var viewModel = TradeViewModel()
    private let stackContainer = StackContainerView()
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "버릴까 말까"
        $0.rightButton.setImage(Images.Navigation.post.image)
    }
    private let choiceLabel = UILabel().then {
        $0.text = "나였다면?"
        $0.textAlignment = .center
        $0.font = Fonts.Pretendard.semiBold.font(size: 18)
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        view.addSubview(navigationView)
        view.addSubview(stackContainer)
        view.addSubview(choiceLabel)
        
        let cardWidth = UIScreen.main.bounds.width - 32
        let cardHeight = cardWidth * 1.25
        
        stackContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.equalTo(cardWidth)
            $0.height.equalTo(cardHeight)
        }
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(47)
        }
        choiceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-44)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        stackContainer.dataSource = self
    }
    
    //MARK: - Handlers
    @objc
    private func resetTapped() {
        stackContainer.reloadData()
    }
}

extension TradeVC: SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int {
        return viewModel.dummyData.count
    }

    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModel.dummyData[index]
        return card
    }

    func emptyView() -> UIView? {
        return nil
    }   
}
