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
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
    }
    
    //MARK: - Binding..
    private func bind() {
        
    }
}
