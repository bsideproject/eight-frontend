//
//  MyClothesVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import UIKit
import Combine

class MyClothesVC: UIViewController {
    
    var bag = Set<AnyCancellable>()
    
    // MARK: - Properties
    private let commonNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "평가 중인 내 중고 의류"
    }
    
    private let searchView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Colors.gray006.color.cgColor
    }
    
    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    // MARK: - makeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commonNavigationView)
        commonNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(47)
        }
        
        view.addSubview(searchView)
//        searchView.snp.makeConstraints {
//        }
    }
    
    private func bind() {
        commonNavigationView.backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &bag)
    }
    
    // MARK: - Configure
    
    // MARK: - Actions
    
    // MARK: - Functions
}
