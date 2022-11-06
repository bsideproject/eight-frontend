//
//  ReportLogVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/06.
//

import UIKit

class ReportLogVC: UIViewController {
    
    // MARK: - Properties
    private let commontNavigationView = CommonNavigationView().then {
        $0.titleLabel.text = "의류수거함 정보수정&신규등록 제보확인"
    }
    
    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
    
    // MARK: - makeUI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(commontNavigationView)
        commontNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(47)
        }
    }
    
    // MARK: - Configure
    
    // MARK: - Actions
    
    // MARK: - Functions
    
}
