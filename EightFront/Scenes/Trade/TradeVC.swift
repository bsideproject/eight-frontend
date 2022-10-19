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
    var stackContainer: StackContainerView!
    
    
    //MARK: - Life Cycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        makeUI()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        configureNavigationBarButtonItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
        stackContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-60)
            $0.width.equalTo(300)
            $0.height.equalTo(400)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        stackContainer.dataSource = self
    }
    
    func configureNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
    }
    
    //MARK: - Handlers
    @objc
    func resetTapped() {
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
