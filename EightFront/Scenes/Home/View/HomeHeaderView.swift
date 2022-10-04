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
    let alarmButton = UIButton().then {
        $0.setImage(Images.Home.alarm.image, for: .normal)
        $0.setImage(Images.Home.alarm.image, for: .highlighted)
    }
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
    func makeUI() {
        backgroundColor = Colors.main.color
        
        addSubview(addressView)
        addSubview(searchView)
        addSubview(alarmButton)
        
        searchView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-14)
            $0.height.equalTo(42)
        }
        alarmButton.snp.makeConstraints {
            $0.right.equalTo(searchView.snp.right)
            $0.bottom.equalTo(searchView.snp.top).offset(-18)
            $0.size.equalTo(24)
        }
        addressView.snp.makeConstraints {
            $0.centerY.equalTo(alarmButton.snp.centerY)
            $0.left.equalToSuperview().inset(48)
            $0.right.equalTo(alarmButton.snp.left).offset(8)
        }
    }
}
