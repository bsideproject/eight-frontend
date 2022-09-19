//
//  TradeViewController.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import Then
import SnapKit
import UIKit

//MARK: 중고거래 VC
final class TradeViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    //MARK: - Make UI
    func makeUI() {
        view.backgroundColor = .white
    }
    
    //MARK: - Rx Binding..
    func bind() {
        
    }
}
