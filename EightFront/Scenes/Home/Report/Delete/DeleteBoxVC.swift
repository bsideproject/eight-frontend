//
//  DeleteBoxVC.swift
//  EightFront
//
//  Created by wargi on 2022/11/17.
//

import Then
import SnapKit
import UIKit
import Combine

protocol DeleteBoxVCDelegate: AnyObject {
    func deleteTapped()
}

//MARK: SelectMenuVC
final class DeleteBoxVC: UIViewController {
    //MARK: - Properties
    var bag = Set<AnyCancellable>()
    weak var delegate: DeleteBoxVCDelegate?
    let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    let backgroundView = UIView().then {
        $0.alpha = 0.0
        $0.backgroundColor = .black
    }
    lazy var deleteView = DeleteBoxView().then {
        $0.alpha = 0.0
        $0.delegate = self
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.backgroundView.alpha = 0.65
            self?.deleteView.alpha = 1.0
        }
    }
    
    //MARK: - Make UI
    func makeUI() {
        view.backgroundColor = .clear
        
        view.addSubview(containerView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(deleteView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        deleteView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(316)
            $0.height.equalTo(188)
        }
    }
    
    //MARK: - Binding..
    func bind() {
        backgroundView
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: false)
            }
            .store(in: &bag)
    }
}

extension DeleteBoxVC: DeleteBoxViewDelegate {
    func deleteTapped() {
        delegate?.deleteTapped()
        dismiss(animated: false)
    }
    
    func cancelTapped() {
        dismiss(animated: false)
    }
}
