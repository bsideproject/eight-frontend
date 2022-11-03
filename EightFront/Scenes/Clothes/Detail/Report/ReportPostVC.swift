//
//  ReportPostVC.swift
//  EightFront
//
//  Created by wargi on 2022/11/06.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

//MARK: 게시물 신고하기 VC
final class ReportPostVC: UIViewController {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "신고하기"
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.addSubview(navigationView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(47)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        navigationView.backButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &bag)
    }
}
