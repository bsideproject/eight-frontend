//
//  initialViewController.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import Then
import SnapKit
import UIKit

//MARK: initialViewController
final class initialViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
    
    //MARK: - Make UI
    func makeUI() {
        view.backgroundColor = .white
    }
}
