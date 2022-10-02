//
//  HomeSearchVC.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import Then
import SnapKit
import UIKit
import Combine

//MARK: HomeSearchVC
final class HomeSearchVC: UIViewController {
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
