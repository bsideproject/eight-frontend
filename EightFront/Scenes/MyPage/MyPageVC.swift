//
//  MyPageVC.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import UIKit
import Then
import SnapKit

import KakaoSDKUser

//MARK: 마이페이지 VC


final class MyPageVC: UIViewController {
    
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bottomSheetVC = LoginBottomSheetVC()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false)
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        

    }
    
    //MARK: - Binding..
    private func bind() {
        
    }
    
    // MARK: - Actions
    
}
