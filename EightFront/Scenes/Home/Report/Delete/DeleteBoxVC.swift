//
//  DeleteVC.swift
//  EightFront
//
//  Created by wargi on 2022/11/17.
//

import Then
import SnapKit
import UIKit
import Combine

//MARK: SelectMenuVC
final class SelectMenuVC: UIViewController {
    //MARK: - Properties
    let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    let backgroundView = UIView().then {
        $0.alpha = 0.0
        $0.backgroundColor = .black
    }
    let selectMenuView = SelectMenuView()
    
    //MARK: - Life Cycle
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.backgroundView.alpha = 0.65
            self?.selectMenuView.alpha = 1.0
        }
    }
    
    //MARK: - Make UI
    func makeUI() {
        view.backgroundColor = .clear
        
        view.addSubview(containerView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectMenuView)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        selectMenuView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * 0.8)
            $0.height.equalTo(fetchSelectMenuHeight())
        }
    }
    
    //MARK: - Binding..
    func bind() {
        
    }
}
