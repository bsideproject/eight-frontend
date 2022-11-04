//
//  DetailPostVC.swift
//  EightFront
//
//  Created by wargi on 2022/11/06.
//

import Then
import SnapKit
import UIKit
import Combine

//MARK: 게시물 상세보기 VC
final class DetailPostVC: UIViewController {
    //MARK: - Properties
    let viewModel = DetailPostViewModel()
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "버릴까 말까"
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
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
            .store(in: &viewModel.bag)
    }
}

//MARK: - 옵션 선택(신고/차단)
extension DetailPostVC: ReportPopupViewDelegate {
    func cancelButtonTapped() {
        
    }
    
    func moveReport() {
        
    }
    
    func moveCutoff() {
        
    }
}

//MARK: - 차단 하기
extension DetailPostVC: CutOffPopupViewDelegate {
    func cancelTapped() {
        
    }
    
    func cutoffTapped() {
        
    }
}
