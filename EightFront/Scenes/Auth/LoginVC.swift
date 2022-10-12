//
//  LoginVC.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/10/11.
//

import UIKit

final class LoginVC: UIViewController {
    
    // MARK: Properties
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "로그인"
        navigationController?.navigationBar.topItem?.title = "로그인"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    // MARK: MakeUI
    
    private func makeUI() {
        view.backgroundColor = .yellow
    }
    
    
    // MARK: Binding
    
}
