//
//  MyPageViewController.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import Then
import SnapKit
import UIKit

//MARK: 마이페이지 VC
final class MyPageViewController: UIViewController {
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
    
    //MARK: - Binding..
    func bind() {
        
    }
}
