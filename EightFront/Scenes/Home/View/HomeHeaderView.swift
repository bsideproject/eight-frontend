//
//  HomeHeaderView.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import Then
import SnapKit
import UIKit
//MARK: HomeHeaderView
final class HomeHeaderView: UIView {
    //MARK: - Properties
    let addressView = HomeAddressView()
    lazy var searchView = HomeSearchView().then {
        $0.layer.cornerRadius = 2.0
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = Colors.gray002.color
        
        addSubview(addressView)
        addSubview(searchView)
        
        searchView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-14)
            $0.height.equalTo(42)
        }
        addressView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalTo(searchView)
            $0.bottom.equalTo(searchView.snp.top).offset(-13)
        }
    }
}
